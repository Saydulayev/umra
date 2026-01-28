//
//  PrayerTimeView.swift
//  umra
//
//  Created by Akhmed on 29.04.24.
//

@preconcurrency import Adhan
import BackgroundTasks
import OSLog
import SwiftUI
import UserNotifications
import UIKit


struct PrayerTimeView: View {
    @State private var prayerTimes: [String: String] = [:]
    @State private var nextPrayerName = ""
    @State private var timeUntilNextPrayer = ""
    @State private var timerTask: Task<Void, Never>?
    @State private var isUpdating = false
    @State private var storedPrayerTimes: PrayerTimes? = nil
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(BackgroundTaskManager.self) private var backgroundTaskManager
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.umra.app", category: "PrayerTimeView")

    @AppStorage("enable30MinNotifications") private var enable30MinNotifications: Bool = true
    @AppStorage("enablePrayerTimeNotifications") private var enablePrayerTimeNotifications: Bool = true
    @AppStorage("enableSunriseNotifications") private var enableSunriseNotifications: Bool = true
    @AppStorage(UserDefaultsKey.prayerCity) private var prayerCityRaw: String = PrayerCity.mecca.rawValue

    private var currentPrayerCity: PrayerCity {
        PrayerCity(rawValue: prayerCityRaw) ?? .mecca
    }

