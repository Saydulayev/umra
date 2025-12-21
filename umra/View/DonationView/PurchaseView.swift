//
//  PurchaseView.swift
//  umra
//
//  Created by Akhmed on 06.12.23.
//


import SwiftUI

struct PurchaseView: View {
    @Environment(PurchaseManager.self) private var purchaseManager
    @State private var showThankYouAlert = false
    @State private var lastDonationCount = 0

    var body: some View {
        DonationView()
            // Отслеживание завершённых покупок для показа благодарственного сообщения
            .onChange(of: purchaseManager.completedDonations.count) { oldCount, newCount in
                // Показываем алерт только если количество пожертвований увеличилось
                if newCount > lastDonationCount {
                    lastDonationCount = newCount
                    Task { @MainActor in
                        // Небольшая задержка для плавного отображения
                        try? await Task.sleep(for: .seconds(0.5))
                        showThankYouAlert = true
                    }
                }
            }
            .alert("جزاك الله خيراً", isPresented: $showThankYouAlert, actions: {
                Button("OK", role: .cancel) {
                    showThankYouAlert = false
                }
            })
    }
}


