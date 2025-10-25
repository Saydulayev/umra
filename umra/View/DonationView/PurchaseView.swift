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

    var body: some View {
        DonationView()
            // Отслеживание завершённых покупок для показа благодарственного сообщения
            .onChange(of: purchaseManager.completedDonations) { _, newValue in
                if !newValue.isEmpty {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showThankYouAlert = true
                        purchaseManager.completedDonations.removeAll()
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