    private var prayerCityTitleKey: String {
        currentPrayerCity == .mecca ? "prayer_mecca" : "prayer_medina"
    }

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
            themeManager.selectedTheme.lightBackgroundColor
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text(LocalizedStringKey(prayerCityTitleKey), bundle: localizationManager.bundle)
                    Text(currentIslamicDate)
                }
                .font(.custom("Savoye LET", size: 36))
                .foregroundStyle(themeManager.selectedTheme.textColor)
                .padding(-5)
                Divider()

                Picker("", selection: $prayerCityRaw) {
                    Text("prayer_mecca", bundle: localizationManager.bundle).tag(PrayerCity.mecca.rawValue)
                    Text("prayer_medina", bundle: localizationManager.bundle).tag(PrayerCity.medina.rawValue)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                Text("\(localizedPrayerName(nextPrayerName)) \(NSLocalizedString("prayer_in", bundle: localizationManager.bundle ?? .main, comment: "")) \(timeUntilNextPrayer)")
                    .cardStyled(theme: themeManager.selectedTheme)

                Group {
                    PrayerTimeRow(prayerName: localizedPrayerName("Fajr"), prayerTime: prayerTimes["Fajr"] ?? "")
                    PrayerTimeRow(prayerName: localizedPrayerName("Sunrise"), prayerTime: prayerTimes["Sunrise"] ?? "")
                        .capsuleStyled(theme: themeManager.selectedTheme)
                    PrayerTimeRow(prayerName: localizedPrayerName("Dhuhr"), prayerTime: prayerTimes["Dhuhr"] ?? "")
                    PrayerTimeRow(prayerName: localizedPrayerName("Asr"), prayerTime: prayerTimes["Asr"] ?? "")
                    PrayerTimeRow(prayerName: localizedPrayerName("Maghrib"), prayerTime: prayerTimes["Maghrib"] ?? "")
                    PrayerTimeRow(prayerName: localizedPrayerName("Isha"), prayerTime: prayerTimes["Isha"] ?? "")
                    PrayerTimeRow(prayerName: localizedPrayerName("Qiyam"), prayerTime: prayerTimes["Qiyam"] ?? "")
                        .capsuleStyled(theme: themeManager.selectedTheme)
                }
                .foregroundStyle(themeManager.selectedTheme.textColor)
                .padding(.horizontal)
            }
            .transparentStyled(theme: themeManager.selectedTheme)
            .onAppear {
                UISegmentedControl.appearance().selectedSegmentTintColor = .black

                UISegmentedControl.appearance().setTitleTextAttributes(
                    [.foregroundColor: UIColor.white],
                    for: .selected
                )

                UISegmentedControl.appearance().setTitleTextAttributes(
                    [.foregroundColor: UIColor.black],
                    for: .normal
                )

                setupPrayerTimes()
                Task {
                    await requestNotificationPermission()
                }
                startTimer()
            }
            .onDisappear {
                timerTask?.cancel()
                timerTask = nil
            }
            .onChange(of: enable30MinNotifications) {
                updateNotifications()
            }
            .onChange(of: enablePrayerTimeNotifications) {
                updateNotifications()
            }
            // Пересоздаём уведомления при изменении тумблера Sunrise
            .onChange(of: enableSunriseNotifications) {
                updateNotifications()
            }
            .onChange(of: prayerCityRaw) { _, _ in
                Task { @MainActor in
                    await updatePrayerTimes()
                }
            }
        }
    }

    func setupPrayerTimes() {
        Task { @MainActor in
            await updatePrayerTimes()
        }
    }
    
    func startTimer() {
        timerTask = Task { @MainActor in
            while !Task.isCancelled {
                await updatePrayerTimes()
                do {
                    try await Task.sleep(for: .seconds(1))
                } catch {
                    break
                }
            }
        }
    }

    @MainActor
    func updatePrayerTimes() async {
        // Защита от параллельных вызовов
        guard !isUpdating else { return }
        isUpdating = true
        defer { isUpdating = false }
        
        let cal = Calendar(identifier: .gregorian)
        let today = Date()
        guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) else {
            logger.error("Failed to calculate tomorrow's date")
            return
        }
        let todayDateComponents = cal.dateComponents([.year, .month, .day], from: today)
        let tomorrowDateComponents = cal.dateComponents([.year, .month, .day], from: tomorrow)
        
        // Извлекаем примитивные значения для безопасной передачи в Task.detached
        let city = currentPrayerCity
        let latitude = city.latitude
        let longitude = city.longitude
        var params = CalculationMethod.ummAlQura.params
        params.madhab = .shafi
        let finalParams = params

        // Параллельное вычисление времен молитв для сегодня и завтра
        // Используем вспомогательную функцию для обхода проблем с Sendable в библиотеке Adhan
        async let todayPrayers = calculatePrayerTimes(
            latitude: latitude,
            longitude: longitude,
            dateComponents: todayDateComponents,
            params: finalParams
        )
        
        async let tomorrowPrayers = calculatePrayerTimes(
            latitude: latitude,
            longitude: longitude,
            dateComponents: tomorrowDateComponents,
            params: finalParams
        )
        
        let todayPrayersResult = await todayPrayers
        let tomorrowPrayersResult = await tomorrowPrayers
        
        guard let todayPrayers = todayPrayersResult,
              let tomorrowPrayers = tomorrowPrayersResult else {
            logger.error("Error initializing PrayerTimes")
            return
        }

        let maghribToFajrInterval = tomorrowPrayers.fajr.timeIntervalSince(todayPrayers.maghrib)
        let lastThirdStart = todayPrayers.maghrib.addingTimeInterval(2 * maghribToFajrInterval / 3)

        let prayerTimeFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.timeZone = TimeZone(identifier: "Asia/Riyadh")
            return formatter
        }()

        let newPrayerTimes: [String: String] = [
            "Fajr": prayerTimeFormatter.string(from: todayPrayers.fajr),
            "Sunrise": prayerTimeFormatter.string(from: todayPrayers.sunrise),
            "Dhuhr": prayerTimeFormatter.string(from: todayPrayers.dhuhr),
            "Asr": prayerTimeFormatter.string(from: todayPrayers.asr),
            "Maghrib": prayerTimeFormatter.string(from: todayPrayers.maghrib),
            "Isha": prayerTimeFormatter.string(from: todayPrayers.isha),
            "Qiyam": prayerTimeFormatter.string(from: lastThirdStart)
        ]

        self.prayerTimes = newPrayerTimes
        self.updateCountdownToNextPrayer(prayers: todayPrayers)
        self.storedPrayerTimes = todayPrayers
        await scheduleNotifications(prayerTimes: todayPrayers)
    }

    // Вспомогательная функция для вычисления времен молитв вне MainActor контекста
    nonisolated private func calculatePrayerTimes(
        latitude: Double,
        longitude: Double,
        dateComponents: DateComponents,
        params: CalculationParameters
    ) -> PrayerTimes? {
        let coordinates = Coordinates(latitude: latitude, longitude: longitude)
        return PrayerTimes(coordinates: coordinates,
                          date: dateComponents,
                          calculationParameters: params)
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
    
    func localizedPrayerName(_ prayerName: String) -> String {
        let key: String
        switch prayerName {
        case "Fajr":
            key = "prayer_fajr"
        case "Sunrise":
            key = "prayer_sunrise"
        case "Dhuhr":
            key = "prayer_dhuhr"
        case "Asr":
            key = "prayer_asr"
        case "Maghrib":
            key = "prayer_maghrib"
        case "Isha":
            key = "prayer_isha"
        case "Qiyam":
            key = "prayer_qiyam"
        default:
            return prayerName
        }
        return NSLocalizedString(key, bundle: localizationManager.bundle ?? .main, comment: "")
    }

    func requestNotificationPermission() async {
        do {
            _ = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            logger.error("Error requesting notification permission: \(error.localizedDescription, privacy: .public)")
        }
    }

    func clearNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func scheduleNotifications(prayerTimes: PrayerTimes) async {
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
                let localizedName = localizedPrayerName(prayerName)
                content.title = localizedName
                content.body = String(format: NSLocalizedString("prayer_time_for", bundle: localizationManager.bundle ?? .main, comment: ""), localizedName)
                content.sound = UNNotificationSound.default

                let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: prayerTime)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)

                let request = UNNotificationRequest(identifier: "\(prayerName)_time",
                                                    content: content,
                                                    trigger: trigger)
                do {
                    try await UNUserNotificationCenter.current().add(request)
                } catch {
                    logger.error("Error creating notification for \(prayerName, privacy: .public): \(error.localizedDescription, privacy: .public)")
                }
            }

            if enable30MinNotifications {
                let content30MinBefore = UNMutableNotificationContent()
                let localizedName = localizedPrayerName(prayerName)
                content30MinBefore.title = NSLocalizedString("prayer_prepare_for_next", bundle: localizationManager.bundle ?? .main, comment: "")
                content30MinBefore.body = String(format: NSLocalizedString("prayer_time_in_30_minutes", bundle: localizationManager.bundle ?? .main, comment: ""), localizedName)
                content30MinBefore.sound = UNNotificationSound.default

                let prayerTime30MinBefore = prayerTime.addingTimeInterval(-AppConstants.notification30MinutesInterval)
                let triggerDate30MinBefore = Calendar.current.dateComponents([.hour, .minute], from: prayerTime30MinBefore)
                let trigger30MinBefore = UNCalendarNotificationTrigger(dateMatching: triggerDate30MinBefore, repeats: true)

                let request30MinBefore = UNNotificationRequest(identifier: "\(prayerName)_30min",
                                                               content: content30MinBefore,
                                                               trigger: trigger30MinBefore)
                do {
                    try await UNUserNotificationCenter.current().add(request30MinBefore)
                } catch {
                    logger.error("Error creating notification 30 minutes before \(prayerName, privacy: .public): \(error.localizedDescription, privacy: .public)")
                }
            }
        }
    }

    func scheduleBackgroundRefresh() {
        backgroundTaskManager.scheduleBackgroundRefresh()
    }

    func updateNotifications() {
        guard let prayers = storedPrayerTimes else { return }
        Task { @MainActor in
            await scheduleNotifications(prayerTimes: prayers)
        }
    }
}

