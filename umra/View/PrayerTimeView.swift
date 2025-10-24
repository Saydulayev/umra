//
//  PrayerTimeView.swift
//  umra
//
//  Created by Akhmed on 29.04.24.
//

import Adhan
import BackgroundTasks
import SwiftUI
import UserNotifications


struct PrayerTimeView: View {
    @State private var prayerTimes: [String: String] = [:]
    @State private var nextPrayerName = ""
    @State private var timeUntilNextPrayer = ""
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var storedPrayerTimes: PrayerTimes? = nil
    @EnvironmentObject var settings: UserSettings

    @AppStorage("enable30MinNotifications") private var enable30MinNotifications: Bool = true
    @AppStorage("enablePrayerTimeNotifications") private var enablePrayerTimeNotifications: Bool = true
    @AppStorage("enableSunriseNotifications") private var enableSunriseNotifications: Bool = true

    private let islamicDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .islamicUmmAlQura)
        formatter.locale = Locale(identifier: "en_EN")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()

    private let prayerTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(identifier: "Asia/Riyadh")
        return formatter
    }()

    var currentIslamicDate: String {
        return islamicDateFormatter.string(from: Date())
    }

    var body: some View {
        ZStack {
            settings.selectedTheme.lightBackgroundColor
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Mecca,")
                    Text(currentIslamicDate)
                }
                .font(.custom("Savoye LET", size: 36))
                .foregroundStyle(.black)
                .padding(-5)
                Divider()
                
                Text("\(nextPrayerName) in \(timeUntilNextPrayer)")
                    .cardStyled(theme: settings.selectedTheme)

                Group {
                    PrayerTimeRow(prayerName: "Fajr", prayerTime: prayerTimes["Fajr"] ?? "")
                    PrayerTimeRow(prayerName: "Sunrise", prayerTime: prayerTimes["Sunrise"] ?? "")
                        .capsuleStyled(theme: settings.selectedTheme)
                    PrayerTimeRow(prayerName: "Dhuhr", prayerTime: prayerTimes["Dhuhr"] ?? "")
                    PrayerTimeRow(prayerName: "Asr", prayerTime: prayerTimes["Asr"] ?? "")
                    PrayerTimeRow(prayerName: "Maghrib", prayerTime: prayerTimes["Maghrib"] ?? "")
                    PrayerTimeRow(prayerName: "Isha", prayerTime: prayerTimes["Isha"] ?? "")
                    PrayerTimeRow(prayerName: "Qiyam", prayerTime: prayerTimes["Qiyam"] ?? "")
                        .capsuleStyled(theme: settings.selectedTheme)
                }
                .foregroundStyle(.black)
                .padding(.horizontal)
            }
            .transparentStyled(theme: settings.selectedTheme)
            .onAppear {
                setupPrayerTimes()
                requestNotificationPermission()
                registerBackgroundTask()
            }
            .onReceive(timer) { _ in
                updatePrayerTimes()
            }
            .onDisappear {
                timer.upstream.connect().cancel()
            }
            .onChange(of: enable30MinNotifications) { _ in
                updateNotifications()
            }
            .onChange(of: enablePrayerTimeNotifications) { _ in
                updateNotifications()
            }
            // ↓ Добавлено, чтобы пересоздавать уведомления при изменении тумблера Sunrise
            .onChange(of: enableSunriseNotifications) { _ in
                updateNotifications()
            }
        }
    }

    func setupPrayerTimes() {
        updatePrayerTimes()
    }

    func updatePrayerTimes() {
        let cal = Calendar(identifier: .gregorian)
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        let todayDateComponents = cal.dateComponents([.year, .month, .day], from: today)
        let tomorrowDateComponents = cal.dateComponents([.year, .month, .day], from: tomorrow)
        let coordinates = Coordinates(latitude: 21.4225, longitude: 39.8262)
        var params = CalculationMethod.ummAlQura.params
        params.madhab = .shafi

        DispatchQueue.global(qos: .background).async {
            guard let todayPrayers = PrayerTimes(coordinates: coordinates,
                                                 date: todayDateComponents,
                                                 calculationParameters: params),
                  let tomorrowPrayers = PrayerTimes(coordinates: coordinates,
                                                    date: tomorrowDateComponents,
                                                    calculationParameters: params) else {
                print("Error initializing PrayerTimes")
                return
            }

            let maghribToFajrInterval = tomorrowPrayers.fajr.timeIntervalSince(todayPrayers.maghrib)
            let lastThirdStart = todayPrayers.maghrib.addingTimeInterval(2 * maghribToFajrInterval / 3)

            let newPrayerTimes: [String: String] = [
                "Fajr": prayerTimeFormatter.string(from: todayPrayers.fajr),
                "Sunrise": prayerTimeFormatter.string(from: todayPrayers.sunrise),
                "Dhuhr": prayerTimeFormatter.string(from: todayPrayers.dhuhr),
                "Asr": prayerTimeFormatter.string(from: todayPrayers.asr),
                "Maghrib": prayerTimeFormatter.string(from: todayPrayers.maghrib),
                "Isha": prayerTimeFormatter.string(from: todayPrayers.isha),
                "Qiyam": prayerTimeFormatter.string(from: lastThirdStart)
            ]

            DispatchQueue.main.async {
                self.prayerTimes = newPrayerTimes
                self.updateCountdownToNextPrayer(prayers: todayPrayers)
                self.storedPrayerTimes = todayPrayers
                self.scheduleNotifications(prayerTimes: todayPrayers)
            }
        }
    }

    func updateCountdownToNextPrayer(prayers: PrayerTimes) {
        let now = Date()

        let prayerTimes = [
            ("Fajr", prayers.fajr),
            ("Sunrise", prayers.sunrise),
            ("Dhuhr", prayers.dhuhr),
            ("Asr", prayers.asr),
            ("Maghrib", prayers.maghrib),
            ("Isha", prayers.isha)
        ]

        let nextPrayer = prayerTimes.first { $0.1 > now }
        nextPrayerName = nextPrayer?.0 ?? "Fajr"

        let nextPrayerTime = nextPrayer?.1 ?? prayers.fajr.addingTimeInterval(24 * 60 * 60)
        let countdown = Calendar.current.dateComponents([.hour, .minute, .second], from: now, to: nextPrayerTime)
        timeUntilNextPrayer = String(format: "%02d:%02d:%02d", countdown.hour ?? 0, countdown.minute ?? 0, countdown.second ?? 0)
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
    }

    func clearNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func scheduleNotifications(prayerTimes: PrayerTimes) {
        clearNotifications()

        let prayers = [
            ("Fajr", prayerTimes.fajr),
            ("Sunrise", prayerTimes.sunrise),
            ("Dhuhr", prayerTimes.dhuhr),
            ("Asr", prayerTimes.asr),
            ("Maghrib", prayerTimes.maghrib),
            ("Isha", prayerTimes.isha)
        ]

        for (prayerName, prayerTime) in prayers {
            if prayerName == "Sunrise" && !enableSunriseNotifications {
                continue
            }

            if enablePrayerTimeNotifications {
                let content = UNMutableNotificationContent()
                content.title = prayerName
                content.body = "Time for \(prayerName)"
                content.sound = UNNotificationSound.default

                let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: prayerTime)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)

                let request = UNNotificationRequest(identifier: "\(prayerName)_time",
                                                    content: content,
                                                    trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error creating notification for \(prayerName): \(error.localizedDescription)")
                    }
                }
            }

            if enable30MinNotifications {
                let content30MinBefore = UNMutableNotificationContent()
                content30MinBefore.title = "Prepare for next prayer"
                content30MinBefore.body = "Time for \(prayerName) in 30 minutes"
                content30MinBefore.sound = UNNotificationSound.default

                let prayerTime30MinBefore = prayerTime.addingTimeInterval(-30 * 60)
                let triggerDate30MinBefore = Calendar.current.dateComponents([.hour, .minute], from: prayerTime30MinBefore)
                let trigger30MinBefore = UNCalendarNotificationTrigger(dateMatching: triggerDate30MinBefore, repeats: true)

                let request30MinBefore = UNNotificationRequest(identifier: "\(prayerName)_30min",
                                                               content: content30MinBefore,
                                                               trigger: trigger30MinBefore)
                UNUserNotificationCenter.current().add(request30MinBefore) { error in
                    if let error = error {
                        print("Error creating notification 30 minutes before \(prayerName): \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yourapp.updatePrayerTimes",
                                        using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }

    func scheduleBackgroundRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.yourapp.updatePrayerTimes")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 3600)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Failed to schedule background task: \(error)")
        }
    }

    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleBackgroundRefresh()
        updatePrayerTimes()
        task.setTaskCompleted(success: true)
    }

    func updateNotifications() {
        guard let prayers = storedPrayerTimes else { return }
        scheduleNotifications(prayerTimes: prayers)
    }
}

