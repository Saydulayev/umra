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

// MARK: - Общие стеклянные утилиты

private let glassStrokeGradient = LinearGradient(
    colors: [Color.white.opacity(0.65), Color.white.opacity(0.15)],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)

@ViewBuilder
private func glassRoundedBackground(cornerRadius: CGFloat) -> some View {
    // Мягкая затемнённая подложка под «листом» для усиления эффекта стекла
    ZStack {
        RoundedRectangle(cornerRadius: cornerRadius + 2, style: .continuous)
            .fill(Color.black.opacity(0.10))
            .blur(radius: 12)
            .offset(y: 2)
            .compositingGroup()
        if #available(iOS 15.0, *) {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
        } else {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color.white.opacity(0.25))
        }
    }
}

private func glassRoundedStroke(cornerRadius: CGFloat, lineWidth: CGFloat = 1) -> some View {
    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        .strokeBorder(glassStrokeGradient, lineWidth: lineWidth)
}

private func glassRoundedHighlight(cornerRadius: CGFloat) -> some View {
    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        .fill(
            LinearGradient(
                colors: [Color.white.opacity(0.35), .clear],
                startPoint: .topLeading,
                endPoint: .center
            )
        )
        .blur(radius: 12)
        .allowsHitTesting(false)
}

private struct GlassShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.10), radius: 18, x: 0, y: 10)
            .shadow(color: Color.white.opacity(0.12), radius: 1, x: 0, y: 1)
    }
}

// MARK: - PrayerTimeView

struct PrayerTimeView: View {
    @State private var prayerTimes: [String: String] = [:]
    @State private var nextPrayerName = ""
    @State private var timeUntilNextPrayer = ""
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var storedPrayerTimes: PrayerTimes? = nil

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
            // Фон экрана — можно оставить лёгким, стекло усилено внутренним затемнением
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)),
                            Color(#colorLiteral(red: 0.835, green: 0.88, blue: 0.98, alpha: 1))
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .ignoresSafeArea()
            
            VStack {
                HStack(spacing: 6) {
                    Text("Mecca,")
                    Text(currentIslamicDate)
                }
                .font(.custom("Savoye LET", size: 36))
                .foregroundStyle(.primary)
                .padding(.bottom, -5)
                
                Divider()
                
                Text("\(nextPrayerName) in \(timeUntilNextPrayer)")
                    .cardStyled()

                Group {
                    PrayerTimeRow(prayerName: "Fajr",    prayerTime: prayerTimes["Fajr"] ?? "")
                    PrayerTimeRow(prayerName: "Sunrise", prayerTime: prayerTimes["Sunrise"] ?? "")
                        .capsuleStyled()
                    PrayerTimeRow(prayerName: "Dhuhr",   prayerTime: prayerTimes["Dhuhr"] ?? "")
                    PrayerTimeRow(prayerName: "Asr",     prayerTime: prayerTimes["Asr"] ?? "")
                    PrayerTimeRow(prayerName: "Maghrib", prayerTime: prayerTimes["Maghrib"] ?? "")
                    PrayerTimeRow(prayerName: "Isha",    prayerTime: prayerTimes["Isha"] ?? "")
                    PrayerTimeRow(prayerName: "Qiyam",   prayerTime: prayerTimes["Qiyam"] ?? "")
                        .capsuleStyled()
                }
                .foregroundStyle(.primary)
                .padding(.horizontal)
            }
            .transparentStyled()
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

// MARK: - NotificationSettingsView

struct NotificationSettingsView: View {
    @AppStorage("enable30MinNotifications") private var enable30MinNotifications: Bool = true
    @AppStorage("enablePrayerTimeNotifications") private var enablePrayerTimeNotifications: Bool = true
    @AppStorage("enableSunriseNotifications") private var enableSunriseNotifications: Bool = true

    @EnvironmentObject var settings: UserSettings
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)),
                    Color(#colorLiteral(red: 0.835, green: 0.88, blue: 0.98, alpha: 1))
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 14) {
                Text("Notification Settings", bundle: settings.bundle)
                    .font(.headline)
                    .padding(.top, 6)

                Toggle(isOn: $enable30MinNotifications) {
                    Text("30-Minute Notifications", bundle: settings.bundle)
                }
                .padding(.horizontal)
                .tint(.blue)

                Toggle(isOn: $enablePrayerTimeNotifications) {
                    Text("Prayer Time Notifications", bundle: settings.bundle)
                }
                .padding(.horizontal)
                .tint(.blue)
                
                Toggle(isOn: $enableSunriseNotifications) {
                    Text("Sunrise Notifications", bundle: settings.bundle)
                }
                .padding(.horizontal)
                .tint(.blue)

                Button(action: {
                    openSystemNotificationSettings()
                }) {
                    HStack(spacing: 6) {
                        Text("Open iOS Notification Settings", bundle: settings.bundle)
                        Image(systemName: "gear")
                    }
                    .foregroundStyle(.blue)
                }
                .padding(.vertical, 16)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Text("Close", bundle: settings.bundle)
                        .foregroundStyle(.blue)
                }
                .padding(.bottom, 16)
            }
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .foregroundStyle(.primary)
            .padding(.vertical)
            .padding(.horizontal, 20)
            .background(glassRoundedBackground(cornerRadius: 20))
            .overlay(glassRoundedStroke(cornerRadius: 20))
            .overlay(glassRoundedHighlight(cornerRadius: 20))
            .modifier(GlassShadowModifier())
            .padding()
        }
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

// MARK: - Modal

struct PrayerTimeModalView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            PrayerTimeView()
                .navigationBarItems(trailing: Button(action: {
                    isPresented = false
                }, label: {
                    Image(systemName: "xmark.circle")
                        .imageScale(.large)
                }))
        }
    }
}

// MARK: - Row

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

// MARK: - Стеклянные стили

extension View {
    func capsuleStyled() -> some View {
        self
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
            .background(glassRoundedBackground(cornerRadius: 20))
            .overlay(glassRoundedStroke(cornerRadius: 20))
            .overlay(glassRoundedHighlight(cornerRadius: 20))
            .modifier(GlassShadowModifier())
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

extension View {
    func cardStyled() -> some View {
        self
            .font(.headline)
            .foregroundColor(.primary)
            .padding()
            .frame(maxWidth: .infinity)
            .background(glassRoundedBackground(cornerRadius: 20))
            .overlay(glassRoundedStroke(cornerRadius: 20))
            .overlay(glassRoundedHighlight(cornerRadius: 20))
            .modifier(GlassShadowModifier())
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.vertical, 40)
    }
}

extension View {
    func transparentStyled() -> some View {
        self
            .padding(.vertical)
            .padding(.all, 25)
            .background(glassRoundedBackground(cornerRadius: 24))
            .overlay(glassRoundedStroke(cornerRadius: 24))
            .overlay(glassRoundedHighlight(cornerRadius: 24))
            .modifier(GlassShadowModifier())
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .padding()
    }
}

#Preview {
    PrayerTimeView()
}
