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
    @State private var showNotificationSettings = false

    private var currentPrayerCity: PrayerCity {
        PrayerCity(rawValue: prayerCityRaw) ?? .mecca
    }

    private var prayerCityTitleKey: String {
        currentPrayerCity == .mecca ? "prayer_mecca" : "prayer_medina"
    }

    private static let islamicDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .islamicUmmAlQura)
        formatter.locale = Locale(identifier: "en_EN")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()

    private static let prayerTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(identifier: "Asia/Riyadh")
        return formatter
    }()

    var currentIslamicDate: String {
        return Self.islamicDateFormatter.string(from: Date())
    }

    private enum PrayerLayout {
        case regular
        case compact

        var isCompact: Bool {
            self == .compact
        }

        var titleFont: Font {
            isCompact
                ? .custom("Savoye LET", size: 28, relativeTo: .title)
                : .custom("Savoye LET", size: 36, relativeTo: .largeTitle)
        }

        var stackSpacing: CGFloat {
            isCompact ? 8 : 12
        }

        var headerPadding: CGFloat {
            isCompact ? -2 : -5
        }

        var pickerHorizontalPadding: CGFloat {
            isCompact ? 12 : 16
        }

        var rowsHorizontalPadding: CGFloat {
            isCompact ? 8 : 16
        }
    }

    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea()

            content
        }
        .onAppear {
            let emeraldLight = UIColor(red: 0.063, green: 0.725, blue: 0.506, alpha: 1)
            UISegmentedControl.appearance().selectedSegmentTintColor = emeraldLight

            UISegmentedControl.appearance().setTitleTextAttributes(
                [.foregroundColor: UIColor.white],
                for: .selected
            )

            UISegmentedControl.appearance().setTitleTextAttributes(
                [.foregroundColor: UIColor.label],
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
        .onChange(of: enable30MinNotifications) { _, _ in
            updateNotifications()
        }
        .onChange(of: enablePrayerTimeNotifications) { _, _ in
            updateNotifications()
        }
        // Пересоздаём уведомления при изменении тумблера Sunrise
        .onChange(of: enableSunriseNotifications) { _, _ in
            updateNotifications()
        }
        .onChange(of: prayerCityRaw) { _, _ in
            Task { @MainActor in
                await updatePrayerTimes()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showNotificationSettings = true
                } label: {
                    Image(systemName: "bell.badge")
                        .imageScale(.large)
                }
            }
        }
        .sheet(isPresented: $showNotificationSettings) {
            NotificationSettingsView()
        }
    }

    private var content: some View {
        ViewThatFits(in: .vertical) {
            prayerContent(layout: .regular)
            prayerContent(layout: .compact)
            ScrollView {
                prayerContent(layout: .compact)
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func prayerContent(layout: PrayerLayout) -> some View {
        VStack(spacing: layout.stackSpacing) {
            ViewThatFits {
                HStack(spacing: 8) {
                    Text(LocalizedStringKey(prayerCityTitleKey), bundle: localizationManager.bundle)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    Text(currentIslamicDate)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                VStack(spacing: 2) {
                    Text(LocalizedStringKey(prayerCityTitleKey), bundle: localizationManager.bundle)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    Text(currentIslamicDate)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            }
            .font(layout.titleFont)
            .foregroundStyle(themeManager.selectedTheme.textColor)
            .padding(layout.headerPadding)
            Divider()

            Picker("", selection: $prayerCityRaw) {
                Text("prayer_mecca", bundle: localizationManager.bundle).tag(PrayerCity.mecca.rawValue)
                Text("prayer_medina", bundle: localizationManager.bundle).tag(PrayerCity.medina.rawValue)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, layout.pickerHorizontalPadding)

            Text("\(localizedPrayerName(nextPrayerName)) \(localizationManager.localized("prayer_in")) \(timeUntilNextPrayer)")
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .cardStyled(theme: themeManager.selectedTheme, compact: layout.isCompact)

            Group {
                PrayerTimeRow(prayerName: localizedPrayerName("Fajr"), prayerTime: prayerTimes["Fajr"] ?? "", compact: layout.isCompact)
                PrayerTimeRow(prayerName: localizedPrayerName("Sunrise"), prayerTime: prayerTimes["Sunrise"] ?? "", compact: layout.isCompact)
                    .capsuleStyled(theme: themeManager.selectedTheme)
                PrayerTimeRow(prayerName: localizedPrayerName("Dhuhr"), prayerTime: prayerTimes["Dhuhr"] ?? "", compact: layout.isCompact)
                PrayerTimeRow(prayerName: localizedPrayerName("Asr"), prayerTime: prayerTimes["Asr"] ?? "", compact: layout.isCompact)
                PrayerTimeRow(prayerName: localizedPrayerName("Maghrib"), prayerTime: prayerTimes["Maghrib"] ?? "", compact: layout.isCompact)
                PrayerTimeRow(prayerName: localizedPrayerName("Isha"), prayerTime: prayerTimes["Isha"] ?? "", compact: layout.isCompact)
                PrayerTimeRow(prayerName: localizedPrayerName("Qiyam"), prayerTime: prayerTimes["Qiyam"] ?? "", compact: layout.isCompact)
                    .capsuleStyled(theme: themeManager.selectedTheme)
            }
            .foregroundStyle(themeManager.selectedTheme.textColor)
            .padding(.horizontal, layout.rowsHorizontalPadding)
        }
        .frame(maxWidth: .infinity)
        .transparentStyled(theme: themeManager.selectedTheme, compact: layout.isCompact)
    }

    func setupPrayerTimes() {
        Task { @MainActor in
            await updatePrayerTimes()
        }
    }
    
    func startTimer() {
        timerTask = Task { @MainActor in
            while !Task.isCancelled {
                if let prayers = storedPrayerTimes {
                    updateCountdownToNextPrayer(prayers: prayers)
                }
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

        let newPrayerTimes: [String: String] = [
            "Fajr": Self.prayerTimeFormatter.string(from: todayPrayers.fajr),
            "Sunrise": Self.prayerTimeFormatter.string(from: todayPrayers.sunrise),
            "Dhuhr": Self.prayerTimeFormatter.string(from: todayPrayers.dhuhr),
            "Asr": Self.prayerTimeFormatter.string(from: todayPrayers.asr),
            "Maghrib": Self.prayerTimeFormatter.string(from: todayPrayers.maghrib),
            "Isha": Self.prayerTimeFormatter.string(from: todayPrayers.isha),
            "Qiyam": Self.prayerTimeFormatter.string(from: lastThirdStart)
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
        return localizationManager.localized(key)
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
                content.body = String(format: localizationManager.localized("prayer_time_for"), localizedName)
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
                content30MinBefore.title = localizationManager.localized("prayer_prepare_for_next")
                content30MinBefore.body = String(format: localizationManager.localized("prayer_time_in_30_minutes"), localizedName)
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
        let systemBackground = themeManager.selectedTheme.backgroundColor
        let secondaryBackground = themeManager.selectedTheme.cardColor
        let textColor = themeManager.selectedTheme.textColor
        
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Prayer Notification Settings", bundle: localizationManager.bundle)
                        .font(.headline)
                        .foregroundStyle(textColor)
                        .padding(.top, 24)

                    VStack(spacing: 16) {
                        Toggle(isOn: $enable30MinNotifications) {
                            Text("30-Minute Notifications", bundle: localizationManager.bundle)
                                .font(.body)
                                .foregroundStyle(textColor)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Toggle(isOn: $enablePrayerTimeNotifications) {
                            Text("Prayer Time Notifications", bundle: localizationManager.bundle)
                                .font(.body)
                                .foregroundStyle(textColor)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Toggle(isOn: $enableSunriseNotifications) {
                            Text("Sunrise Notifications", bundle: localizationManager.bundle)
                                .font(.body)
                                .foregroundStyle(textColor)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding()
                    .standardCardFrame(
                        theme: themeManager.selectedTheme,
                        cornerRadius: 16,
                        fillColor: secondaryBackground,
                        shadowRadius: 14,
                        shadowYOffset: 6
                    )
                    .padding(.horizontal)
                    .tint(themeManager.selectedTheme.primaryColor)

                    Button(action: {
                        openSystemNotificationSettings()
                    }, label: {
                        HStack(alignment: .top, spacing: 8) {
                            Text("Open iOS Notification Settings", bundle: localizationManager.bundle)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                            Image(systemName: "gear")
                        }
                        .foregroundStyle(themeManager.selectedTheme.primaryColor)
                    })
                    .padding(.top, 8)
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 16)
            }
            .scrollIndicators(.hidden)

            Divider()

            Button(action: {
                dismiss()
            }, label: {
                Text("Close", bundle: localizationManager.bundle)
                    .foregroundStyle(themeManager.selectedTheme.primaryColor)
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

struct PrayerTimeRow: View {
    var prayerName: String
    var prayerTime: String
    var compact: Bool = false

    private var horizontalPadding: CGFloat {
        compact ? 8 : 10
    }

    private var verticalPadding: CGFloat {
        compact ? 3 : 5
    }
    
    var body: some View {
        HStack {
            Text(prayerName)
                .font(.callout)
                .fontWeight(.semibold)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Spacer()
            Text(prayerTime)
                .font(.callout)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
    }
}



extension View {
    func capsuleStyled(theme: AppTheme) -> some View {
        return self.foregroundStyle(theme.textColor)
            .frame(maxWidth: .infinity)
            .standardCardFrame(theme: theme, cornerRadius: 20)
    }
}

extension View {
    func cardStyled(theme: AppTheme, compact: Bool = false) -> some View {
        let contentPadding: CGFloat = compact ? 12 : 16
        let verticalPadding: CGFloat = compact ? 16 : 40
        
        return self.font(.headline)
        .foregroundStyle(theme.textColor)
        .padding(contentPadding)
        .frame(maxWidth: .infinity)
        .standardCardFrame(theme: theme, cornerRadius: 20)
        .padding(.vertical, verticalPadding)
        
    }
}

extension View {
    func transparentStyled(theme: AppTheme, compact: Bool = false) -> some View {
        let innerPadding: CGFloat = compact ? 16 : 25
        let verticalPadding: CGFloat = compact ? 8 : 12
        let outerPadding: CGFloat = compact ? 8 : 16
        
        return self.padding(.vertical, verticalPadding)
            .padding(innerPadding)
            .standardCardFrame(theme: theme, cornerRadius: 20)
            .padding(outerPadding)
    }
}

#Preview {
    PrayerTimeView()
}
