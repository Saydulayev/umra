//
//  HajjView.swift
//  umra
//
//  Created on 25.01.25.
//

import SwiftUI

enum HajjStep: Hashable, Sendable {
    case step1
    case step2
    case step3
    case step4
    case step5
}

struct HajjStepItem: Identifiable {
    let id: Int
    let imageName: String
    let step: HajjStep
    let titleKey: String
}

struct HajjView: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(UserPreferences.self) private var userPreferences
    @Environment(FontManager.self) private var fontManager
    @Environment(PurchaseManager.self) private var purchaseManager
    @State private var showPrayerTimes = false
    @State private var navigationPath = NavigationPath()
    @State private var imageDescriptions: [String: String] = [
        "hajj1": "hajj_step1_title",
        "hajj2": "hajj_step2_title",
        "hajj3": "hajj_step3_title",
        "hajj4": "hajj_step4_title",
        "hajj5": "hajj_step5_title"
    ]
    @State private var usageTime: TimeInterval = 0
    @State private var usageTimerTask: Task<Void, Never>?
    @Environment(\.requestReview) var requestReview
    
    // Шаги хаджа
    private let steps: [HajjStepItem] = [
        HajjStepItem(id: 0, imageName: "hajj1", step: .step1, titleKey: "hajj_step1_title"),
        HajjStepItem(id: 1, imageName: "hajj2", step: .step2, titleKey: "hajj_step2_title"),
        HajjStepItem(id: 2, imageName: "hajj3", step: .step3, titleKey: "hajj_step3_title"),
        HajjStepItem(id: 3, imageName: "hajj4", step: .step4, titleKey: "hajj_step4_title"),
        HajjStepItem(id: 4, imageName: "hajj5", step: .step5, titleKey: "hajj_step5_title")
    ]
    
    @ViewBuilder
    private func destinationView(for step: HajjStep) -> some View {
        switch step {
        case .step1:
            HajjStep1()
        case .step2:
            HajjStep2()
        case .step3:
            HajjStep3()
        case .step4:
            HajjStep4()
        case .step5:
            HajjStep5()
        }
    }
    
    /// Вычисляемое свойство для определения устройства iPad
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// Динамический размер шрифта в зависимости от устройства
    private var dynamicFontSize: CGFloat {
        isIPad ? 30 : 10
    }
    
    var body: some View {
        mainContentView
            .onAppear(perform: startTimer)
            .onDisappear(perform: stopTimer)
            .onChange(of: navigationPath.count) { oldValue, newValue in
                // Если путь навигации пуст, значит мы вернулись на главный экран
                if newValue == 0 && oldValue > 0 {
                    // Сбрасываем путь навигации при возврате на главный экран
                    navigationPath = NavigationPath()
                }
            }
    }

    
    /// Основное содержимое экрана
    private var mainContentView: some View {
        NavigationStack(path: $navigationPath) {
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
                .navigationDestination(for: HajjStep.self) { step in
                    destinationView(for: step)
                }
                .navigationDestination(for: AppDestination.self) { destination in
                    switch destination {
                    case .settings:
                        SettingsView()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        gridToggleButton
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: { showPrayerTimes = true }) {
                            Image(systemName: "clock")
                                .imageScale(.large)
                                .foregroundColor(.primary)
                        }
                        NavigationLink(value: AppDestination.settings) {
                            Image(systemName: "gearshape")
                                .imageScale(.large)
                                .foregroundColor(.primary)
                        }
                    }
                }
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
                ForEach(steps) { stepItem in
                    Button {
                        navigationPath.append(stepItem.step)
                    } label: {
                        StepRow(step: (stepItem.imageName, stepItem.step, stepItem.titleKey), index: stepItem.id)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 8)
                    .id("\(stepItem.step)-\(stepItem.id)")
                }
            }
            .padding(.vertical, 10)
        }
    }
    
    /// Для сетки: отображение шагов через отдельный View StepView
    private func stepsView(showIndex: Bool, fontSize: CGFloat) -> some View {
        ForEach(steps) { stepItem in
            Button {
                navigationPath.append(stepItem.step)
            } label: {
                StepView(
                    imageName: stepItem.imageName,
                    titleKey: LocalizedStringKey(stepItem.titleKey),
                    stringKey: stepItem.titleKey,
                    index: showIndex ? stepItem.id : nil,
                    fontSize: fontSize,
                    stepsCount: steps.count,
                    hideLastIndex: false,
                    imageDescriptions: $imageDescriptions
                )
                .foregroundStyle(themeManager.selectedTheme.textColor)
            }
            .buttonStyle(PlainButtonStyle())
            .id("\(stepItem.step)-\(stepItem.id)")
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
        usageTimerTask = Task { @MainActor in
            while !Task.isCancelled {
                usageTime += 1
                if usageTime >= 300 {
                    stopTimer()
                    requestReviewIfNeeded()
                    break
                }
                do {
                    try await Task.sleep(for: .seconds(1))
                } catch {
                    break
                }
            }
        }
    }
    
    /// Остановка таймера
    private func stopTimer() {
        usageTimerTask?.cancel()
        usageTimerTask = nil
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
    var step: (String, HajjStep, String)
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
                    .foregroundColor(themeManager.selectedTheme.textColor)
                if let date = parsedTitle.date {
                    Text(date)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(themeManager.selectedTheme.textColor.opacity(0.7))
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(themeManager.selectedTheme.textColor)
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
                .fill(themeManager.selectedTheme == .dark ? Color(UIColor(red: 0.25, green: 0.25, blue: 0.3, alpha: 1)) : Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        )
    }
}

#Preview {
    HajjView()
        .environment(ThemeManager())
        .environment(LocalizationManager())
        .environment(UserPreferences())
        .environment(FontManager())
        .environment(PurchaseManager())
}

