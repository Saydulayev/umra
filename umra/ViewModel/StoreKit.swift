//
//  StoreKit.swift
//  umra
//
//  Created by Akhmed on 06.12.23.
//

import Foundation
import StoreKit
import OSLog
import UIKit

// MARK: - Task Holder

actor TaskHolder {
    private var task: Task<Void, Never>?
    
    func setTask(_ newTask: Task<Void, Never>?) {
        task?.cancel()
        task = newTask
    }
    
    func cancel() {
        task?.cancel()
        task = nil
    }
}

// MARK: - Purchase Manager

@MainActor
@Observable
class PurchaseManager {
    // Доступные продукты и завершённые покупки
    var availableDonations: [Product] = []
    var completedDonations: [Product] = []
    var purchaseError: PurchaseError? = nil
    // Информация о pending транзакциях
    private var pendingTransactions: [String: Date] = [:]

    // Идентификаторы продуктов
    private let productIds: [String] = ProductID.allProductIDs
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.umra.app", category: "PurchaseManager")
    private nonisolated let updateListenerTask = TaskHolder()

    init() {
        logger.info("PurchaseManager initialized")
        Task {
            await updateListenerTask.setTask(listenForTransactions())
        }
        Task { @MainActor in
            logger.debug("Starting product request")
            await loadProducts()
            logger.debug("Product request completed")
            // Проверяем текущие транзакции при запуске
            await checkCurrentTransactions()
        }
    }
    
    deinit {
        logger.info("PurchaseManager deinitializing")
        let taskHolder = updateListenerTask
        Task.detached {
            await taskHolder.cancel()
        }
    }
    
    // MARK: - Product Management
    
    /// Загрузка продуктов из App Store
    func loadProducts() async {
        do {
            logger.debug("Sending product request for identifiers: \(self.productIds, privacy: .public)")
            availableDonations = try await Product.products(for: productIds)
            logger.info("✅ Products loaded successfully. Count: \(self.availableDonations.count, privacy: .public)")
            
            if availableDonations.isEmpty {
                logger.warning("⚠️ No products found for identifiers: \(self.productIds, privacy: .public)")
            }
        } catch {
            let purchaseError = mapToPurchaseError(error)
            logger.error("❌ Failed to load products: \(purchaseError.localizedDescription, privacy: .public)")
            self.purchaseError = purchaseError
        }
    }
    
    /// Преобразует системные ошибки в PurchaseError
    private func mapToPurchaseError(_ error: Error) -> PurchaseError {
        switch error {
        case let storeKitError as StoreKitError:
            switch storeKitError {
            case .networkError:
                return .networkError
            default:
                return .unknown(error)
            }
        default:
            return .unknown(error)
        }
    }
    
    // MARK: - Transaction Handling
    
    /// Отслеживание обновлений транзакций
    /// Для consumable продуктов (пожертвования) транзакции не создают entitlements,
    /// поэтому просто завершаем их после верификации
    func listenForTransactions() -> Task<Void, Never> {
        logger.info("Starting transaction listener")
        return Task {
            for await result in Transaction.updates {
                logger.debug("Received transaction update")
                do {
                    let transaction = try checkVerified(result)
                    // Для consumable продуктов просто завершаем транзакцию,
                    // так как purchase() уже обработал покупку и добавил продукт в completedDonations
                    await transaction.finish()
                    logger.info("✅ Transaction finalized: \(transaction.productID, privacy: .public)")
                } catch {
                    logger.error("❌ Transaction verification failed: \(error.localizedDescription, privacy: .public)")
                }
            }
        }
    }
    
