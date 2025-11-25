//
//  umraApp.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI
import WebKit
import BackgroundTasks

@main
struct umraApp: App {
    @State private var purchaseManager = PurchaseManager()
    @State private var themeManager = ThemeManager()
    @State private var localizationManager = LocalizationManager()
    @State private var userPreferences = UserPreferences()
    @State private var fontManager = FontManager()
    
    init() {
        // Регистрируем фоновые задачи при запуске приложения
        BackgroundTaskManager.shared.registerBackgroundTask()
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(purchaseManager)
                .environment(themeManager)
                .environment(localizationManager)
                .environment(userPreferences)
                .environment(fontManager)
        }
    }
}

