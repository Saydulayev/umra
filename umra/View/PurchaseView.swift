//
//  PurchaseView.swift
//  umra
//
//  Created by Akhmed on 06.12.23.
//

import SwiftUI

import SwiftUI
import StoreKit

struct PurchaseView: View {
    @StateObject var storeVM = StoreVM()
    var body: some View {
        VStack {
            if let subscriptionGroupStatus = storeVM.subscriptionGroupStatus {
                if subscriptionGroupStatus == .expired || subscriptionGroupStatus == .revoked {
                    Text("Welcome back, give the donation another try.")
                    //display products
                }
            }
            if storeVM.purchasedSubscriptions.isEmpty {
                SubscriptionView()
                
            } else {
                Text("Premium Content")
            }
        }
        .environmentObject(storeVM)
    }
}

#Preview {
    PurchaseView()
}
