//
//  UmrahPageView.swift
//

import SwiftUI

struct UmrahPageView: View {
    @State private var currentStep: UmraStep
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager

    private let allSteps: [UmraStep] = [.step1, .step2, .step3, .step4, .step5, .step6, .step7]

    init(startingAt step: UmraStep) {
        _currentStep = State(initialValue: step)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                themeManager.selectedTheme.backgroundColor
                    .ignoresSafeArea()

                ScrollViewReader { proxy in
                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
                            Step1()
                                .frame(width: geo.size.width)
                                .id(UmraStep.step1)
                            Step2()
                                .frame(width: geo.size.width)
                                .id(UmraStep.step2)
                            Step3()
                                .frame(width: geo.size.width)
                                .id(UmraStep.step3)
                            Step4()
                                .frame(width: geo.size.width)
                                .id(UmraStep.step4)
                            Step5()
                                .frame(width: geo.size.width)
                                .id(UmraStep.step5)
                            Step6()
                                .frame(width: geo.size.width)
                                .id(UmraStep.step6)
                            Step7()
                                .frame(width: geo.size.width)
                                .id(UmraStep.step7)
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.paging)
                    .scrollIndicators(.hidden)
                    .scrollPosition(id: Binding<UmraStep?>(
                        get: { currentStep },
                        set: { if let v = $0 { currentStep = v } }
                    ))
                    .onAppear {
                        proxy.scrollTo(currentStep, anchor: .leading)
                    }
                }

                pageIndicator
                    .padding(.bottom, -8)
            }
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

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(allSteps.indices, id: \.self) { index in
                Circle()
                    .fill(currentStep == allSteps[index]
                          ? themeManager.selectedTheme.primaryColor
                          : themeManager.selectedTheme.textColor.opacity(0.3))
                    .frame(width: currentStep == allSteps[index] ? 8 : 6,
                           height: currentStep == allSteps[index] ? 8 : 6)
                    .animation(.easeInOut(duration: 0.2), value: currentStep)
            }
        }
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
