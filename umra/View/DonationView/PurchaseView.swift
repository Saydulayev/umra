//
//  PurchaseView.swift
//  umra
//
//  Created by Akhmed on 06.12.23.
//


import SwiftUI
import StoreKit

struct PurchaseView: View {
    @StateObject var storeVM = StoreVM()
    @State private var showThankYouAlert = false

    var body: some View {
        DonationView()
            .environmentObject(storeVM)
            // Отслеживаем, когда массив завершённых покупок становится не пустым,
            // и сразу очищаем его, чтобы алерт не показывался повторно.
            .onChange(of: storeVM.completedDonations) { newValue in
                if !newValue.isEmpty {
                    showThankYouAlert = true
                    // Очистка массива завершённых покупок после срабатывания алерта
                    storeVM.completedDonations.removeAll()
                }
            }
            // Показываем алерт, когда произошла покупка
            .alert("جزاك الله خيراً", isPresented: $showThankYouAlert, actions: {
                Button("OK", role: .cancel) { }
            })
    }
}

#Preview {
    PurchaseView()
}
