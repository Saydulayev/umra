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
    case prayerTimes
}

struct StepItem: Identifiable {
    let id: Int
    let badgeText: String
    let badgeColor: Color
    let step: UmraStep
    let titleKey: String
}

struct ContentView: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(UserPreferences.self) private var userPreferences
    @Environment(FontManager.self) private var fontManager
    @Environment(PurchaseManager.self) private var purchaseManager
    @Environment(BackgroundTaskManager.self) private var backgroundTaskManager
    @Environment(AudioManager.self) private var audioManager
    @State private var navigationPath = NavigationPath()
    @State private var usageTime: TimeInterval = 0
    @State private var usageTimerTask: Task<Void, Never>?
    @Environment(\.requestReview) var requestReview
    
    private let steps: [StepItem] = [
        StepItem(id: 0, badgeText: "IHRAM", badgeColor: Color(red: 0.063, green: 0.725, blue: 0.506), step: .step1, titleKey: "title_ihram_screen"),         // Emerald #10B981
        StepItem(id: 1, badgeText: "TAWAF", badgeColor: Color(red: 0.831, green: 0.635, blue: 0.306), step: .step2, titleKey: "title_round_kaaba_screen"),     // Amber #D4A24E
        StepItem(id: 2, badgeText: "MAQAM\nIBRAHIM", badgeColor: Color(red: 0.078, green: 0.722, blue: 0.651), step: .step3, titleKey: "title_place_ibrohim_stand_screen"), // Teal #14B8A6
        StepItem(id: 3, badgeText: "ZAMZAM", badgeColor: Color(red: 0.063, green: 0.725, blue: 0.506), step: .step4, titleKey: "title_water_zamzam_screen"),   // Emerald #10B981
        StepItem(id: 4, badgeText: "ISTILAM", badgeColor: Color(red: 0.831, green: 0.635, blue: 0.306), step: .step5, titleKey: "title_black_stone_screen"),   // Amber #D4A24E
        StepItem(id: 5, badgeText: "SA'I", badgeColor: Color(red: 0.42, green: 0.61, blue: 0.56), step: .step6, titleKey: "title_safa_and_marva_screen"),   // Светлый sage #6B9B8E
        StepItem(id: 6, badgeText: "HALQ\nTAQSIR", badgeColor: Color(red: 0.063, green: 0.725, blue: 0.506), step: .step7, titleKey: "title_shave_head_screen"),       // Emerald #10B981
        StepItem(id: 7, badgeText: "INFO", badgeColor: Color(red: 0.29, green: 0.51, blue: 0.78), step: .useful, titleKey: "Useful")  // Синий — ассоциация с меню «Полезное»
    ]
    
    private var numberedSteps: [StepItem] {
        steps.filter { $0.step != .useful }
    }
    
    // MARK: - Navigation
    
    @ViewBuilder
    private func destinationView(for step: UmraStep) -> some View {
        stepView(for: step)
            .environment(themeManager)
            .environment(localizationManager)
            .environment(userPreferences)
            .environment(fontManager)
            .environment(purchaseManager)
            .environment(audioManager)
    }

    @ViewBuilder
    private func stepView(for step: UmraStep) -> some View {
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
    
    // MARK: - Computed Properties
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var dynamicFontSize: CGFloat {
        10
    }
    
    private var gridSpacing: CGFloat {
        20
    }
    
    private var listSpacing: CGFloat {
        isIPad ? 14 : 12
    }
    
    private var listPadding: CGFloat {
        isIPad ? 20 : 16
    }
    
    private var listCardCornerRadius: CGFloat {
        isIPad ? 28 : 24
    }
    
    // MARK: - Body
    
    var body: some View {
        mainContentView
            .onAppear(perform: startTimer)
            .onDisappear(perform: stopTimer)
            .onChange(of: navigationPath.count) { oldValue, newValue in
                if newValue == 0 && oldValue > 0 {
                    navigationPath = NavigationPath()
                }
            }
    }

    private var mainContentView: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                themeManager.selectedTheme.backgroundColor
                    .ignoresSafeArea()
                
                ScrollView {
                    content
                        .padding(.vertical, 8)
                }
                .scrollIndicators(.hidden)
                LanguageView().hidden()
            }
            .navigationBarTitleDisplayMode(.inline)
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
                    .environment(themeManager)
                    .environment(localizationManager)
            }
            .navigationDestination(for: AppDestination.self) { destination in
                switch destination {
                case .settings:
                    SettingsView()
                        .environment(themeManager)
                        .environment(localizationManager)
                        .environment(purchaseManager)
                case .prayerTimes:
                    PrayerTimeView()
                        .environment(themeManager)
                        .environment(localizationManager)
                        .environment(backgroundTaskManager)
                        .toolbar(.hidden, for: .tabBar)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(value: AppDestination.prayerTimes) {
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
        }
    }
    
    // MARK: - View Builders
    
    @ViewBuilder
    private var content: some View {
        VStack(spacing: 0) {
            stepsHeader
            
            if !isIPad && userPreferences.isGridView {
                LazyVGrid(columns: gridColumns, spacing: gridSpacing) {
                    stepsGridView(showIndex: true, fontSize: dynamicFontSize)
                }
                .padding(.horizontal, 16)
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(numberedSteps.enumerated()), id: \.element.id) { idx, stepItem in
                        Button {
                            navigationPath.append(stepItem.step)
                        } label: {
                            StepRow(stepItem: stepItem, index: stepItem.id)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .id("\(stepItem.step)-\(stepItem.id)")
                        
                        if idx < numberedSteps.count - 1 {
                            Divider()
                                .background(themeManager.selectedTheme.textColor.opacity(0.10))
                                .padding(.leading, isIPad ? 112 : 92)
                        }
                    }
                }
                .standardCardFrame(
                    theme: themeManager.selectedTheme,
                    cornerRadius: listCardCornerRadius,
                    borderWidth: 1
                )
                .padding(.horizontal, listPadding)

                if let usefulItem = steps.first(where: { $0.step == .useful }) {
                    Button {
                        navigationPath.append(usefulItem.step)
                    } label: {
                        StepRow(stepItem: usefulItem, index: usefulItem.id)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .standardCardFrame(
                        theme: themeManager.selectedTheme,
                        cornerRadius: listCardCornerRadius,
                        borderWidth: 1
                    )
                    .padding(.horizontal, listPadding)
                    .padding(.top, 16)
                }

                Spacer().frame(height: 32)
            }
        }
    }
    
    private var stepsHeader: some View {
        HStack {
            Text("umra_title", bundle: localizationManager.bundle)
                .font(.system(size: isIPad ? 36 : 28, weight: .bold))
                .foregroundColor(themeManager.selectedTheme.textColor)
            
            Spacer()
            
            Button {
                userPreferences.isGridView.toggle()
            } label: {
                Text("order_label", bundle: localizationManager.bundle)
                    .font(.system(size: isIPad ? 16 : 14))
                    .foregroundColor(themeManager.selectedTheme.textColor.opacity(0.5))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(themeManager.selectedTheme.cardColor)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(themeManager.selectedTheme.textColor.opacity(0.1), lineWidth: 0.5)
                    )
            }
        }
        .padding(.horizontal, isIPad ? 24 : 24)
        .padding(.top, 12)
        .padding(.bottom, 24)
    }
    
    private func stepsWord(_ count: Int) -> String {
        let mod10 = count % 10
        let mod100 = count % 100
        if mod100 >= 11 && mod100 <= 19 {
            return NSLocalizedString("steps_count_many", bundle: localizationManager.bundle ?? .main, comment: "")
        }
        if mod10 == 1 {
            return NSLocalizedString("steps_count_one", bundle: localizationManager.bundle ?? .main, comment: "")
        }
        if mod10 >= 2 && mod10 <= 4 {
            return NSLocalizedString("steps_count_few", bundle: localizationManager.bundle ?? .main, comment: "")
        }
        return NSLocalizedString("steps_count_many", bundle: localizationManager.bundle ?? .main, comment: "")
    }
    
    private func stepsGridView(showIndex: Bool, fontSize: CGFloat) -> some View {
        ForEach(steps) { stepItem in
            Button {
                navigationPath.append(stepItem.step)
            } label: {
                StepView(
                    badgeText: stepItem.badgeText,
                    badgeColor: stepItem.badgeColor,
                    titleKey: LocalizedStringKey(stepItem.titleKey),
                    stringKey: stepItem.titleKey,
                    index: showIndex ? stepItem.id : nil,
                    fontSize: fontSize,
                    stepsCount: steps.count,
                    hideLastIndex: true
                )
                .foregroundStyle(themeManager.selectedTheme.textColor)
            }
            .buttonStyle(PlainButtonStyle())
            .id("\(stepItem.step)-\(stepItem.id)")
        }
    }
    
    // MARK: - Grid Configuration
    
    private var gridColumns: [GridItem] {
        let screenWidth = UIScreen.main.bounds.width
        let columnCount = AppConstants.gridColumnCount
        let spacing = AppConstants.gridColumnSpacing
        let horizontalPadding: CGFloat = 32
        let availableWidth = screenWidth - horizontalPadding
        let totalSpacing = CGFloat(columnCount - 1) * spacing
        let columnWidth = (availableWidth - totalSpacing) / CGFloat(columnCount)
        return Array(repeating: GridItem(.fixed(columnWidth)), count: columnCount)
    }
    
    // MARK: - Timer Management
    
    /// Запуск таймера для запроса отзыва
    private func startTimer() {
        guard !userPreferences.hasRatedApp else { return }
        usageTimerTask = Task { @MainActor in
            while !Task.isCancelled {
                usageTime += 1
                if usageTime >= AppConstants.reviewRequestTimeInterval {
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

// MARK: - Supporting Views

private struct ChapterDestinationView: View {
    let chapter: Chapter
    @Environment(LocalizationManager.self) private var localizationManager
    
    var body: some View {
        if chapter.title == "title_janaza_guide".localized(bundle: localizationManager.bundle ?? .main) {
            JanazaView()
        } else if chapter.title == "sunnahs_safar".localized(bundle: localizationManager.bundle ?? .main) {
            JourneyContentView(chapter: chapter)
        } else {
            ChapterDetailView(chapter: chapter)
        }
    }
}

private struct StepRow: View {
    let stepItem: StepItem
    let index: Int
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var badgeSize: CGFloat {
        isIPad ? 72 : 56
    }
    
    private var badgeFontSize: CGFloat {
        let longestLine = stepItem.badgeText.components(separatedBy: "\n").map(\.count).max() ?? 0
        let baseSize: CGFloat = isIPad ? 14 : 10
        if longestLine > 6 { return baseSize * 0.80 }
        if longestLine > 4 { return baseSize * 0.90 }
        return baseSize
    }
    
    var body: some View {
        HStack(spacing: isIPad ? 20 : 16) {
            ZStack {
                Circle()
                    .fill(stepItem.badgeColor.opacity(0.15))
                Text(stepItem.badgeText)
                    .font(.system(size: badgeFontSize, weight: .bold))
                    .tracking(-0.5)
                    .foregroundColor(stepItem.badgeColor)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 4)
            }
            .frame(width: badgeSize, height: badgeSize)
            
            VStack(alignment: .leading, spacing: 4) {
                if stepItem.step != .useful {
                    Text("\(NSLocalizedString("step_prefix", bundle: localizationManager.bundle ?? .main, comment: "")) \(index + 1)")
                        .font(.system(size: isIPad ? 14 : 11, weight: .medium))
                        .tracking(0.5)
                        .foregroundColor(themeManager.selectedTheme.textColor.opacity(0.4))
                        .textCase(.uppercase)
                }
                Text(LocalizedStringKey(stepItem.titleKey), bundle: localizationManager.bundle)
                    .font(.system(size: isIPad ? 24 : 18, weight: .semibold))
                    .foregroundColor(themeManager.selectedTheme.textColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: isIPad ? 16 : 14, weight: .semibold))
                .foregroundColor(themeManager.selectedTheme.textColor.opacity(0.25))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .padding(.horizontal, isIPad ? 24 : 20)
        .padding(.vertical, isIPad ? 16 : 14)
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



























