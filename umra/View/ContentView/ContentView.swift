//
//  ContentView.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

enum UmraStep: Hashable, Sendable {
    case step1
    case step2
    case step3
    case step4
    case step5
    case step6
    case step7
    case useful
}

enum AppDestination: Hashable, Sendable {
    case settings
}

struct ContentView: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(UserPreferences.self) private var userPreferences
    @Environment(FontManager.self) private var fontManager
    @Environment(PurchaseManager.self) private var purchaseManager
    @State private var showPrayerTimes = false
    @State private var navigationPath = NavigationPath()
    @State private var imageDescriptions: [String: String] = [
        "img1": "title_ihram_screen",
        "img2": "title_round_kaaba_screen",
        "img3": "title_place_ibrohim_stand_screen",
        "img4": "title_water_zamzam_screen",
        "img5": "title_black_stone_screen",
        "img6": "title_safa_and_marva_screen",
        "img7": "title_shave_head_screen",
        "img8": "Useful"
    ]
    @State private var usageTime: TimeInterval = 0
    @State private var usageTimerTask: Task<Void, Never>?
    @Environment(\.requestReview) var requestReview
    
    let steps: [(String, UmraStep, String)] = [
        ("img1", .step1, "title_ihram_screen"),
        ("img2", .step2, "title_round_kaaba_screen"),
        ("img3", .step3, "title_place_ibrohim_stand_screen"),
        ("img4", .step4, "title_water_zamzam_screen"),
        ("img5", .step5, "title_black_stone_screen"),
        ("img6", .step6, "title_safa_and_marva_screen"),
        ("img7", .step7, "title_shave_head_screen"),
        ("img8", .useful, "Useful")
    ]
    
    @ViewBuilder
    private func destinationView(for step: UmraStep) -> some View {
        switch step {
        case .step1:
            Step1()
        case .step2:
            Step2()
        case .step3:
            Step3()
        case .step4:
            Step4()
        case .step5:
            Step5()
        case .step6:
            Step6()
        case .step7:
            Step7()
        case .useful:
            UsefulInfoView()
        }
    }
    
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
                LanguageView().hidden()
            }
            .navigationBarTitle(Text("main_screen_name_string", bundle: localizationManager.bundle), displayMode: .inline)
            .navigationDestination(for: UmraStep.self) { step in
                destinationView(for: step)
            }
            .navigationDestination(for: Chapter.self) { chapter in
                ChapterDestinationView(chapter: chapter)
                    .environment(themeManager)
                    .environment(localizationManager)
            }
            .navigationDestination(for: SubChapter.self) { subChapter in
                SubChapterDetailView(subChapter: subChapter)
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
                    Button {
                        navigationPath.append(step.1)
                    } label: {
                        StepRow(step: step, index: index)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 8)
                    .id("\(step.1)-\(index)")
                }
            }
            .padding(.vertical, 10)
        }
    }
    
    /// Для сетки: отображение шагов через отдельный View StepView
    private func stepsView(showIndex: Bool, fontSize: CGFloat) -> some View {
        ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
            Button {
                navigationPath.append(step.1)
            } label: {
                StepView(
                    imageName: step.0,
                    titleKey: LocalizedStringKey(step.2),
                    stringKey: step.2,
                    index: showIndex ? index : nil,
                    fontSize: fontSize,
                    stepsCount: steps.count,
                    hideLastIndex: true,
                    imageDescriptions: $imageDescriptions
                )
                .foregroundStyle(themeManager.selectedTheme.textColor)
            }
            .buttonStyle(PlainButtonStyle())
            .id("\(step.1)-\(index)")
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

/// Вспомогательный view для навигации к Chapter
private struct ChapterDestinationView: View {
    let chapter: Chapter
    @Environment(LocalizationManager.self) private var localizationManager
    
    var body: some View {
        if chapter.title == "title_janaza_guide".localized(bundle: localizationManager.bundle ?? .main) {
            JanazaView()
        } else {
            ChapterDetailView(chapter: chapter)
        }
    }
}

/// Отдельный View для отображения строки шага в списке
private struct StepRow: View {
    var step: (String, UmraStep, String)
    var index: Int
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    
    var body: some View {
        HStack(spacing: 15) {
            Image(step.0)
                .styledImageWithThemeColors(theme: themeManager.selectedTheme)
            VStack(alignment: .leading, spacing: 5) {
                Text(LocalizedStringKey(step.2), bundle: localizationManager.bundle)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(themeManager.selectedTheme.textColor)
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
    ContentView()
        .environment(ThemeManager())
        .environment(LocalizationManager())
        .environment(UserPreferences())
        .environment(FontManager())
        .environment(PurchaseManager())
}
































