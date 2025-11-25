//
//  HajjView.swift
//  umra
//
//  Created on 25.01.25.
//

import SwiftUI

struct HajjView: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(UserPreferences.self) private var userPreferences
    @Environment(FontManager.self) private var fontManager
    @Environment(PurchaseManager.self) private var purchaseManager
    @State private var showPrayerTimes = false
    @State private var imageDescriptions: [String: String] = [
        "hajj1": "hajj_step1_title",
        "hajj2": "hajj_step2_title",
        "hajj3": "hajj_step3_title",
        "hajj4": "hajj_step4_title",
        "hajj5": "hajj_step5_title"
    ]
    @State private var usageTime: TimeInterval = 0
    @State private var timer: Timer?
    @Environment(\.requestReview) var requestReview
    
    // Шаги хаджа
    let steps = [
        ("hajj1", AnyView(HajjStep1()), "hajj_step1_title"),
        ("hajj2", AnyView(HajjStep2()), "hajj_step2_title"),
        ("hajj3", AnyView(HajjStep3()), "hajj_step3_title"),
        ("hajj4", AnyView(HajjStep4()), "hajj_step4_title"),
        ("hajj5", AnyView(HajjStep5()), "hajj_step5_title")
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
        mainContentView
            .onAppear(perform: startTimer)
            .onDisappear(perform: stopTimer)
    }

    
    /// Основное содержимое экрана
    private var mainContentView: some View {
        NavigationStack {
            ZStack {
                // Применяем тему к фону, но сохраняем оригинальный вид
                themeManager.selectedTheme.backgroundColor
                    .ignoresSafeArea(edges: .bottom)
                
                ScrollView {
                    content
                        .padding(.vertical, 8)
                }
                .scrollIndicators(.hidden)
                .navigationBarTitle(Text("hajj_screen_title", bundle: localizationManager.bundle), displayMode: .inline)
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
        Button(action: { userPreferences.isGridView.toggle() }) {
            Image(systemName: userPreferences.isGridView ? "list.bullet" : "square.grid.2x2")
                .imageScale(.large)
                .foregroundColor(.primary)
        }
    }
    
    /// Отображение контента в виде сетки или списка
    @ViewBuilder
    private var content: some View {
        if userPreferences.isGridView {
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
                stringKey: step.2,
                index: showIndex ? index : nil,
                fontSize: fontSize,
                stepsCount: steps.count,
                hideLastIndex: false,
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
        guard !userPreferences.hasRatedApp else { return }
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
        guard !userPreferences.hasRatedApp else { return }
        requestReview()
        userPreferences.hasRatedApp = true
    }
}

/// Отдельный View для отображения строки шага в списке
private struct StepRow: View {
    var step: (String, AnyView, String)
    var index: Int
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    
    /// Парсит строку локализации и разделяет на название и дату
    private var parsedTitle: (name: String, date: String?) {
        let fullText = NSLocalizedString(step.2, bundle: localizationManager.bundle ?? .main, comment: "")
        // Пробуем разные варианты разделителей: длинное тире, обычное тире, дефис
        let separators = [" — ", " - ", " – ", " —", " — "]
        for separator in separators {
            let components = fullText.components(separatedBy: separator)
            if components.count == 2 {
                let date = components[0].trimmingCharacters(in: .whitespaces)
                let name = components[1].trimmingCharacters(in: .whitespaces)
                if !date.isEmpty && !name.isEmpty {
                    return (name: name, date: date)
                }
            }
        }
        return (name: fullText, date: nil)
    }
    
    var body: some View {
        HStack(spacing: 15) {
            Image(step.0)
                .styledImageWithThemeColors(theme: themeManager.selectedTheme)
            VStack(alignment: .leading, spacing: 4) {
                Text(parsedTitle.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                if let date = parsedTitle.date {
                    Text(date)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.secondary)
                }
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

struct HajjView_Previews: PreviewProvider {
    static var previews: some View {
        HajjView()
            .environment(ThemeManager())
            .environment(LocalizationManager())
            .environment(UserPreferences())
            .environment(FontManager())
            .environment(PurchaseManager())
    }
}

