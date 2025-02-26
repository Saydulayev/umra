//
//  SubscriptionView.swift
//  umra
//
//  Created by Akhmed on 06.12.23.
//

import SwiftUI

struct DonationView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var settings: UserSettings
    @State private var isPurchased = false
    @State private var showingSheet = false

    var body: some View {
        VStack {
            Button(action: {
                showingSheet = true
            }) {
                HStack {
                    Image(systemName: "heart")
                        .foregroundStyle(.red)
                    Text("text_button_support_string", bundle: settings.bundle)
                        .foregroundStyle(.blue)
                    Spacer()
                }
                .customTextStyle()
            }
            .sheet(isPresented: $showingSheet) {
                DonationSheetView(isPresented: $showingSheet, isPurchased: $isPurchased, purchaseManager: purchaseManager)
            }
        }
    }
}


//#Preview {
//    DonationView().environmentObject( StoreVM())
//}
