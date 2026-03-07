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

    func standardCardFrame(
        theme: AppTheme,
        cornerRadius: CGFloat = 20,
        borderWidth: CGFloat = 1,
        fillColor: Color? = nil,
        shadowRadius: CGFloat = 18,
        shadowYOffset: CGFloat = 8
    ) -> some View {
        modifier(
            StandardCardFrameModifier(
                theme: theme,
                cornerRadius: cornerRadius,
                borderWidth: borderWidth,
                fillColor: fillColor,
                shadowRadius: shadowRadius,
                shadowYOffset: shadowYOffset
            )
        )
    }
}

private struct StandardCardFrameModifier: ViewModifier {
    let theme: AppTheme
    let cornerRadius: CGFloat
    let borderWidth: CGFloat
    let fillColor: Color?
    let shadowRadius: CGFloat
    let shadowYOffset: CGFloat

    func body(content: Content) -> some View {
        content
            .background(fillColor ?? theme.cardColor)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(theme.cardBorderColor, lineWidth: borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(
                color: theme.cardShadowColor.opacity(theme == .dark ? 0.40 : 0.18),
                radius: shadowRadius,
                x: 0,
                y: shadowYOffset
            )
    }
}

// MARK: - Восстановленные оригинальные модификаторы изображений
extension Image {
    func styledImageWithIndex(index: Int, stepsCount: Int, theme: AppTheme = .light) -> some View {
        ZStack(alignment: .topTrailing) {
            self
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                .foregroundColor(theme.textColor)
                .padding()
                .frame(maxWidth: .infinity)
                .standardCardFrame(theme: theme, cornerRadius: 20)
                .padding()
            
            Text("\(index + 1)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(theme.textColor)
                .padding(8)
                .background(theme.cardColor)
                .clipShape(Circle())
                .offset(x: -25, y: 20)
                .opacity(index == stepsCount - 1 ? 0 : 1)
        }
    }
    
    func styledImage(theme: AppTheme = .light) -> some View {
        self
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
            .frame(width: 90, height: 90)
            .padding(4)
            .standardCardFrame(theme: theme, cornerRadius: 20)
    }
    
    // Методы для совместимости с StepView с поддержкой тем оформления
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
                .foregroundColor(theme.textColor)
                .padding(imagePadding)
                .frame(maxWidth: .infinity)
                .standardCardFrame(theme: theme, cornerRadius: cornerRadius)
                .padding(outerPadding)
            
            Text("\(index + 1)")
                .font(.system(size: indexFontSize, weight: .bold))
                .foregroundColor(theme.textColor)
                .padding(indexPadding)
                .background(theme.cardColor)
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
            Color.clear
                .frame(width: size, height: size)
                .standardCardFrame(theme: theme, cornerRadius: 20)
            
            // Изображение в круге, точно по центру квадрата
            self
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .frame(width: size, height: size)
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
                        .foregroundColor(themeManager.selectedTheme.cardColor)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [themeManager.selectedTheme.gradientTopColor, themeManager.selectedTheme.gradientBottomColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
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
        return content
            .font(.system(size: fontSize, weight: .medium, design: .default))
            .foregroundColor(themeManager.selectedTheme.textColor)
            .padding(padding)
            .frame(maxWidth: .infinity)
            .standardCardFrame(theme: themeManager.selectedTheme, cornerRadius: cornerRadius)
            .padding(.vertical, isIPad ? 8 : 5)
    }
}

extension View {
    func customTextStyle() -> some View {
        self.modifier(CustomTextStyleWithThemeModifier())
    }
    
    // Новый модификатор с поддержкой тем для кнопок в настройках
    func customTextStyleWithTheme() -> some View {
        self.modifier(CustomTextStyleWithThemeModifier())
    }
}
