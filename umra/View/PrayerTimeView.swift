//
//  PrayerTimeView.swift
//  umra
//
//  Created by Akhmed on 29.04.24.
//

import Adhan
import SwiftUI
import UserNotifications


struct PrayerTimeView: View {
    @State private var prayerTimes: [String: String] = [:]
    @State private var nextPrayerName = ""
    @State private var timeUntilNextPrayer = ""
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @AppStorage("enable30MinNotifications") private var enable30MinNotifications: Bool = true
    @AppStorage("enablePrayerTimeNotifications") private var enablePrayerTimeNotifications: Bool = true

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
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
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
                    .cardStyled()

                Group {
                    PrayerTimeRow(prayerName: "Fajr", prayerTime: prayerTimes["Fajr"] ?? "")
                    PrayerTimeRow(prayerName: "Sunrise", prayerTime: prayerTimes["Sunrise"] ?? "")
                        .capsuleStyled()
                    PrayerTimeRow(prayerName: "Dhuhr", prayerTime: prayerTimes["Dhuhr"] ?? "")
                    PrayerTimeRow(prayerName: "Asr", prayerTime: prayerTimes["Asr"] ?? "")
                    PrayerTimeRow(prayerName: "Maghrib", prayerTime: prayerTimes["Maghrib"] ?? "")
                    PrayerTimeRow(prayerName: "Isha", prayerTime: prayerTimes["Isha"] ?? "")
                    PrayerTimeRow(prayerName: "Qiyam", prayerTime: prayerTimes["Qiyam"] ?? "")
                        .capsuleStyled()
                }
                .foregroundStyle(.black)
                .padding(.horizontal)
            }
            .transparentStyled()
            .onAppear {
                setupPrayerTimes()
                requestNotificationPermission()
            }
            .onReceive(timer) { _ in
                updatePrayerTimes()
            }
            .onDisappear {
                timer.upstream.connect().cancel()
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
            guard let todayPrayers = PrayerTimes(coordinates: coordinates, date: todayDateComponents, calculationParameters: params),
                  let tomorrowPrayers = PrayerTimes(coordinates: coordinates, date: tomorrowDateComponents, calculationParameters: params) else {
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

    func scheduleNotifications(prayerTimes: PrayerTimes) {
        let prayers = [
            ("Fajr", prayerTimes.fajr),
            ("Sunrise", prayerTimes.sunrise),
            ("Dhuhr", prayerTimes.dhuhr),
            ("Asr", prayerTimes.asr),
            ("Maghrib", prayerTimes.maghrib),
            ("Isha", prayerTimes.isha)
        ]

        for (prayerName, prayerTime) in prayers {
            if enablePrayerTimeNotifications {
                let content = UNMutableNotificationContent()
                content.title = "\(prayerName)"
                content.body = "Time for \(prayerName)"
                content.sound = UNNotificationSound.default

                let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: prayerTime)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

                let request = UNNotificationRequest(identifier: "\(prayerName)_time", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Ошибка при создании уведомления для молитвы \(prayerName): \(error.localizedDescription)")
                    }
                }
            }

            if enable30MinNotifications {
                let content30MinBefore = UNMutableNotificationContent()
                content30MinBefore.title = "Prepare for next prayer"
                content30MinBefore.body = "Time for \(prayerName) in 30 minutes"
                content30MinBefore.sound = UNNotificationSound.default

                let prayerTime30MinBefore = prayerTime.addingTimeInterval(-30 * 60)
                let triggerDate30MinBefore = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: prayerTime30MinBefore)
                let trigger30MinBefore = UNCalendarNotificationTrigger(dateMatching: triggerDate30MinBefore, repeats: false)

                let request30MinBefore = UNNotificationRequest(identifier: "\(prayerName)_30min", content: content30MinBefore, trigger: trigger30MinBefore)
                UNUserNotificationCenter.current().add(request30MinBefore) { error in
                    if let error = error {
                        print("Ошибка при создании уведомления за 30 минут до молитвы \(prayerName): \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}



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
                        .foregroundStyle(.blue)
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

struct NotificationSettingsView: View {
    @AppStorage("enable30MinNotifications") private var enable30MinNotifications: Bool = true
    @AppStorage("enablePrayerTimeNotifications") private var enablePrayerTimeNotifications: Bool = true
    @EnvironmentObject var settings: UserSettings
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("Notification Settings", bundle: settings.bundle)
                .font(.headline)
                .padding()
            
            Toggle(isOn: $enable30MinNotifications, label: { Text("30-Minute Notifications", bundle: settings.bundle) })
                .padding(.horizontal)

            
            Toggle(isOn: $enablePrayerTimeNotifications, label: { Text("Prayer Time Notifications", bundle: settings.bundle) })
                .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                dismiss()
            }, label: {
                Text("Close", bundle: settings.bundle)
                    .foregroundStyle(.blue)
            })
            .padding(.vertical, 30)
        }
        .foregroundStyle(.black)
        .background(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
        .ignoresSafeArea()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

extension View {
    func capsuleStyled() -> some View {
        self.foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8980392157, green: 0.933333333, blue: 1, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(2)
                    
                })
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

extension View {
    func cardStyled() -> some View {
        self.font(.headline)
        .foregroundColor(.black)
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.white)
                    .blur(radius: 4)
                    .offset(x: -8, y: -8)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8980392157, green: 0.933333333, blue: 1, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .padding(2)
                
            })
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20)
        .padding(.vertical, 40)
        
    }
}

extension View {
    func transparentStyled() -> some View {
        self.padding(.vertical)
            .padding(.all, 25)
            .background(
                ZStack {
                    Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8980392157, green: 0.933333333, blue: 1, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(2)
                    
                })
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20)
            .padding()
    }
    
}

#Preview {
    PrayerTimeView()
}
