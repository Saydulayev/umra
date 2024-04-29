//
//  PrayerTimeView.swift
//  umra
//
//  Created by Akhmed on 29.04.24.
//

import Adhan
import SwiftUI


struct PrayerTimeView: View {
    @State private var fajrTime = ""
    @State private var sunriseTime = ""
    @State private var dhuhrTime = ""
    @State private var asrTime = ""
    @State private var maghribTime = ""
    @State private var ishaTime = ""
    @State private var tahajjudTime = ""

    @State private var nextPrayerName = ""
    @State private var timeUntilNextPrayer = ""
    
    var currentIslamicDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .islamicUmmAlQura)
        dateFormatter.locale = Locale(identifier: "en_EN")
        dateFormatter.dateFormat = "d MMMM yyyy"

        return dateFormatter.string(from: Date())
    }
    
    var body: some View {
        ZStack {
            Image("image")
                .resizable()
                .ignoresSafeArea()
            VStack {
                HStack {
                    Text("Mecca,")
                    Text(currentIslamicDate)
                }
                    .font(.custom("Savoye LET", size: 30))
                    .foregroundStyle(.black)
                    .padding(-5)
                Divider()
                Text("\(nextPrayerName) in \(timeUntilNextPrayer)")
                    .cardStyled()
                
                Group {
                    PrayerTimeRow(prayerName: "Fajr", prayerTime: fajrTime)
                    PrayerTimeRow(prayerName: "Sunrise", prayerTime: sunriseTime)
                        .capsuleStyled()
                    PrayerTimeRow(prayerName: "Dhuhr", prayerTime: dhuhrTime)
                    PrayerTimeRow(prayerName: "Asr", prayerTime: asrTime)
                    PrayerTimeRow(prayerName: "Maghrib", prayerTime: maghribTime)
                    PrayerTimeRow(prayerName: "Isha", prayerTime: ishaTime)
                    PrayerTimeRow(prayerName: "Qiyam", prayerTime: tahajjudTime)
                        .capsuleStyled()
                }
                .foregroundStyle(.black)
            }
            .transparentStyled()
            .onAppear {
                setupPrayerTimes()
            }
        }
    }
    
    // Настраивает начальные времена молитв и запускает таймер, который будет обновлять времена каждую секунду.
    func setupPrayerTimes() {
        updatePrayerTimes()
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updatePrayerTimes()
        }
    }
    
    // Обновляет времена молитв для текущего и следующего дня, а также определяет время ночной молитвы Тахаджуд.
    func updatePrayerTimes() {
        let cal = Calendar(identifier: .gregorian)
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        let todayDateComponents = cal.dateComponents([.year, .month, .day], from: today)
        let tomorrowDateComponents = cal.dateComponents([.year, .month, .day], from: tomorrow)
        let coordinates = Coordinates(latitude: 21.4225, longitude: 39.8262)
        var params = CalculationMethod.ummAlQura.params
        params.madhab = .shafi
        
        if let todayPrayers = PrayerTimes(coordinates: coordinates, date: todayDateComponents, calculationParameters: params),
           let tomorrowPrayers = PrayerTimes(coordinates: coordinates, date: tomorrowDateComponents, calculationParameters: params) {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.timeZone = TimeZone(identifier: "Asia/Riyadh")!
            
            let maghribToFajrInterval = tomorrowPrayers.fajr.timeIntervalSince(todayPrayers.maghrib)
            let lastThirdStart = todayPrayers.maghrib.addingTimeInterval(2 * maghribToFajrInterval / 3)
            
            DispatchQueue.main.async {
                // Обновляет переменные состояния для всех времен молитв.
                self.fajrTime = formatter.string(from: todayPrayers.fajr)
                self.sunriseTime = formatter.string(from: todayPrayers.sunrise)
                self.dhuhrTime = formatter.string(from: todayPrayers.dhuhr)
                self.asrTime = formatter.string(from: todayPrayers.asr)
                self.maghribTime = formatter.string(from: todayPrayers.maghrib)
                self.ishaTime = formatter.string(from: todayPrayers.isha)
                self.tahajjudTime = formatter.string(from: lastThirdStart)
                self.updateCountdownToNextPrayer(prayers: todayPrayers)
            }
        }
    }
    
    // Проверяет, возможно ли создать структуру времени молитв для текущего и следующего дня.
    func updateCountdownToNextPrayer(prayers: PrayerTimes) {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Riyadh")!
        
        // Список намазов и их времена в порядке
        let prayerTimes = [
            ("Fajr", prayers.fajr),
            ("Sunrise", prayers.sunrise),
            ("Dhuhr", prayers.dhuhr),
            ("Asr", prayers.asr),
            ("Maghrib", prayers.maghrib),
            ("Isha", prayers.isha)
        ]
        
        // Находим следующий намаз
        let nextPrayer = prayerTimes.first { $0.1 > now }
        nextPrayerName = nextPrayer?.0 ?? "Fajr" // Переход к Фаджру после Иши
        
        // Расчет времени до следующего намаза
        let nextPrayerTime = nextPrayer?.1 ?? prayers.fajr.addingTimeInterval(24 * 60 * 60) // Если после Иши, то до следующего Фаджра
        let countdown = Calendar.current.dateComponents([.hour, .minute, .second], from: now, to: nextPrayerTime)
        timeUntilNextPrayer = String(format: "%02d:%02d:%02d", countdown.hour ?? 0, countdown.minute ?? 0, countdown.second ?? 0)
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
                    Image(systemName: "multiply.circle")
                        .imageScale(.large)
                        .foregroundColor(.black)
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
    func capsuleStyled() -> some View {
        self.foregroundStyle(.white)
            .background(Color.black.opacity(0.1))
            .clipShape(Capsule())
    }
}

extension View {
    func cardStyled() -> some View {
        self.font(.headline)
        .foregroundColor(.black)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.vertical, 85)
    }
}

extension View {
    func transparentStyled() -> some View {
        self.padding(.vertical)
        .background(Color.black.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(5)
    }
}

#Preview {
    PrayerTimeView()
}
