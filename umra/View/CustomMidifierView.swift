//
//  CustomMidifierView.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

// MARK: - Адаптивные модификаторы теней
private struct AdaptiveShadowModifier: ViewModifier {
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject var settings: UserSettings
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    let intensity: Double

    private var shadowColor: Color {
        if scheme == .dark {
            return Color.black.opacity(intensity == 0 ? 0 : min(max(intensity, 0.0), 1.0) * 0.55)
        } else {
            return settings.selectedTheme.primaryColor
                .opacity(intensity == 0 ? 0 : min(max(intensity, 0.0), 1.0))
        }
    }

    func body(content: Content) -> some View {
        content
            .compositingGroup()
            .shadow(color: shadowColor, radius: radius, x: x, y: y)
    }
}

// MARK: - Расширения для View
extension View {
    func adaptiveShadow(radius: CGFloat, x: CGFloat, y: CGFloat, intensity: Double = 0.5) -> some View {
        modifier(AdaptiveShadowModifier(radius: radius, x: x, y: y, intensity: intensity))
    }
}

// MARK: - Модификаторы для изображений
extension Image {
    func styledImageWithIndex(index: Int, stepsCount: Int) -> some View {
        ZStack(alignment: .topTrailing) {
            self
                .resizable()
                .scaledToFit()
                .padding(.bottom)
                .clipShape(Circle())
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    ZStack {
                        Color.primary.opacity(0.1)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.white)
                            .blur(radius: 4)
                            .offset(x: -8, y: -8)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.8), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .padding(2)
                    })
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.primary.opacity(0.3), lineWidth: 2)
                )
                .adaptiveShadow(radius: 5, x: 10, y: 10, intensity: 0.5)
                .padding()

            Text("\(index + 1)")
                .font(.caption)
                .fontWeight(.bold)
                .padding(8)
                .background(.white)
                .clipShape(Circle())
                .offset(x: -25, y: 20)
                .opacity(index == stepsCount - 1 ? 0 : 1)
        }
    }
    
    func styledImageWithIndexAndTheme(index: Int, stepsCount: Int, theme: AppTheme) -> some View {
        ZStack(alignment: .topTrailing) {
            self
                .resizable()
                .scaledToFit()
                .padding(.bottom)
                .clipShape(Circle())
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    ZStack {
                        theme.primaryColor.opacity(0.1)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.white)
                            .blur(radius: 4)
                            .offset(x: -8, y: -8)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(gradient: Gradient(colors: [theme.gradientTopColor, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .padding(2)
                    })
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(theme.primaryColor.opacity(0.6), lineWidth: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black.opacity(0.1), lineWidth: 1)
                        )
                )
                .shadow(color: theme.primaryColor.opacity(0.4), radius: 5, x: 10, y: 10)
                .shadow(color: Color.black.opacity(0.15), radius: 3, x: 2, y: 2)
                .padding()

            Text("\(index + 1)")
                .font(.caption)
                .fontWeight(.bold)
                .padding(8)
                .background(.white)
                .clipShape(Circle())
                .offset(x: -25, y: 20)
                .opacity(index == stepsCount - 1 ? 0 : 1)
        }
    }
    
    func styledImageWithTheme() -> some View {
        self
            .resizable()
            .scaledToFit()
            .padding(.bottom, 10)
            .clipShape(Circle())
            .frame(width: 90, height: 90)
            .padding(4)
            .background(
                ZStack {
                    Color.primary.opacity(0.1)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.8), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(2)
                })
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.primary.opacity(0.3), lineWidth: 2)
            )
            .adaptiveShadow(radius: 5, x: 5, y: 5, intensity: 0.7)
            .shadow(color: Color.black.opacity(0.15), radius: 3, x: 2, y: 2)
    }
    
    func styledImageWithThemeColors(theme: AppTheme) -> some View {
        self
            .resizable()
            .scaledToFit()
            .padding(.bottom, 10)
            .clipShape(Circle())
            .frame(width: 90, height: 90)
            .padding(4)
            .background(
                ZStack {
                    theme.primaryColor.opacity(0.1)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [theme.gradientTopColor, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(2)
                })
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(theme.primaryColor.opacity(0.6), lineWidth: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black.opacity(0.1), lineWidth: 1)
                    )
            )
            .shadow(color: theme.primaryColor.opacity(0.4), radius: 5, x: 5, y: 5)
            .shadow(color: Color.black.opacity(0.15), radius: 3, x: 2, y: 2)
    }
    
    func styledImage() -> some View {
        self
            .resizable()
            .scaledToFit()
            .padding(.bottom, 10)
            .clipShape(Circle())
            .frame(width: 90, height: 90)
            .padding(4)
            .background(
                ZStack {
                    Color.primary.opacity(0.1)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.8), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(2)
                })
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .adaptiveShadow(radius: 5, x: 5, y: 5, intensity: 0.5)
    }
}

// MARK: - Модификаторы для текста
struct StepTextModifier: ViewModifier {
    @EnvironmentObject var settings: UserSettings
    
    private var dynamicFontSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 58 : 38
    }
    
    private var customPadding: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 32 : 16
    }
    
    func body(content: Content) -> some View {
        content
            .padding(customPadding)
            .font(.custom("Amiri Quran", size: dynamicFontSize))
            .lineSpacing(15)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    settings.selectedTheme.textBackgroundColor
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [settings.selectedTheme.gradientTopColor, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(2)
                })
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .adaptiveShadow(radius: 20, x: 20, y: 20, intensity: 0.5)
            .padding()
    }
}

extension View {
    func customTextforArabic() -> some View {
        self.modifier(StepTextModifier())
    }
}

extension View {
    func customTextStyle() -> some View {
        self
            .font(.system(size: 18, weight: .medium, design: .default))
            .foregroundColor(.black)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    Color.primary.opacity(0.1)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.8), Color.white]), startPoint: .topLeading, endPoint: .bottomLeading))
                        .padding(2)
                })
            .adaptiveShadow(radius: 20, x: 20, y: 20, intensity: 0.5)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.vertical, 5)
    }
}