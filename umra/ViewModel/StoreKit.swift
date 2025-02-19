//
//  StoreKit.swift
//  umra
//
//  Created by Akhmed on 06.12.23.
//

import Foundation
import StoreKit

@MainActor
class StoreVM: ObservableObject {
    @Published var availableDonations: [Product] = []
    @Published var completedDonations: [Product] = []

    private let productIds: [String] = [
        "UmrahSunnah1", "UmrahSunnah2", "UmrahSunnah3",
        "UmrahSunnah4", "UmrahSunnah5", "UmrahSunnah6"
    ]

    var updateListenerTask: Task<Void, Never>? = nil

    init() {
        updateListenerTask = listenForTransactions()

        Task {
            await requestProducts()
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    /// Мониторинг транзакций
    func listenForTransactions() -> Task<Void, Never> {
        return Task {
            for await result in Transaction.updates {
                do {
                    let transaction = try checkVerified(result)
                    await transaction.finish()
                    print("✅ Transaction completed: \(transaction)")
                } catch {
                    print("❌ Transaction verification failed: \(error.localizedDescription)")
                }
            }
        }
    }

    /// Запрос продуктов из App Store
    func requestProducts() async {
        do {
            availableDonations = try await Product.products(for: productIds)
            print("✅ Products loaded successfully")
        } catch {
            print("❌ Failed to load products: \(error.localizedDescription)")
        }
    }

    /// Покупка продукта
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()

        if case .success(let verification) = result {
            let transaction = try checkVerified(verification)
            await transaction.finish()
            return transaction
        }

        return nil
    }

    /// Верификация покупки
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified:
            throw StoreError.failedVerification
        }
    }
}

public enum StoreError: Error {
    case failedVerification
}




