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
            // Отслеживаем, когда массив покупок становится не пустым
            .onChange(of: storeVM.completedDonations) { newValue in
                if !newValue.isEmpty {
                    showThankYouAlert = true
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
