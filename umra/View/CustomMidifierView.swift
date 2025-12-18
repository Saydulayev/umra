//
//  CustomMidifierView.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI
import Foundation

// MARK: - Адаптивные модификаторы теней
private struct AdaptiveShadowModifier: ViewModifier {
    @Environment(ThemeManager.self) private var themeManager
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    let intensity: Double

    private var shadowColor: Color {
        // Всегда используем черный цвет с прозрачностью как в темной теме
        // Это обеспечивает одинаковый вид теней независимо от системной темы
        return Color.black.opacity(intensity == 0 ? 0 : min(max(intensity, 0.0), 1.0) * 0.55)
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

// MARK: - Восстановленные оригинальные модификаторы изображений
extension Image {
    func styledImageWithIndex(index: Int, stepsCount: Int) -> some View {
        ZStack(alignment: .topTrailing) {
            self
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    ZStack {
                        Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.white)
                            .blur(radius: 4)
                            .offset(x: -8, y: -8)
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8956587315, green: 0.9328896403, blue: 1, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .padding(2)
                    })
                .clipShape(RoundedRectangle(cornerRadius: 20))
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
    
    func styledImage() -> some View {
        self
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
            .frame(width: 90, height: 90)
            .padding(4)
            .background(
                ZStack {
                    Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8980392157, green: 0.933333333, blue: 1, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(2)
                })
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .adaptiveShadow(radius: 5, x: 5, y: 5, intensity: 0.5)
    }
    
    // Методы для совместимости с StepView с поддержкой тем
    func styledImageWithIndexAndTheme(index: Int, stepsCount: Int, theme: AppTheme, hideLastIndex: Bool = true) -> some View {
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        let imagePadding: CGFloat = isIPad ? 16 : 12
        let outerPadding: CGFloat = isIPad ? 16 : 12
        let indexFontSize: CGFloat = isIPad ? 16 : 12
        let indexPadding: CGFloat = isIPad ? 10 : 8
        let indexOffsetX: CGFloat = isIPad ? -25 : -20
        let indexOffsetY: CGFloat = isIPad ? 20 : 15
        let cornerRadius: CGFloat = isIPad ? 24 : 20
        
        return ZStack(alignment: .topTrailing) {
            self
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                .foregroundColor(.black)
                .padding(imagePadding)
                .frame(maxWidth: .infinity)
                .background(
                    ZStack {
                        theme.primaryColor.opacity(0.2)
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .foregroundColor(.white)
                            .blur(radius: 4)
                            .offset(x: -8, y: -8)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(LinearGradient(gradient: Gradient(colors: [theme.gradientTopColor, theme.gradientBottomColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(2)
                    })
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .adaptiveShadow(radius: 5, x: 10, y: 10, intensity: 0.5)
                .padding(outerPadding)
            
            Text("\(index + 1)")
                .font(.system(size: indexFontSize, weight: .bold))
                .foregroundColor(theme == .dark ? .black : .black)
                .padding(indexPadding)
                .background(.white)
                .clipShape(Circle())
                .offset(x: indexOffsetX, y: indexOffsetY)
                .opacity((hideLastIndex && index == stepsCount - 1) ? 0 : 1)
        }
    }
    
    func styledImageWithThemeColors(theme: AppTheme) -> some View {
        styledImageWithThemeColorsForList(theme: theme, size: 90)
    }
    
    func styledImageWithThemeColorsForList(theme: AppTheme, size: CGFloat) -> some View {
        let imageSize = size * 0.822 // Сохраняем пропорцию 74/90
        
        return ZStack(alignment: .center) {
            // Фон квадрата
            ZStack {
                theme.primaryColor.opacity(0.1)
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.white)
                    .blur(radius: 4)
                    .offset(x: -8, y: -8)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [theme.gradientTopColor, theme.gradientBottomColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(2)
            }
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // Изображение в круге, точно по центру квадрата
            self
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .frame(width: size, height: size)
        .adaptiveShadow(radius: 5, x: 5, y: 5, intensity: 0.5)
    }
}


// MARK: - Модификаторы для текста
struct StepTextModifier: ViewModifier {
    @Environment(ThemeManager.self) private var themeManager
    
    private var dynamicFontSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 58 : 38
    }
    
    private var customPadding: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 32 : 16
    }
    
    func body(content: Content) -> some View {
        let isDarkTheme = themeManager.selectedTheme == .dark
        let backgroundColor = isDarkTheme ? Color(UIColor(red: 0.25, green: 0.25, blue: 0.3, alpha: 1)) : Color.white
        let gradientBottom = isDarkTheme ? themeManager.selectedTheme.gradientBottomColor : Color.white
        
        return content
            .padding(customPadding)
            .font(.custom("Amiri Quran", size: dynamicFontSize))
            .lineSpacing(15)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    themeManager.selectedTheme.textBackgroundColor
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(backgroundColor)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [themeManager.selectedTheme.gradientTopColor, gradientBottom]), startPoint: .topLeading, endPoint: .bottomTrailing))
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

// MARK: - Модификатор для кнопок в настройках с поддержкой тем
struct CustomTextStyleWithThemeModifier: ViewModifier {
    @Environment(ThemeManager.self) private var themeManager
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var fontSize: CGFloat {
        isIPad ? 24 : 18
    }
    
    private var padding: CGFloat {
        isIPad ? 24 : 16
    }
    
    private var cornerRadius: CGFloat {
        isIPad ? 24 : 20
    }
    
    func body(content: Content) -> some View {
        let isDarkTheme = themeManager.selectedTheme == .dark
        let backgroundColor = isDarkTheme ? Color(UIColor(red: 0.25, green: 0.25, blue: 0.3, alpha: 1)) : Color.white
        let gradientBottom = isDarkTheme ? themeManager.selectedTheme.gradientBottomColor : Color.white
        
        return content
            .font(.system(size: fontSize, weight: .medium, design: .default))
            .foregroundColor(themeManager.selectedTheme.textColor)
            .padding(padding)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    themeManager.selectedTheme.primaryColor.opacity(0.2)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundColor(backgroundColor)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(LinearGradient(gradient: Gradient(colors: [themeManager.selectedTheme.gradientTopColor, gradientBottom]), startPoint: .topLeading, endPoint: .bottomLeading))
                        .padding(2)
                })
            .adaptiveShadow(radius: isIPad ? 24 : 20, x: isIPad ? 24 : 20, y: isIPad ? 24 : 20, intensity: 0.5)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .padding(.vertical, isIPad ? 8 : 5)
    }
}

extension View {
    func customTextStyle() -> some View {
        self
            .font(.system(size: 18, weight: .medium, design: .default))
            .foregroundColor(Color.black) // Этот метод используется только в старых местах, оставляем черный
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8980392157, green: 0.933333333, blue: 1, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomLeading))
                        .padding(2)
                })
            .adaptiveShadow(radius: 20, x: 20, y: 20, intensity: 0.5)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.vertical, 5)
    }
    
    // Новый модификатор с поддержкой тем для кнопок в настройках
    func customTextStyleWithTheme() -> some View {
        self.modifier(CustomTextStyleWithThemeModifier())
    }
}
