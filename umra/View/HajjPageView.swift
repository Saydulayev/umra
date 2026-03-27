//
//  HajjPageView.swift
//

import SwiftUI

struct HajjPageView: View {
    @State private var currentStep: HajjStep
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager

    private let allSteps: [HajjStep] = [.step1, .step2, .step3, .step4, .step5]

    init(startingAt step: HajjStep) {
        _currentStep = State(initialValue: step)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                themeManager.selectedTheme.backgroundColor
                    .ignoresSafeArea()

                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        HajjStep1()
                            .frame(width: geo.size.width)
                            .id(HajjStep.step1)
                        HajjStep2()
                            .frame(width: geo.size.width)
                            .id(HajjStep.step2)
                        HajjStep3()
                            .frame(width: geo.size.width)
                            .id(HajjStep.step3)
                        HajjStep4()
                            .frame(width: geo.size.width)
                            .id(HajjStep.step4)
                        HajjStep5()
                            .frame(width: geo.size.width)
                            .id(HajjStep.step5)
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden)
                .scrollPosition(id: Binding<HajjStep?>(
                    get: { currentStep },
                    set: { if let v = $0 { currentStep = v } }
                ))

                pageIndicator
                    .padding(.bottom, 12)
            }
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
