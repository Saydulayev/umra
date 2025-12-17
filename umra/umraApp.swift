//
//  umraApp.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI
import WebKit
import BackgroundTasks
import UIKit

@main
struct umraApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var purchaseManager = PurchaseManager()
    @State private var themeManager = ThemeManager()
    @State private var localizationManager = LocalizationManager()
    @State private var userPreferences = UserPreferences()
    @State private var fontManager = FontManager()
    @State private var backgroundTaskManager = BackgroundTaskManager()
    @State private var audioManager = AudioManager()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(purchaseManager)
                .environment(themeManager)
                .environment(localizationManager)
                .environment(userPreferences)
                .environment(fontManager)
                .environment(backgroundTaskManager)
                .environment(audioManager)
        }
    }
}

// MARK: - AppDelegate для регистрации фоновых задач
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Регистрируем фоновые задачи синхронно при запуске приложения
        // Это требуется iOS 18+ - все launch handlers должны быть зарегистрированы
        // до завершения application(_:didFinishLaunchingWithOptions:)
        let taskIdentifier = "saydulayev.wien-gmail.com.umra.updatePrayerTimes"
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskIdentifier, using: nil) { task in
            // Обработка фоновой задачи
            if let refreshTask = task as? BGAppRefreshTask {
                self.handleAppRefresh(task: refreshTask)
            }
        }
        print("✅ Background task registered in AppDelegate")
        return true
    }
    
    private func handleAppRefresh(task: BGAppRefreshTask) {
        // Планируем следующее обновление
        let request = BGAppRefreshTaskRequest(identifier: "saydulayev.wien-gmail.com.umra.updatePrayerTimes")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 3600)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("❌ Failed to schedule background task: \(error)")
        }
        
        // Уведомляем о необходимости обновления времен молитв
        NotificationCenter.default.post(
            name: NSNotification.Name("UpdatePrayerTimesBackground"),
            object: nil
        )
        
        task.setTaskCompleted(success: true)
    }
}