struct NotificationSettingsView: View {
    @AppStorage("enable30MinNotifications") private var enable30MinNotifications: Bool = true
    @AppStorage("enablePrayerTimeNotifications") private var enablePrayerTimeNotifications: Bool = true
    @AppStorage("enableSunriseNotifications") private var enableSunriseNotifications: Bool = true

    @EnvironmentObject var settings: UserSettings
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("Notification Settings", bundle: settings.bundle)
                .font(.headline)
                .padding()

            Toggle(isOn: $enable30MinNotifications, label: {
                Text("30-Minute Notifications", bundle: settings.bundle)
            })
            .padding(.horizontal)

            Toggle(isOn: $enablePrayerTimeNotifications, label: {
                Text("Prayer Time Notifications", bundle: settings.bundle)
            })
            .padding(.horizontal)
            
            Toggle(isOn: $enableSunriseNotifications, label: {
                Text("Sunrise Notifications", bundle: settings.bundle)
            })
            .padding(.horizontal)

            Button(action: {
                openSystemNotificationSettings()
            }, label: {
                HStack {
                    Text("Open iOS Notification Settings", bundle: settings.bundle)
                    Image(systemName: "gear")
                }
                    .foregroundStyle(settings.selectedTheme.primaryColor)
            })
            .padding(.vertical, 30)
            
