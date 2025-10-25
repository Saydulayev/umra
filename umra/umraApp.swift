//
//  umraApp.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI
import WebKit

@main
struct umraApp: App {
    @State private var purchaseManager = PurchaseManager()
    @State private var themeManager = ThemeManager()
    @State private var localizationManager = LocalizationManager()
    @State private var userPreferences = UserPreferences()
    @State private var fontManager = FontManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(purchaseManager)
                .environment(themeManager)
                .environment(localizationManager)
                .environment(userPreferences)
                .environment(fontManager)
        }
    }
}

