//
//  HajjPageView.swift
//  umra
//

import SwiftUI

struct HajjPageView: View {
    @State private var currentStep: HajjStep
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager

    init(startingAt step: HajjStep) {
        _currentStep = State(initialValue: step)
    }

    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea()
            TabView(selection: $currentStep) {
                HajjStep1().tag(HajjStep.step1)
                HajjStep2().tag(HajjStep.step2)
                HajjStep3().tag(HajjStep.step3)
                HajjStep4().tag(HajjStep.step4)
                HajjStep5().tag(HajjStep.step5)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
        .navigationTitle(localizationManager.extractTitleOnly(from: currentStepKey))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                CustomToolbar(
                    selectedFont: Bindable(fontManager).selectedFont,
                    fonts: fontManager.fonts
                )
                .environment(themeManager)
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }

    private var currentStepKey: String {
        switch currentStep {
        case .step1: "hajj_step1_title"
        case .step2: "hajj_step2_title"
        case .step3: "hajj_step3_title"
        case .step4: "hajj_step4_title"
        case .step5: "hajj_step5_title"
        }
    }
}
