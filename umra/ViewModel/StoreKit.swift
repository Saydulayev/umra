//
//  StoreKit.swift
//  umra
//
//  Created by Akhmed on 06.12.23.
//

import Foundation
import StoreKit
import OSLog

final class TaskHolder: @unchecked Sendable {
    var task: Task<Void, Never>?
}

@MainActor
@Observable
class PurchaseManager {
    // Доступные продукты и завершённые покупки
    var availableDonations: [Product] = []
    var completedDonations: [Product] = []
    var purchaseError: String? = nil

    // Идентификаторы продуктов
    private let productIds: [String] = [
        "UmrahSunnah1", "UmrahSunnah2", "UmrahSunnah3",
        "UmrahSunnah4", "UmrahSunnah5", "UmrahSunnah6"
    ]
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.example.app", category: "PurchaseManager")
    private let updateListenerTask = TaskHolder()

    init() {
        logger.info("PurchaseManager initialized")
        updateListenerTask.task = listenForTransactions()
        Task { @MainActor in
            logger.debug("Starting product request")
            await loadProducts()
            logger.debug("Product request completed")
        }
    }
    
    deinit {
        logger.info("PurchaseManager deinitializing")
        updateListenerTask.task?.cancel()
    }
    
    /// Загрузка продуктов из App Store
    func loadProducts() async {
        do {
            logger.debug("Sending product request for identifiers: \(self.productIds, privacy: .public)")
            availableDonations = try await Product.products(for: productIds)
            logger.info("✅ Products loaded successfully. Count: \(self.availableDonations.count, privacy: .public)")
        } catch {
            logger.error("❌ Failed to load products: \(error.localizedDescription, privacy: .public)")
            //purchaseError = "Не удалось загрузить продукты: \(error.localizedDescription)"
        }
    }
    
    /// Отслеживание обновлений транзакций
    func listenForTransactions() -> Task<Void, Never> {
        logger.info("Starting transaction listener")
        return Task {
            for await result in Transaction.updates {
                logger.debug("Received transaction update")
                do {
                    let transaction = try checkVerified(result)
                    // Просто завершаем транзакцию, так как purchase() уже обработал покупку
                    await transaction.finish()
                    logger.info("✅ Transaction finalized: \(transaction.productID, privacy: .public)")
                } catch {
                    logger.error("❌ Transaction verification failed: \(error.localizedDescription, privacy: .public)")
                }
            }
        }
    }
    
    /// Процесс покупки продукта
    func purchase(_ product: Product) async {
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
                    // Для одноразовых пожертвований просто добавляем каждый продукт
                    // Пользователь может жертвовать сколько угодно раз
                    completedDonations.append(product)
                    logger.info("✅ Product \(product.id, privacy: .public) added to completed donations")
                    logger.info("Total completed donations: \(self.completedDonations.count, privacy: .public)")
                } catch {
                    logger.error("❌ Verification error after purchase for \(product.displayName, privacy: .public): \(error.localizedDescription, privacy: .public)")
                    throw PurchaseError.verificationFailed
                }
            case .pending:
                logger.info("Purchase for \(product.displayName, privacy: .public) is pending")
            case .userCancelled:
                logger.info("Purchase for \(product.displayName, privacy: .public) cancelled by user")
            @unknown default:
                break
            }
        } catch {
            logger.error("❌ Purchase failed: \(error.localizedDescription, privacy: .public)")
            //purchaseError = "Ошибка при покупке: \(error.localizedDescription)"
        }
    }
    
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
    
    enum PurchaseError: Error {
        case verificationFailed
    }
}






