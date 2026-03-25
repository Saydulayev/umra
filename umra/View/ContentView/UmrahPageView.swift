//
//  UmrahPageView.swift
//  umra
//

import SwiftUI

struct UmrahPageView: View {
    @State private var currentStep: UmraStep
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager

    init(startingAt step: UmraStep) {
        _currentStep = State(initialValue: step)
    }

    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea()
            TabView(selection: $currentStep) {
                Step1().tag(UmraStep.step1)
                Step2().tag(UmraStep.step2)
                Step3().tag(UmraStep.step3)
                Step4().tag(UmraStep.step4)
                Step5().tag(UmraStep.step5)
                Step6().tag(UmraStep.step6)
                Step7().tag(UmraStep.step7)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .ignoresSafeArea(edges: .bottom)
        }
        .navigationTitle(Text(titleKey, bundle: localizationManager.bundle))
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

    private var titleKey: LocalizedStringKey {
        switch currentStep {
        case .step1: "title_ihram_screen"
        case .step2: "title_round_kaaba_screen"
        case .step3: "title_place_ibrohim_stand_screen"
        case .step4: "title_water_zamzam_screen"
        case .step5: "title_black_stone_screen"
        case .step6: "title_safa_and_marva_screen"
        case .step7: "title_shave_head_screen"
        case .useful: ""
        }
    }
}
