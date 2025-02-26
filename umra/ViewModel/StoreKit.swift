//
//  StoreKit.swift
//  umra
//
//  Created by Akhmed on 06.12.23.
//

import Foundation
import StoreKit
import OSLog

@MainActor
class StoreVM: ObservableObject {
    @Published var availableDonations: [Product] = []
    @Published var completedDonations: [Product] = []
    
    private let productIds: [String] = [
        "UmrahSunnah1", "UmrahSunnah2", "UmrahSunnah3",
        "UmrahSunnah4", "UmrahSunnah5", "UmrahSunnah6"
    ]
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.example.app", category: "StoreVM")
    
    var updateListenerTask: Task<Void, Never>? = nil
    
    init() {
        logger.info("StoreVM initialized")
        updateListenerTask = listenForTransactions()
        
        Task {
            logger.debug("Starting product request")
            await requestProducts()
            logger.debug("Product request completed")
        }
    }
    
    deinit {
        logger.info("StoreVM deinitializing")
        updateListenerTask?.cancel()
    }
    
    /// Мониторинг транзакций
    func listenForTransactions() -> Task<Void, Never> {
        logger.info("Starting transaction listener")
        return Task {
            for await result in Transaction.updates {
                logger.debug("Received transaction update")
                do {
                    let transaction = try checkVerified(result)
                    await transaction.finish()
                    logger.info("✅ Transaction completed successfully: \(String(describing: transaction))")
                    
                    // Поиск продукта по productID из транзакции и добавление его в список завершённых покупок
                    if let product = availableDonations.first(where: { $0.id == transaction.productID }) {
                        completedDonations.append(product)
                    } else {
                        logger.warning("Could not find product for transaction with productID: \(transaction.productID, privacy: .public)")
                    }
                } catch {
                    logger.error("❌ Transaction verification failed: \(error.localizedDescription, privacy: .public)")
                }
            }
        }
    }
    
    /// Запрос продуктов из App Store
    func requestProducts() async {
        do {
            logger.debug("Sending product request for identifiers: \(self.productIds, privacy: .public)")
            availableDonations = try await Product.products(for: productIds)
            logger.info("✅ Products loaded successfully. Number of products: \(self.availableDonations.count, privacy: .public)")
        } catch {
            logger.error("❌ Failed to load products: \(error.localizedDescription, privacy: .public)")
        }
    }
    
    /// Покупка продукта
    func purchase(_ product: Product) async throws -> Transaction? {
        logger.debug("Starting purchase process for product: \(product.displayName, privacy: .public)")
        let result = try await product.purchase()
        logger.debug("Purchase result received")
        
        if case .success(let verification) = result {
            do {
                let transaction = try checkVerified(verification)
                await transaction.finish()
                logger.info("✅ Purchase of product \(product.displayName, privacy: .public) completed successfully")
                // Добавляем успешно купленный продукт в массив завершённых покупок
                completedDonations.append(product)
                return transaction
            } catch {
                logger.error("❌ Verification error after purchase for product \(product.displayName, privacy: .public): \(error.localizedDescription, privacy: .public)")
                throw error
            }
        } else {
            logger.info("Purchase for product \(product.displayName, privacy: .public) did not result in a successful transaction")
        }
        return nil
    }
    
    /// Верификация покупки
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe):
            logger.debug("Verification successful")
            return safe
        case .unverified:
            logger.error("Verification failed")
            throw StoreError.failedVerification
        }
    }
}

public enum StoreError: Error {
    case failedVerification
}





