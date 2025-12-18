//
//  CounterTapView.swift
//  umra
//
//  Created by Akhmed on 02.09.23.
//

import SwiftUI

struct CounterTapView: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @AppStorage("add_string") private var counter = 0
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
                    Text("circle_string", bundle: localizationManager.bundle)
                        .font(.largeTitle.bold())
                    Text("\(counter)")
                        .font(.largeTitle.bold())
                }
                
                if counter == 7 {
                    VStack(spacing: 12) {
                        // Иконка галочки в круге
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.green.opacity(0.8), Color.mint]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 70, height: 70)
                                .shadow(color: .green.opacity(0.5), radius: 15, x: 0, y: 5)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 35, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .scaleEffect(showCelebration ? 1.0 : 0.5)
                        .opacity(showCelebration ? 1.0 : 0.0)
                        
                        // Текст с градиентом и свечением
                        Text("Sa´y finished_string", bundle: localizationManager.bundle)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.green,
                                        Color.mint
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: .green.opacity(0.6), radius: 8, x: 0, y: 3)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.white.opacity(0.4),
                                                Color.white.opacity(0.2)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.green.opacity(0.5),
                                                Color.mint.opacity(0.3)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                            .scaleEffect(showCelebration ? 1.0 : 0.8)
                            .opacity(showCelebration ? 1.0 : 0.0)
                    }
                    .onAppear {
                        withAnimation(.spring) {
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
                                    
                                })
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
                                    
                                })
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
