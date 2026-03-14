//
//  CustomModifierView.swift
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
        borderColor: Color? = nil,
        fillColor: Color? = nil,
        shadowRadius: CGFloat = 18,
        shadowYOffset: CGFloat = 8
    ) -> some View {
        modifier(
            StandardCardFrameModifier(
                theme: theme,
                cornerRadius: cornerRadius,
                borderWidth: borderWidth,
                borderColor: borderColor,
                fillColor: fillColor,
                shadowRadius: shadowRadius,
                shadowYOffset: shadowYOffset
            )
        )
    }

    func standardCircularCardFrame(
        theme: AppTheme,
        borderWidth: CGFloat = 1,
        borderColor: Color? = nil,
        fillColor: Color? = nil,
        shadowRadius: CGFloat = 16,
        shadowYOffset: CGFloat = 8
    ) -> some View {
        modifier(
            StandardCircularCardFrameModifier(
                theme: theme,
                borderWidth: borderWidth,
                borderColor: borderColor,
                fillColor: fillColor,
                shadowRadius: shadowRadius,
                shadowYOffset: shadowYOffset
            )
        )
    }

    func standardCapsuleCardFrame(
        theme: AppTheme,
        borderWidth: CGFloat = 1,
        borderColor: Color? = nil,
        fillColor: Color? = nil,
        shadowRadius: CGFloat = 8,
        shadowYOffset: CGFloat = 2
    ) -> some View {
        modifier(
            StandardCapsuleCardFrameModifier(
                theme: theme,
                borderWidth: borderWidth,
                borderColor: borderColor,
                fillColor: fillColor,
                shadowRadius: shadowRadius,
                shadowYOffset: shadowYOffset
            )
        )
    }
}

private struct EmeraldRoundedCardBackground: View {
    let theme: AppTheme
    let cornerRadius: CGFloat
    let fillColor: Color

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }

    var body: some View {
        shape
            .fill(fillColor.opacity(theme.isDarkAppearance ? 0.94 : 0.97))
            .overlay {
                shape
                    .fill(
                        LinearGradient(
                            colors: [
                                theme.cardTintColor.opacity(theme.isDarkAppearance ? 0.18 : 0.28),
                                theme.primaryColor.opacity(theme.isDarkAppearance ? 0.07 : 0.03)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay {
                shape
                    .fill(
                        RadialGradient(
                            colors: [
                                theme.primaryColor.opacity(theme.isDarkAppearance ? 0.16 : 0.06),
                                Color.clear
                            ],
                            center: .topTrailing,
                            startRadius: 12,
                            endRadius: 180
                        )
                    )
            }
            .overlay {
                shape
                    .fill(
                        RadialGradient(
                            colors: [
                                theme.secondaryColor.opacity(theme.isDarkAppearance ? 0.10 : 0.04),
                                Color.clear
                            ],
                            center: .bottomLeading,
                            startRadius: 12,
                            endRadius: 150
                        )
                    )
            }
            .overlay {
                shape
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(theme.isDarkAppearance ? 0.05 : 0.10),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .center
                        )
                    )
            }
            .clipShape(shape)
    }
}

private struct EmeraldCircularCardBackground: View {
    let theme: AppTheme
    let fillColor: Color

    var body: some View {
        Circle()
            .fill(fillColor.opacity(theme.isDarkAppearance ? 0.94 : 0.97))
            .overlay {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                theme.cardTintColor.opacity(theme.isDarkAppearance ? 0.18 : 0.26),
                                theme.primaryColor.opacity(theme.isDarkAppearance ? 0.10 : 0.04)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                theme.primaryColor.opacity(theme.isDarkAppearance ? 0.16 : 0.07),
                                Color.clear
                            ],
                            center: .topTrailing,
                            startRadius: 4,
                            endRadius: 64
                        )
                    )
            }
            .overlay {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                theme.secondaryColor.opacity(theme.isDarkAppearance ? 0.10 : 0.04),
                                Color.clear
                            ],
                            center: .bottomLeading,
                            startRadius: 4,
                            endRadius: 58
                        )
                    )
            }
            .clipShape(Circle())
    }
}

private struct EmeraldCapsuleCardBackground: View {
    let theme: AppTheme
    let fillColor: Color

    var body: some View {
        Capsule()
            .fill(fillColor.opacity(theme.isDarkAppearance ? 0.94 : 0.97))
            .overlay {
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                theme.cardTintColor.opacity(theme.isDarkAppearance ? 0.16 : 0.24),
                                theme.primaryColor.opacity(theme.isDarkAppearance ? 0.08 : 0.03)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay {
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(theme.isDarkAppearance ? 0.05 : 0.10),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottom
                        )
                    )
            }
            .clipShape(Capsule())
    }
}

