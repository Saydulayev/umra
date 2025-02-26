//
//  PurchaseView.swift
//  umra
//
//  Created by Akhmed on 06.12.23.
//


import SwiftUI

struct PurchaseView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    @State private var showThankYouAlert = false

    var body: some View {
        DonationView()
            .environmentObject(purchaseManager)
            // Отслеживание завершённых покупок для показа благодарственного сообщения
            .onChange(of: purchaseManager.completedDonations) { newValue in
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