            Spacer()
            
            Button(action: {
                dismiss()
            }, label: {
                Text("Close", bundle: settings.bundle)
                    .foregroundStyle(settings.selectedTheme.primaryColor)
            })
            .padding(.vertical, 30)
        }
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .foregroundStyle(.black)
        .background(settings.selectedTheme.lightBackgroundColor)
        .ignoresSafeArea()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private func openSystemNotificationSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
}




struct PrayerTimeModalView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        NavigationView {
            PrayerTimeView()
                .navigationBarItems(trailing: Button(action: {
                    isPresented = false
                }, label: {
                    Image(systemName: "xmark.circle")
                        .imageScale(.large)
                        .foregroundStyle(settings.selectedTheme.primaryColor)
                }))
        }
    }
}

struct PrayerTimeRow: View {
    var prayerName: String
    var prayerTime: String
    
    var body: some View {
        HStack {
            Text(prayerName)
                .font(.title3)
                .fontWeight(.semibold)
            Spacer()
            Text(prayerTime)
                .font(.title3)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
    }
}



extension View {
    func capsuleStyled(theme: AppTheme) -> some View {
        self.foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    theme.primaryColor.opacity(0.1)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [theme.gradientTopColor, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(2)
                    
                })
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

extension View {
    func cardStyled(theme: AppTheme) -> some View {
        self.font(.headline)
        .foregroundColor(.black)
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                theme.primaryColor.opacity(0.1)
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.white)
                    .blur(radius: 4)
                    .offset(x: -8, y: -8)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(gradient: Gradient(colors: [theme.gradientTopColor, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .padding(2)
                
            })
        .overlay(
            // Профессиональная темная обводка
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black.opacity(0.08), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: theme.primaryColor.opacity(0.3), radius: 20, x: 20, y: 20)
        .shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 2)
        .padding(.vertical, 40)
        
    }
}

extension View {
    func transparentStyled(theme: AppTheme) -> some View {
        self.padding(.vertical)
            .padding(.all, 25)
            .background(
                ZStack {
                    theme.primaryColor.opacity(0.1)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [theme.gradientTopColor, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(2)
                    
                })
            .overlay(
                // Профессиональная темная обводка
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black.opacity(0.08), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: theme.primaryColor.opacity(0.3), radius: 20, x: 20, y: 20)
            .shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 2)
            .padding()
    }
}

#Preview {
    PrayerTimeView()
}
