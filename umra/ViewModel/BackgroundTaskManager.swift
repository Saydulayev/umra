//
//  BackgroundTaskManager.swift
//  umra
//
//  Created for background task management
//

import BackgroundTasks
import Foundation
import SwiftUI

@MainActor
@Observable
class BackgroundTaskManager {
    private let taskIdentifier = "saydulayev.wien-gmail.com.umra.updatePrayerTimes"
    
    init() {
        // Регистрация фоновой задачи теперь происходит в AppDelegate
        // для соответствия требованиям iOS 18+ - все launch handlers должны быть
        // зарегистрированы до завершения application(_:didFinishLaunchingWithOptions:)
    }
    
    /// Планирует следующее фоновое обновление
    func scheduleBackgroundRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: taskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 3600) // через 1 час
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("✅ Background refresh scheduled")
        } catch {
            print("❌ Failed to schedule background task: \(error)")
        }
    }
}

