//
//  SubscriptionView.swift
//  umra
//
//  Created by Akhmed on 06.12.23.
//

import SwiftUI

struct DonationView: View {
    @Environment(PurchaseManager.self) private var purchaseManager
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @State private var isPurchased = false
    @State private var showingSheet = false

    var body: some View {
        VStack {
            Button(action: {
                showingSheet = true
            }) {
                HStack {
                    Image(systemName: "dollarsign.circle")
                        .foregroundStyle(themeManager.selectedTheme.primaryColor)
                    Text("text_button_support_string", bundle: localizationManager.bundle)
                        .foregroundStyle(.black)
                    Spacer()
                }
                .customTextStyleWithTheme()
            }
            .sheet(isPresented: $showingSheet) {
                DonationSheetView(isPresented: $showingSheet, isPurchased: $isPurchased)
            }
        }
    }
}


//#Preview {
//    DonationView().environmentObject( StoreVM())
//}
