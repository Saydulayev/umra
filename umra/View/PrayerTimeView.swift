//
//  PrayerTimeView.swift
//  umra
//
//  Created by Akhmed on 29.04.24.
//

import Adhan
import SwiftUI


struct PrayerTimeView: View {
    @State private var prayerTimes: [String: String] = [:]
    @State private var nextPrayerName = ""
    @State private var timeUntilNextPrayer = ""
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Ленивая инициализация форматтера
    private var islamicDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .islamicUmmAlQura)
        formatter.locale = Locale(identifier: "en_EN")
        formatter.dateFormat = "d MMMM yyyy"
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
                .ignoresSafeArea(edges: .bottom)
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
            }
            .onReceive(timer) { _ in
                updatePrayerTimes()
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
            if let todayPrayers = PrayerTimes(coordinates: coordinates, date: todayDateComponents, calculationParameters: params),
               let tomorrowPrayers = PrayerTimes(coordinates: coordinates, date: tomorrowDateComponents, calculationParameters: params) {
                let formatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.timeStyle = .short
                    formatter.timeZone = TimeZone(identifier: "Asia/Riyadh")!
                    return formatter
                }()
                
                let maghribToFajrInterval = tomorrowPrayers.fajr.timeIntervalSince(todayPrayers.maghrib)
                let lastThirdStart = todayPrayers.maghrib.addingTimeInterval(2 * maghribToFajrInterval / 3)
                
                let newPrayerTimes: [String: String] = [
                    "Fajr": formatter.string(from: todayPrayers.fajr),
                    "Sunrise": formatter.string(from: todayPrayers.sunrise),
                    "Dhuhr": formatter.string(from: todayPrayers.dhuhr),
                    "Asr": formatter.string(from: todayPrayers.asr),
                    "Maghrib": formatter.string(from: todayPrayers.maghrib),
                    "Isha": formatter.string(from: todayPrayers.isha),
                    "Qiyam": formatter.string(from: lastThirdStart)
                ]
                
                DispatchQueue.main.async {
                    self.prayerTimes = newPrayerTimes
                    self.updateCountdownToNextPrayer(prayers: todayPrayers)
                }
            }
        }
    }
    
    func updateCountdownToNextPrayer(prayers: PrayerTimes) {
        let now = Date()
        let _: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            formatter.timeZone = TimeZone(identifier: "Asia/Riyadh")!
            return formatter
        }()
        
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
