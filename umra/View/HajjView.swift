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
    let badgeText: String
    let badgeColor: Color
    let step: HajjStep
    let titleKey: String
}

struct HajjView: View {
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
    
    private let steps: [HajjStepItem] = [
        HajjStepItem(id: 0, badgeText: "TARWIYAH", badgeColor: Color(red: 0.388, green: 0.400, blue: 0.945), step: .step1, titleKey: "hajj_step1_title"),  // Indigo #6366F1
        HajjStepItem(id: 1, badgeText: "ARAFAT", badgeColor: Color(red: 0.545, green: 0.361, blue: 0.965), step: .step2, titleKey: "hajj_step2_title"),     // Violet #8B5CF6
        HajjStepItem(id: 2, badgeText: "NAHR", badgeColor: Color(red: 0.878, green: 0.478, blue: 0.431), step: .step3, titleKey: "hajj_step3_title"),       // Rose #E07A6E
        HajjStepItem(id: 3, badgeText: "TASHRIQ", badgeColor: Color(red: 0.42, green: 0.61, blue: 0.56), step: .step4, titleKey: "hajj_step4_title"),    // Светлый sage #6B9B8E
        HajjStepItem(id: 4, badgeText: "WADA'", badgeColor: Color(red: 0.078, green: 0.722, blue: 0.651), step: .step5, titleKey: "hajj_step5_title")       // Teal #14B8A6
    ]
    
    @ViewBuilder
    private func destinationView(for step: HajjStep) -> some View {
        Group {
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
        .environment(themeManager)
        .environment(localizationManager)
        .environment(userPreferences)
        .environment(fontManager)
        .environment(purchaseManager)
        .environment(audioManager)
    }
    

    private var listSpacing: CGFloat {
        AppConstants.isIPad ? 14 : 12
    }
    
    private var listPadding: CGFloat {
        AppConstants.isIPad ? 20 : 16
    }

    private var listCardCornerRadius: CGFloat {
        AppConstants.isIPad ? 28 : 24
    }
    
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
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: HajjStep.self) { step in
                destinationView(for: step)
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
                ToolbarItemGroup(placement: .topBarTrailing) {
                    NavigationLink(value: AppDestination.prayerTimes) {
                        Image(systemName: "clock")
                            .imageScale(.large)
                            .foregroundStyle(.primary)
                            .accessibilityLabel("Prayer Times")
                    }
                    NavigationLink(value: AppDestination.settings) {
                        Image(systemName: "gearshape")
                            .imageScale(.large)
                            .foregroundStyle(.primary)
                            .accessibilityLabel("Settings")
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

            VStack(spacing: 0) {
                ForEach(Array(steps.enumerated()), id: \.element.id) { idx, stepItem in
                    Button {
                        navigationPath.append(stepItem.step)
                    } label: {
                        HajjStepRow(stepItem: stepItem, index: stepItem.id)
                    }
                    .buttonStyle(.plain)
                    .id("\(stepItem.step)-\(stepItem.id)")

                    if idx < steps.count - 1 {
                        Divider()
                            .background(themeManager.selectedTheme.textColor.opacity(0.10))
                            .padding(.leading, AppConstants.isIPad ? 112 : 92)
                    }
                }
            }
            .standardCardFrame(theme: themeManager.selectedTheme, cornerRadius: listCardCornerRadius)
            .padding(.horizontal, listPadding)
            .padding(.bottom, 32)
        }
    }
    
    private var stepsHeader: some View {
        HStack {
            Text("hajj_title", bundle: localizationManager.bundle)
                .font(.system(size: AppConstants.isIPad ? 36 : 28, weight: .bold))
                .foregroundStyle(themeManager.selectedTheme.textColor)

            Spacer()
        }
        .padding(.horizontal, AppConstants.isIPad ? 24 : 24)
        .padding(.top, 12)
        .padding(.bottom, 24)
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

private struct HajjStepRow: View {
    let stepItem: HajjStepItem
    let index: Int
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    
    
    private var badgeSize: CGFloat {
        AppConstants.isIPad ? 72 : 56
    }
    
    private var badgeFontSize: CGFloat {
        let textLength = stepItem.badgeText.count
        let baseSize: CGFloat = AppConstants.isIPad ? 14 : 10
        if textLength > 6 { return baseSize * 0.80 }
        if textLength > 4 { return baseSize * 0.90 }
        return baseSize
    }
    
    private var parsedTitle: (name: String, date: String?) {
        let fullText = localizationManager.localized(stepItem.titleKey)
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
        HStack(spacing: AppConstants.isIPad ? 20 : 16) {
            ZStack {
                Circle()
                    .fill(stepItem.badgeColor.opacity(0.15))
                Text(stepItem.badgeText)
                    .font(.system(size: badgeFontSize, weight: .bold))
                    .tracking(-0.5)
                    .foregroundStyle(stepItem.badgeColor)
                    .minimumScaleFactor(0.6)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .padding(.horizontal, 4)
            }
            .frame(width: badgeSize, height: badgeSize)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(localizationManager.localized("step_prefix")) \(index + 1)")
                    .font(.system(size: AppConstants.isIPad ? 14 : 11, weight: .medium))
                    .tracking(0.5)
                    .foregroundStyle(themeManager.selectedTheme.textColor.opacity(0.4))
                    .textCase(.uppercase)
                
                Text(parsedTitle.name)
                    .font(.system(size: AppConstants.isIPad ? 24 : 18, weight: .semibold))
                    .foregroundStyle(themeManager.selectedTheme.textColor)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let date = parsedTitle.date {
                    Text(date)
                        .font(.system(size: AppConstants.isIPad ? 15 : 12))
                        .foregroundStyle(themeManager.selectedTheme.textColor.opacity(0.45))
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: AppConstants.isIPad ? 16 : 14, weight: .semibold))
                .foregroundStyle(themeManager.selectedTheme.textColor.opacity(0.25))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .padding(.horizontal, AppConstants.isIPad ? 24 : 20)
        .padding(.vertical, AppConstants.isIPad ? 16 : 14)
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
