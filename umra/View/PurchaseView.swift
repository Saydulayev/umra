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

    var body: some View {
        VStack {
            if storeVM.purchasedSubscriptions.isEmpty {
                SubscriptionView()
            } else {
                Text("Thank you for your support!")
            }
        }
        .environmentObject(storeVM)
    }
}

#Preview {
    PurchaseView()
}