struct NotificationSettingsView: View {
    @AppStorage("enable30MinNotifications") private var enable30MinNotifications: Bool = true
    @AppStorage("enablePrayerTimeNotifications") private var enablePrayerTimeNotifications: Bool = true
    @AppStorage("enableSunriseNotifications") private var enableSunriseNotifications: Bool = true

    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        let systemBackground = Color(UIColor.systemBackground)
        let secondaryBackground = Color(UIColor.secondarySystemBackground)
        let textColor = Color.primary
        
        VStack(spacing: 24) {
            Text("Notification Settings", bundle: localizationManager.bundle)
                .font(.headline)
                .foregroundColor(textColor)
                .padding(.top, 24)
            
            VStack(spacing: 16) {
                Toggle(isOn: $enable30MinNotifications) {
                    Text("30-Minute Notifications", bundle: localizationManager.bundle)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(textColor)
                }
                
                Toggle(isOn: $enablePrayerTimeNotifications) {
                    Text("Prayer Time Notifications", bundle: localizationManager.bundle)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(textColor)
                }
                
                Toggle(isOn: $enableSunriseNotifications) {
                    Text("Sunrise Notifications", bundle: localizationManager.bundle)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(textColor)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(secondaryBackground)
            )
            .padding(.horizontal)
            .tint(themeManager.selectedTheme.primaryColor)
            
            Button(action: {
                openSystemNotificationSettings()
            }, label: {
                HStack(spacing: 8) {
                    Text("Open iOS Notification Settings", bundle: localizationManager.bundle)
                    Image(systemName: "gear")
                }
                .foregroundColor(themeManager.selectedTheme.primaryColor)
            })
            .padding(.top, 8)
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                dismiss()
            }, label: {
                Text("Close", bundle: localizationManager.bundle)
                    .foregroundColor(themeManager.selectedTheme.primaryColor)
            })
            .padding(.vertical, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(systemBackground.ignoresSafeArea())
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
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    
    var body: some View {
        NavigationStack {
            PrayerTimeView()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isPresented = false
                        }, label: {
                            Image(systemName: "xmark.circle")
                                .imageScale(.large)
                                .foregroundStyle(themeManager.selectedTheme.primaryColor)
                        })
                    }
                }
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
        let isDarkTheme = theme == .dark
        let backgroundColor = isDarkTheme ? Color(UIColor(red: 0.25, green: 0.25, blue: 0.3, alpha: 1)) : Color.white
        
        return self.foregroundStyle(theme.textColor)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    theme.primaryColor.opacity(0.2)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(backgroundColor)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [theme.gradientTopColor, theme.gradientBottomColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(2)
                    
                })
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

