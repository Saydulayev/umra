//
//  BackgroundTaskManager.swift
//  umra
//
//  Created for background task management
//

import BackgroundTasks
import Foundation
import OSLog
import SwiftUI

@MainActor
@Observable
class BackgroundTaskManager {
    private let taskIdentifier = "saydulayev.wien-gmail.com.umra.updatePrayerTimes"
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.umra.app", category: "BackgroundTaskManager")
    
    init() {
        // Регистрация фоновой задачи теперь происходит в AppDelegate
        // для соответствия требованиям iOS 18+ - все launch handlers должны быть
        // зарегистрированы до завершения application(_:didFinishLaunchingWithOptions:)
    }
    
    /// Планирует следующее фоновое обновление
    func scheduleBackgroundRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: taskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: AppConstants.backgroundTaskInterval)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            logger.info("✅ Background refresh scheduled")
        } catch {
            logger.error("❌ Failed to schedule background task: \(error.localizedDescription, privacy: .public)")
        }
    }
}

