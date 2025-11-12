//
//  BackgroundTaskManager.swift
//  umra
//
//  Created for background task management
//

import BackgroundTasks
import Foundation

class BackgroundTaskManager {
    static let shared = BackgroundTaskManager()
    
    private let taskIdentifier = "saydulayev.wien-gmail.com.umra.updatePrayerTimes"
    private var isRegistered = false
    
    private init() {}
    
    /// Регистрирует фоновую задачу. Должна вызываться ОДИН РАЗ при запуске приложения.
    func registerBackgroundTask() {
        guard !isRegistered else {
            print("⚠️ Background task already registered, skipping duplicate registration")
            return
        }
        
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: taskIdentifier,
            using: nil
        ) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        
        isRegistered = true
        print("✅ Background task registered successfully")
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
    
    /// Обрабатывает фоновое обновление
    private func handleAppRefresh(task: BGAppRefreshTask) {
        // Планируем следующее обновление
        scheduleBackgroundRefresh()
        
        // Уведомляем о необходимости обновления времен молитв
        NotificationCenter.default.post(
            name: NSNotification.Name("UpdatePrayerTimesBackground"),
            object: nil
        )
        
        task.setTaskCompleted(success: true)
        print("✅ Background task completed")
    }
}

