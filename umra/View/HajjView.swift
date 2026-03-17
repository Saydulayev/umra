//
//  HajjView.swift
//  umra
//
//  Created on 25.01.25.
//

import SwiftUI

enum HajjStep: Hashable, Sendable {
    case step1, step2, step3, step4, step5
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

    private let steps: [GuideStepItem] = [
        GuideStepItem(id: 0, badgeText: "TARWIYAH", badgeColor: Color(red: 0.388, green: 0.400, blue: 0.945), titleKey: "hajj_step1_title", showDate: true), // Indigo
        GuideStepItem(id: 1, badgeText: "ARAFAT",   badgeColor: Color(red: 0.545, green: 0.361, blue: 0.965), titleKey: "hajj_step2_title", showDate: true), // Violet
        GuideStepItem(id: 2, badgeText: "NAHR",     badgeColor: Color(red: 0.878, green: 0.478, blue: 0.431), titleKey: "hajj_step3_title", showDate: true), // Rose
        GuideStepItem(id: 3, badgeText: "TASHRIQ",  badgeColor: Color(red: 0.42,  green: 0.61,  blue: 0.56),  titleKey: "hajj_step4_title", showDate: true), // Sage
        GuideStepItem(id: 4, badgeText: "WADA'",    badgeColor: Color(red: 0.078, green: 0.722, blue: 0.651), titleKey: "hajj_step5_title", showDate: true), // Teal
    ]

    private let hajjNavigation: [HajjStep] = [.step1, .step2, .step3, .step4, .step5]

    // MARK: - Navigation

    @ViewBuilder
    private func destinationView(for step: HajjStep) -> some View {
        Group {
            switch step {
            case .step1: HajjStep1()
            case .step2: HajjStep2()
            case .step3: HajjStep3()
            case .step4: HajjStep4()
            case .step5: HajjStep5()
            }
        }
        .environment(themeManager)
        .environment(localizationManager)
        .environment(userPreferences)
        .environment(fontManager)
        .environment(purchaseManager)
        .environment(audioManager)
    }

    // MARK: - Computed Properties

    private var listPadding: CGFloat { AppConstants.isIPad ? 20 : 16 }
    private var listCardCornerRadius: CGFloat { AppConstants.isIPad ? 28 : 24 }

    // MARK: - Body

    var body: some View {
        mainContentView
            .reviewTimer()
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
            .guideNavigation(titleKey: "hajj_title")
            .navigationDestination(for: HajjStep.self) { step in
                destinationView(for: step)
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
                        navigationPath.append(hajjNavigation[stepItem.id])
                    } label: {
                        GuideStepRow(item: stepItem, index: stepItem.id)
                    }
                    .pressableRowStyle()
                    .id("\(stepItem.id)")

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
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(themeManager.selectedTheme.textColor)
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
        .padding(.bottom, 24)
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
