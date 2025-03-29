//
//  ContentView.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var fontManager: FontManager
    @EnvironmentObject var purchaseManager: PurchaseManager
    
    @AppStorage("isGridView") private var isGridView: Bool = UIDevice.current.userInterfaceIdiom == .pad
    @State private var showPrayerTimes = false
    @State private var imageDescriptions: [String: String] = [
        "image 1": "title_ihram_screen",
        "image 2": "title_round_kaaba_screen",
        "image 3": "title_place_ibrohim_stand_screen",
        "image 4": "title_water_zamzam_screen",
        "image 5": "title_black_stone_screen",
        "image 6": "title_safa_and_marva_screen",
        "image 7": "title_shave_head_screen",
        "image 8": "Useful"
    ]
    @State private var usageTime: TimeInterval = 0
    @State private var timer: Timer?
    @AppStorage("hasRatedApp") private var hasRatedApp: Bool = false
    @Environment(\.requestReview) var requestReview
    
    let steps = [
        ("image 1", AnyView(Step1()), "title_ihram_screen"),
        ("image 2", AnyView(Step2()), "title_round_kaaba_screen"),
        ("image 3", AnyView(Step3()), "title_place_ibrohim_stand_screen"),
        ("image 4", AnyView(Step4()), "title_water_zamzam_screen"),
        ("image 5", AnyView(Step5()), "title_black_stone_screen"),
        ("image 6", AnyView(Step6()), "title_safa_and_marva_screen"),
        ("image 7", AnyView(Step7()), "title_shave_head_screen"),
        ("image 8", AnyView(UsefulInfoView()), "Useful")
    ]
    
    /// Вычисляемое свойство для определения устройства iPad
    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// Динамический размер шрифта в зависимости от устройства
    private var dynamicFontSize: CGFloat {
        isPad ? 30 : 10
    }
    
    var body: some View {
        ZStack {
            if settings.hasSelectedLanguage {
                mainContentView
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .scale(scale: 0.9).combined(with: .opacity)
                        )
                    )
            } else {
                LanguageSelectionView()
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        )
                    )
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: settings.hasSelectedLanguage)
        .onAppear(perform: startTimer)
        .onDisappear(perform: stopTimer)
    }

    
    /// Основное содержимое экрана
    private var mainContentView: some View {
        NavigationStack {
            ZStack {
                Color(UIColor(red: 0.898, green: 0.933, blue: 1, alpha: 1))
                    .ignoresSafeArea(edges: .bottom)
                
                ScrollView {
                    content
                        .padding(.vertical, 8)
                }
                .scrollIndicators(.hidden)
                .navigationBarTitle("UMRA", displayMode: .inline)
                .navigationBarItems(
                    leading: gridToggleButton,
                    trailing: HStack {
                        Button(action: { showPrayerTimes = true }) {
                            Image(systemName: "clock")
                                .imageScale(.large)
                                .foregroundColor(.primary)
                        }
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape")
                                .imageScale(.large)
                                .foregroundColor(.primary)
                        }
                    }
                )
                .sheet(isPresented: $showPrayerTimes) {
                    PrayerTimeModalView(isPresented: $showPrayerTimes)
                }
                LanguageView().hidden()
            }
        }
    }
    
    /// Кнопка для переключения между списком и сеткой (не отображается на iPad)
    private var gridToggleButton: some View {
        Button(action: { isGridView.toggle() }) {
            Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                .imageScale(.large)
                .foregroundColor(.primary)
        }
    }
    
    /// Отображение контента в виде сетки или списка
    @ViewBuilder
    private var content: some View {
        if isGridView {
            LazyVGrid(columns: gridColumns, spacing: 20) {
                stepsView(showIndex: true, fontSize: dynamicFontSize)
            }
            .padding(.horizontal)
        } else {
            LazyVStack(spacing: 8) {
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    NavigationLink(destination: step.1) {
                        StepRow(step: step, index: index)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 8)
                }
            }
            .padding(.vertical, 10)
        }
    }
    
    /// Для сетки: отображение шагов через отдельный View StepView
    private func stepsView(showIndex: Bool, fontSize: CGFloat) -> some View {
        ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
            StepView(
                imageName: step.0,
                destinationView: step.1,
                titleKey: LocalizedStringKey(step.2),
                index: showIndex ? index : nil,
                fontSize: fontSize,
                stepsCount: steps.count,
                imageDescriptions: $imageDescriptions
            )
            .foregroundStyle(.black)
        }
    }
    
    /// Создание столбцов для LazyVGrid
    private var gridColumns: [GridItem] {
        let screenWidth = UIScreen.main.bounds.width
        let columnWidth = screenWidth / 2 - 10
        return Array(repeating: GridItem(.fixed(columnWidth)), count: 2)
    }
    
    /// Запуск таймера для запроса отзыва
    private func startTimer() {
        guard !hasRatedApp else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            usageTime += 1
            if usageTime >= 300 {
                stopTimer()
                requestReviewIfNeeded()
            }
        }
    }
    
    /// Остановка таймера
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// Запрос отзыва, если это необходимо
    private func requestReviewIfNeeded() {
        guard !hasRatedApp else { return }
        requestReview()
        hasRatedApp = true
    }
}

/// Отдельный View для отображения строки шага в списке
private struct StepRow: View {
    var step: (String, AnyView, String)
    var index: Int
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        HStack(spacing: 15) {
            Image(step.0)
                .styledImage()
            VStack(alignment: .leading, spacing: 5) {
                Text(LocalizedStringKey(step.2), bundle: settings.bundle)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black)
                .frame(width: 24, height: 24)
                .background(
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                )
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserSettings())
            .environmentObject(FontManager())
            .environmentObject(PurchaseManager())
    }
}
































