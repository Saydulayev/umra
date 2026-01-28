//
//  SubscriptionView.swift
//  umra
//
//  Created by Akhmed on 06.12.23.
//

import SwiftUI

struct DonationView: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @State private var isPurchased = false
    @State private var showingSheet = false

    var body: some View {
        Button(action: {
            showingSheet = true
        }) {
            SettingsRow(
                icon: "dollarsign.circle",
                title: Text("text_button_support_string", bundle: localizationManager.bundle),
                accentColor: themeManager.selectedTheme.primaryColor
            )
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingSheet) {
            DonationSheetView(isPresented: $showingSheet, isPurchased: $isPurchased)
        }
    }
}


//#Preview {
//    DonationView().environmentObject( StoreVM())
//}
