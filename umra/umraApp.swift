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
    @StateObject private var purchaseManager = PurchaseManager()
    let userSettings = UserSettings()
    let fontManager = FontManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(purchaseManager)
                .environmentObject(userSettings)
                .environmentObject(fontManager)
        }
    }
}

