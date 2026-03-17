//
//  ContentView.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

enum UmraStep: Hashable, Sendable {
    case step1, step2, step3, step4, step5, step6, step7, useful
}

enum AppDestination: Hashable, Sendable {
    case settings
    case prayerTimes
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

    private let steps: [GuideStepItem] = [
        GuideStepItem(id: 0, badgeText: "IHRAM",         badgeColor: Color(red: 0.055, green: 0.647, blue: 0.914), titleKey: "title_ihram_screen"),          // Sky Blue
        GuideStepItem(id: 1, badgeText: "TAWAF",         badgeColor: Color(red: 0.831, green: 0.635, blue: 0.306), titleKey: "title_round_kaaba_screen"),     // Amber
        GuideStepItem(id: 2, badgeText: "MAQAM\nIBRAHIM", badgeColor: Color(red: 0.078, green: 0.722, blue: 0.651), titleKey: "title_place_ibrohim_stand_screen"), // Teal
        GuideStepItem(id: 3, badgeText: "ZAMZAM",        badgeColor: Color(red: 0.063, green: 0.725, blue: 0.506), titleKey: "title_water_zamzam_screen"),    // Emerald
        GuideStepItem(id: 4, badgeText: "ISTILAM",       badgeColor: Color(red: 0.878, green: 0.478, blue: 0.431), titleKey: "title_black_stone_screen"),     // Rose
        GuideStepItem(id: 5, badgeText: "SA'I",          badgeColor: Color(red: 0.42,  green: 0.61,  blue: 0.56),  titleKey: "title_safa_and_marva_screen"),  // Sage
        GuideStepItem(id: 6, badgeText: "HALQ\nTAQSIR",  badgeColor: Color(red: 0.545, green: 0.361, blue: 0.965), titleKey: "title_shave_head_screen"),      // Violet
        GuideStepItem(id: 7, badgeText: "INFO",          badgeColor: Color(red: 0.29,  green: 0.51,  blue: 0.78),  titleKey: "Useful", showStepNumber: false), // Blue
    ]

    private let umraNavigation: [UmraStep] = [.step1, .step2, .step3, .step4, .step5, .step6, .step7, .useful]

    private var numberedSteps: [GuideStepItem] {
        steps.filter { $0.showStepNumber }
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
        case .step1: Step1()
        case .step2: Step2()
        case .step3: Step3()
        case .step4: Step4()
        case .step5: Step5()
        case .step6: Step6()
        case .step7: Step7()
        case .useful: UsefulInfoView()
        }
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
            .guideNavigation(titleKey: "umra_title")
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
        }
    }

    // MARK: - View Builders

    @ViewBuilder
    private var content: some View {
        VStack(spacing: 0) {
            stepsHeader

            VStack(spacing: 0) {
                ForEach(Array(numberedSteps.enumerated()), id: \.element.id) { idx, stepItem in
                    Button {
                        navigationPath.append(umraNavigation[stepItem.id])
                    } label: {
                        GuideStepRow(item: stepItem, index: stepItem.id)
                    }
                    .pressableRowStyle()
                    .id("\(stepItem.id)")

                    if idx < numberedSteps.count - 1 {
                        Divider()
                            .background(themeManager.selectedTheme.textColor.opacity(0.10))
                            .padding(.leading, AppConstants.isIPad ? 112 : 92)
                    }
                }
            }
            .standardCardFrame(
                theme: themeManager.selectedTheme,
                cornerRadius: listCardCornerRadius,
                borderWidth: 1
            )
            .padding(.horizontal, listPadding)

            if let usefulItem = steps.first(where: { !$0.showStepNumber }) {
                Button {
                    navigationPath.append(UmraStep.useful)
                } label: {
                    GuideStepRow(item: usefulItem, index: usefulItem.id)
                }
                .pressableRowStyle()
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

    private var stepsHeader: some View {
        HStack {
            Text("umra_title", bundle: localizationManager.bundle)
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(themeManager.selectedTheme.textColor)
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
        .padding(.bottom, 24)
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

#Preview {
    ContentView()
        .environment(ThemeManager())
        .environment(LocalizationManager())
        .environment(UserPreferences())
        .environment(FontManager())
        .environment(PurchaseManager())
}