extension View {
    func cardStyled(theme: AppTheme) -> some View {
        let isDarkTheme = theme == .dark
        let backgroundColor = isDarkTheme ? Color(UIColor(red: 0.25, green: 0.25, blue: 0.3, alpha: 1)) : Color.white
        let gradientBottom = isDarkTheme ? theme.gradientBottomColor : Color.white
        
        return self.font(.headline)
        .foregroundColor(theme.textColor)
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                theme.primaryColor.opacity(0.1)
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(backgroundColor)
                    .blur(radius: 4)
                    .offset(x: -8, y: -8)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(gradient: Gradient(colors: [theme.gradientTopColor, gradientBottom]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .padding(2)
                
            })
        .overlay(
            // Профессиональная темная обводка
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black.opacity(0.08), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 20, y: 20)
        .shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 2)
        .padding(.vertical, 40)
        
    }
}

extension View {
    func transparentStyled(theme: AppTheme) -> some View {
        let isDarkTheme = theme == .dark
        let backgroundColor = isDarkTheme ? Color(UIColor(red: 0.25, green: 0.25, blue: 0.3, alpha: 1)) : Color.white
        
        return self.padding(.vertical)
            .padding(.all, 25)
            .background(
                ZStack {
                    theme.primaryColor.opacity(0.2)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(backgroundColor)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [theme.gradientTopColor, theme.gradientBottomColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(2)
                    
                })
            .overlay(
                // Профессиональная темная обводка
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black.opacity(0.08), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 20, y: 20)
            .shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 2)
            .padding()
    }
}

#Preview {
    PrayerTimeView()
}