private struct StandardCardFrameModifier: ViewModifier {
    let theme: AppTheme
    let cornerRadius: CGFloat
    let borderWidth: CGFloat
    let borderColor: Color?
    let fillColor: Color?
    let shadowRadius: CGFloat
    let shadowYOffset: CGFloat

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }

    private var resolvedFillColor: Color {
        fillColor ?? theme.cardColor
    }

    private var resolvedBorderColor: Color {
        if let borderColor {
            return borderColor
        }
        return theme.usesTintedArabicCards
            ? theme.cardBorderColor.opacity(theme.isDarkAppearance ? 0.92 : 0.76)
            : theme.cardBorderColor
    }

    func body(content: Content) -> some View {
        content
            .background(
                Group {
                    if theme.usesTintedArabicCards {
                        EmeraldRoundedCardBackground(
                            theme: theme,
                            cornerRadius: cornerRadius,
                            fillColor: resolvedFillColor
                        )
                    } else {
                        shape.fill(resolvedFillColor)
                    }
                }
            )
            .overlay(alignment: .center) {
                shape
                    .stroke(resolvedBorderColor, lineWidth: borderWidth)
            }
            .clipShape(shape)
            .shadow(
                color: theme.cardFrameShadowColor,
                radius: shadowRadius,
                x: 0,
                y: shadowYOffset
            )
    }
}

private struct StandardCircularCardFrameModifier: ViewModifier {
    let theme: AppTheme
    let borderWidth: CGFloat
    let borderColor: Color?
    let fillColor: Color?
    let shadowRadius: CGFloat
    let shadowYOffset: CGFloat

    private var resolvedFillColor: Color {
        fillColor ?? theme.cardColor
    }

    private var resolvedBorderColor: Color {
        if let borderColor {
            return borderColor
        }
        return theme.usesTintedArabicCards
            ? theme.cardBorderColor.opacity(theme.isDarkAppearance ? 0.92 : 0.76)
            : theme.cardBorderColor
    }

    func body(content: Content) -> some View {
        content
            .background(
                Group {
                    if theme.usesTintedArabicCards {
                        EmeraldCircularCardBackground(theme: theme, fillColor: resolvedFillColor)
                    } else {
                        Circle().fill(resolvedFillColor)
                    }
                }
            )
            .overlay(alignment: .center) {
                Circle()
                    .stroke(resolvedBorderColor, lineWidth: borderWidth)
            }
            .clipShape(Circle())
            .shadow(
                color: theme.cardFrameShadowColor,
                radius: shadowRadius,
                x: 0,
                y: shadowYOffset
            )
    }
}

private struct StandardCapsuleCardFrameModifier: ViewModifier {
    let theme: AppTheme
    let borderWidth: CGFloat
    let borderColor: Color?
    let fillColor: Color?
    let shadowRadius: CGFloat
    let shadowYOffset: CGFloat

    private var resolvedFillColor: Color {
        fillColor ?? theme.cardColor
    }

    private var resolvedBorderColor: Color {
        if let borderColor {
            return borderColor
        }
        return theme.usesTintedArabicCards
            ? theme.cardBorderColor.opacity(theme.isDarkAppearance ? 0.92 : 0.76)
            : theme.cardBorderColor
    }

    func body(content: Content) -> some View {
        content
            .background(
                Group {
                    if theme.usesTintedArabicCards {
                        EmeraldCapsuleCardBackground(theme: theme, fillColor: resolvedFillColor)
                    } else {
                        Capsule().fill(resolvedFillColor)
                    }
                }
            )
            .overlay(alignment: .center) {
                Capsule()
                    .stroke(resolvedBorderColor, lineWidth: borderWidth)
            }
            .clipShape(Capsule())
            .shadow(
                color: theme.cardFrameShadowColor,
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
                .foregroundStyle(theme.textColor)
                .padding()
                .frame(maxWidth: .infinity)
                .standardCardFrame(theme: theme, cornerRadius: 20)
                .padding()
            
            Text("\(index + 1)")
                .font(.caption)
                .bold()
                .foregroundStyle(theme.textColor)
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
                .foregroundStyle(theme.textColor)
                .padding(imagePadding)
                .frame(maxWidth: .infinity)
                .standardCardFrame(theme: theme, cornerRadius: cornerRadius)
                .padding(outerPadding)
            
            Text("\(index + 1)")
                .font(.system(size: indexFontSize))
                .bold()
                .foregroundStyle(theme.textColor)
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

    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var dynamicFontSize: CGFloat {
        isIPad ? 58 : 38
    }
    
    private var customPadding: CGFloat {
        theme.usesTintedArabicCards ? (isIPad ? 28 : 18) : (isIPad ? 32 : 16)
    }

    private var cardCornerRadius: CGFloat {
        isIPad ? 24 : 20
    }

    private var theme: AppTheme {
        themeManager.selectedTheme
    }
    
    func body(content: Content) -> some View {
        content
            .padding(customPadding)
            .font(.custom("KFGQPC Uthman Taha Naskh", size: dynamicFontSize))
            .lineSpacing(15)
            .multilineTextAlignment(.center)
            .foregroundStyle(theme.textColor)
            .frame(maxWidth: .infinity)
            .standardCardFrame(
                theme: theme,
                cornerRadius: cardCornerRadius,
                borderWidth: 1,
                shadowRadius: theme.usesTintedArabicCards ? (isIPad ? 15 : 11) : 18,
                shadowYOffset: theme.usesTintedArabicCards ? (isIPad ? 8 : 4) : 8
            )
            .padding(theme.usesTintedArabicCards ? .horizontal : .all, theme.usesTintedArabicCards ? (isIPad ? 20 : 12) : 16)
            .padding(.vertical, theme.usesTintedArabicCards ? (isIPad ? 10 : 6) : 0)
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
    @Environment(FontManager.self) private var fontManager

    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    private var fontSize: CGFloat {
        fontManager.dynamicFontSize
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
            .foregroundStyle(themeManager.selectedTheme.textColor)
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
