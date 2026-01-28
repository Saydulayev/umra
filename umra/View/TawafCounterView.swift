//
//  TawafCounterView.swift
//  umra
//
//  Created for Tawaf circuit counter (7 rounds around the Kaaba).
//

import SwiftUI

struct TawafCounterView: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @AppStorage(UserDefaultsKey.tawafCircuitCount) private var counter = 0
    @State private var showCelebration = false

    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    private var buttonWidth: CGFloat {
        isIPad ? 220 : 170
    }

    private var buttonHeight: CGFloat {
        isIPad ? 60 : 50
    }

    private var buttonFontSize: CGFloat {
        isIPad ? 20 : 16
    }

    private var buttonPadding: CGFloat {
        isIPad ? 20 : 16
    }

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("tawaf_circle_label", bundle: localizationManager.bundle)
                        .font(.largeTitle.bold())
                    Text("\(counter)")
                        .font(.largeTitle.bold())
                }

                if counter == 7 {
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: isIPad ? 28 : 24))
                            .foregroundStyle(themeManager.selectedTheme.primaryColor)
                        Text("tawaf_finished", bundle: localizationManager.bundle)
                            .font(.system(size: isIPad ? 22 : 18, weight: .semibold))
                            .foregroundColor(themeManager.selectedTheme.textColor)
                    }
                    .padding(.horizontal, isIPad ? 24 : 20)
                    .padding(.vertical, isIPad ? 16 : 14)
                    .background(
                        RoundedRectangle(cornerRadius: isIPad ? 24 : 20)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [
                                    themeManager.selectedTheme.gradientTopColor,
                                    themeManager.selectedTheme.gradientBottomColor
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .overlay(
                                RoundedRectangle(cornerRadius: isIPad ? 24 : 20)
                                    .stroke(themeManager.selectedTheme.primaryColor.opacity(0.4), lineWidth: 1)
                            )
                    )
                    .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 4)
                    .scaleEffect(showCelebration ? 1.0 : 0.92)
                    .opacity(showCelebration ? 1.0 : 0.0)
                    .onAppear {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                            showCelebration = true
                        }
                    }
                }

                HStack(spacing: isIPad ? 30 : 20) {
                    Button(action: {
                        incrementCounter()
                        triggerVibration()
                    }) {
                        Text("add_string", bundle: localizationManager.bundle)
                            .font(.system(size: buttonFontSize, weight: .medium))
                            .padding(buttonPadding)
                            .lineSpacing(15)
                            .multilineTextAlignment(.center)
                            .frame(width: buttonWidth, height: buttonHeight)
                            .background(
                                ZStack {
                                    themeManager.selectedTheme.primaryColor.opacity(0.1)

                                    RoundedRectangle(cornerRadius: isIPad ? 24 : 20)
                                        .foregroundColor(.white)
                                        .blur(radius: 4)
                                        .offset(x: -8, y: -8)

                                    RoundedRectangle(cornerRadius: isIPad ? 24 : 20)
                                        .fill(LinearGradient(gradient: Gradient(colors: [themeManager.selectedTheme.gradientTopColor, themeManager.selectedTheme.gradientBottomColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .padding(2)
                                }
                            )
                            .clipShape(RoundedRectangle(cornerRadius: isIPad ? 24 : 20))
                            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 20, y: 20)
                    }

                    Button(action: {
                        decrementCounter()
                        triggerVibration()
                    }) {
                        Text("reset_string", bundle: localizationManager.bundle)
                            .font(.system(size: buttonFontSize, weight: .medium))
                            .padding(buttonPadding)
                            .multilineTextAlignment(.center)
                            .frame(width: buttonWidth, height: buttonHeight)
                            .background(
                                ZStack {
                                    themeManager.selectedTheme.primaryColor.opacity(0.1)

                                    RoundedRectangle(cornerRadius: isIPad ? 24 : 20)
                                        .foregroundColor(.white)
                                        .blur(radius: 4)
                                        .offset(x: -8, y: -8)

                                    RoundedRectangle(cornerRadius: isIPad ? 24 : 20)
                                        .fill(LinearGradient(gradient: Gradient(colors: [themeManager.selectedTheme.gradientTopColor, themeManager.selectedTheme.gradientBottomColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .padding(2)
                                }
                            )
                            .clipShape(RoundedRectangle(cornerRadius: isIPad ? 24 : 20))
                            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 20, y: 20)
                    }
                }
            }
            .padding(.vertical)
            LanguageView()
                .hidden()
        }
    }

    func incrementCounter() {
        if counter < 7 {
            counter += 1
        }
    }

    func decrementCounter() {
        if counter > 0 {
            counter = 0
        }
    }

    func triggerVibration() {
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        impactFeedbackGenerator.impactOccurred()
    }
}