    /// Процесс покупки продукта
    func purchase(_ product: Product) async throws {
        do {
            logger.debug("Starting purchase for product: \(product.displayName, privacy: .public)")
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                do {
                    let transaction = try checkVerified(verification)
                    await transaction.finish()
                    logger.info("✅ Purchase of \(product.displayName, privacy: .public) completed successfully")
                    // Добавляем успешно купленный продукт в список завершённых покупок
                    // Для одноразовых пожертвований (consumable) просто добавляем каждый продукт
                    // Пользователь может жертвовать сколько угодно раз
                    completedDonations.append(product)
                    logger.info("✅ Product \(product.id, privacy: .public) added to completed donations")
                    logger.info("Total completed donations: \(self.completedDonations.count, privacy: .public)")
                    purchaseError = nil
                } catch {
                    let purchaseError = mapToPurchaseError(error)
                    logger.error("❌ Verification error after purchase for \(product.displayName, privacy: .public): \(purchaseError.localizedDescription, privacy: .public)")
                    self.purchaseError = purchaseError
                    throw purchaseError
                }
            case .pending:
                logger.info("Purchase for \(product.displayName, privacy: .public) is pending")
                // Сохраняем информацию о pending транзакции для последующей проверки
                pendingTransactions[product.id] = Date()
                purchaseError = .purchasePending
                throw PurchaseError.purchasePending
            case .userCancelled:
                logger.info("Purchase for \(product.displayName, privacy: .public) cancelled by user")
                purchaseError = .purchaseCancelled
                throw PurchaseError.purchaseCancelled
            @unknown default:
                let error = PurchaseError.unknown(NSError(domain: "PurchaseManager", code: -1))
                purchaseError = error
                throw error
            }
        } catch let error as PurchaseError {
            logger.error("❌ Purchase failed: \(error.localizedDescription, privacy: .public)")
            purchaseError = error
            throw error
        } catch {
            let purchaseError = mapToPurchaseError(error)
            logger.error("❌ Purchase failed: \(purchaseError.localizedDescription, privacy: .public)")
            self.purchaseError = purchaseError
            throw purchaseError
        }
    }
    
    /// Проверка текущих транзакций при запуске приложения
    /// Для consumable продуктов это не критично, но помогает обработать незавершенные транзакции
    func checkCurrentTransactions() async {
        logger.debug("Checking current transactions")
        // Проверяем текущие entitlements (для consumable продуктов это обычно пусто)
        // Transaction.currentEntitlements не выбрасывает ошибки, это просто async sequence
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                logger.info("Found current transaction: \(transaction.productID, privacy: .public)")
                // Для consumable продуктов просто завершаем транзакцию
                await transaction.finish()
                logger.info("✅ Current transaction finalized: \(transaction.productID, privacy: .public)")
            } catch {
                logger.error("❌ Failed to verify current transaction: \(error.localizedDescription, privacy: .public)")
            }
        }
        
        // Проверяем статус pending транзакций
        await checkPendingTransactionsStatus()
    }
    
    /// Проверка статуса pending транзакций
    /// Удаляет старые pending транзакции (старше 24 часов)
    func checkPendingTransactionsStatus() async {
        let now = Date()
        let oneDayAgo = now.addingTimeInterval(-AppConstants.pendingTransactionExpirationInterval)
        
        for (productId, date) in pendingTransactions {
            if date < oneDayAgo {
                logger.info("Removing old pending transaction: \(productId, privacy: .public)")
                pendingTransactions.removeValue(forKey: productId)
            } else {
                logger.info("Pending transaction still active: \(productId, privacy: .public), age: \(now.timeIntervalSince(date), privacy: .public) seconds")
            }
        }
    }
    
    /// Обработка refund запроса
    /// Для consumable продуктов (пожертвования) refund обычно не применим,
    /// но метод добавлен для полноты реализации StoreKit 2
    @available(iOS 15.0, *)
    func requestRefund(for transaction: Transaction, in scene: UIWindowScene) async -> Bool {
        logger.info("Requesting refund for transaction: \(transaction.productID, privacy: .public)")
        do {
            let status = try await Transaction.beginRefundRequest(for: transaction.id, in: scene)
            switch status {
            case .userCancelled:
                logger.info("Refund request cancelled by user")
                return false
            case .success:
                logger.info("✅ Refund request successful")
                // Удаляем продукт из списка завершённых покупок при успешном refund
                completedDonations.removeAll { $0.id == transaction.productID }
                return true
            @unknown default:
                logger.warning("Unknown refund status")
                return false
            }
        } catch {
            logger.error("❌ Refund request failed: \(error.localizedDescription, privacy: .public)")
            return false
        }
    }
    
    // MARK: - Error Handling
    
    /// Верификация транзакции
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe):
            logger.debug("Verification successful")
            return safe
        case .unverified:
            logger.error("Verification failed")
            throw PurchaseError.verificationFailed
        }
    }
    
    enum PurchaseError: Error, Sendable {
        case verificationFailed
        case productNotFound
        case purchaseCancelled
        case purchasePending
        case networkError
        case unknown(Error)
        
        var localizedDescription: String {
            switch self {
            case .verificationFailed:
                return "Transaction verification failed"
            case .productNotFound:
                return "Product not found"
            case .purchaseCancelled:
                return "Purchase was cancelled by user"
            case .purchasePending:
                return "Purchase is pending approval"
            case .networkError:
                return "Network error occurred"
            case .unknown(let error):
                return "Unknown error: \(error.localizedDescription)"
            }
        }
    }
}






