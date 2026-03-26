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
        let imagePadding: CGFloat = AppConstants.isIPad ? 16 : 12
        let outerPadding: CGFloat = AppConstants.isIPad ? 16 : 12
        let indexPadding: CGFloat = AppConstants.isIPad ? 10 : 8
        let indexOffsetX: CGFloat = AppConstants.isIPad ? -25 : -20
        let indexOffsetY: CGFloat = AppConstants.isIPad ? 20 : 15
        let cornerRadius: CGFloat = AppConstants.isIPad ? 24 : 20
        
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
                .font(.caption.bold())
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


// MARK: - PressableRowButtonStyle

struct PressableRowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.75 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

extension View {
    func pressableRowStyle() -> some View {
        buttonStyle(PressableRowButtonStyle())
    }
}

// MARK: - GuideStepItem

struct GuideStepItem: Identifiable {
    let id: Int
    let badgeText: String
    let titleKey: String
    var showStepNumber: Bool = true
    var showDate: Bool = false
    var symbolName: String? = nil
}

// MARK: - GuideStepRow

struct GuideStepRow: View {
    let item: GuideStepItem
    let index: Int

    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    private var badgeSize: CGFloat { AppConstants.isIPad ? 72 : 56 }
    private var badgeColor: Color { themeManager.selectedTheme.primaryColor }

    private var badgeFontSize: CGFloat {
        let longestLine = item.badgeText.components(separatedBy: "\n").map(\.count).max() ?? 0
        let base: CGFloat = AppConstants.isIPad ? 14 : 10
        if longestLine > 6 { return base * 0.80 }
        if longestLine > 4 { return base * 0.90 }
        return base
    }

    var body: some View {
        HStack(spacing: AppConstants.isIPad ? 20 : 16) {
            ZStack {
                Circle()
                    .fill(badgeColor)
                    .shadow(color: badgeColor.opacity(0.20), radius: 4, x: 0, y: 2)
                if let symbol = item.symbolName {
                    Image(systemName: symbol)
                        .font(.system(size: AppConstants.isIPad ? 28 : 22, weight: .medium))
                        .foregroundStyle(.black)
                        .symbolRenderingMode(.hierarchical)
                } else {
                    Text(item.badgeText)
                        .font(.system(size: badgeFontSize, weight: .bold))
                        .tracking(-0.5)
                        .foregroundStyle(.black)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 4)
                }
            }
            .frame(width: badgeSize, height: badgeSize)

            VStack(alignment: .leading, spacing: 4) {
                if item.showStepNumber {
                    Text("\(localizationManager.localized("step_prefix")) \(index + 1)")
                        .font(.caption)
                        .tracking(0.5)
                        .foregroundStyle(themeManager.selectedTheme.textColor.opacity(0.4))
                        .textCase(.uppercase)
                }
                let parsed = localizationManager.parseTitleComponents(from: item.titleKey)
                Text(parsed.name)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(themeManager.selectedTheme.textColor)
                    .fixedSize(horizontal: false, vertical: true)
                if item.showDate, let date = parsed.date {
                    Text(date)
                        .font(.footnote)
                        .foregroundStyle(themeManager.selectedTheme.textColor.opacity(0.45))
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(themeManager.selectedTheme.textColor.opacity(0.25))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .padding(.horizontal, AppConstants.isIPad ? 24 : 20)
        .padding(.vertical, AppConstants.isIPad ? 16 : 14)
    }
}

// MARK: - ReviewTimerModifier

struct ReviewTimerModifier: ViewModifier {
    @Environment(UserPreferences.self) private var userPreferences
    @Environment(\.requestReview) private var requestReview
    @State private var usageTime: TimeInterval = 0
    @State private var usageTimerTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        content
            .onAppear(perform: startTimer)
            .onDisappear(perform: stopTimer)
    }

    private func startTimer() {
        guard !userPreferences.hasRatedApp else { return }
        usageTimerTask = Task { @MainActor in
            while !Task.isCancelled {
                usageTime += 1
                if usageTime >= AppConstants.reviewRequestTimeInterval {
                    stopTimer()
                    requestReviewIfNeeded()
                    break
                }
                do {
                    try await Task.sleep(for: .seconds(1))
                } catch {
                    break
                }
            }
        }
    }

    private func stopTimer() {
        usageTimerTask?.cancel()
        usageTimerTask = nil
    }

    private func requestReviewIfNeeded() {
        guard !userPreferences.hasRatedApp else { return }
        requestReview()
        userPreferences.hasRatedApp = true
    }
}

extension View {
    func reviewTimer() -> some View {
        modifier(ReviewTimerModifier())
    }
}

// MARK: - GuideNavigationModifier

struct GuideNavigationModifier: ViewModifier {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(PurchaseManager.self) private var purchaseManager
    @Environment(BackgroundTaskManager.self) private var backgroundTaskManager

    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: AppDestination.self) { destination in
                switch destination {
                case .settings:
                    SettingsView()
                        .environment(themeManager)
                        .environment(localizationManager)
                        .environment(purchaseManager)
                case .prayerTimes:
                    PrayerTimeView()
                        .environment(themeManager)
                        .environment(localizationManager)
                        .environment(backgroundTaskManager)
                        .toolbar(.hidden, for: .tabBar)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    NavigationLink(value: AppDestination.prayerTimes) {
                        Image(systemName: "clock")
                            .imageScale(.large)
                            .foregroundStyle(.primary)
                            .accessibilityLabel("Prayer Times")
                    }
                    NavigationLink(value: AppDestination.settings) {
                        Image(systemName: "gearshape")
                            .imageScale(.large)
                            .foregroundStyle(.primary)
                            .accessibilityLabel("Settings")
                    }
                }
            }
    }
}

extension View {
    func guideNavigation() -> some View {
        modifier(GuideNavigationModifier())
    }
}

// MARK: - Обёртка для страниц шагов (Умра / Хадж)

struct StepScrollView<Content: View>: View {
    @Environment(ThemeManager.self) private var themeManager
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    content
                }
                .foregroundStyle(.primary)
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Модификаторы для текста
struct StepTextModifier: ViewModifier {
    @Environment(ThemeManager.self) private var themeManager

    
    private var dynamicFontSize: CGFloat {
        AppConstants.isIPad ? 58 : 38
    }
    
    private var customPadding: CGFloat {
        theme.usesTintedArabicCards ? (AppConstants.isIPad ? 28 : 18) : (AppConstants.isIPad ? 32 : 16)
    }

    private var cardCornerRadius: CGFloat {
        AppConstants.isIPad ? 24 : 20
    }

    private var theme: AppTheme {
        themeManager.selectedTheme
    }
    
    func body(content: Content) -> some View {
        content
            .padding(customPadding)
            .font(.custom("KFGQPC Uthman Taha Naskh", size: dynamicFontSize, relativeTo: .body))
            .lineSpacing(15)
            .multilineTextAlignment(.center)
            .foregroundStyle(theme.textColor)
            .frame(maxWidth: .infinity)
            .standardCardFrame(
                theme: theme,
                cornerRadius: cardCornerRadius,
                borderWidth: 1,
                shadowRadius: theme.usesTintedArabicCards ? (AppConstants.isIPad ? 15 : 11) : 18,
                shadowYOffset: theme.usesTintedArabicCards ? (AppConstants.isIPad ? 8 : 4) : 8
            )
            .padding(theme.usesTintedArabicCards ? .horizontal : .all, theme.usesTintedArabicCards ? (AppConstants.isIPad ? 20 : 12) : 16)
            .padding(.vertical, theme.usesTintedArabicCards ? (AppConstants.isIPad ? 10 : 6) : 0)
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


    private var padding: CGFloat {
        AppConstants.isIPad ? 24 : 16
    }

    private var cornerRadius: CGFloat {
        AppConstants.isIPad ? 24 : 20
    }

    func body(content: Content) -> some View {
        return content
            .font(fontManager.bodyFont)
            .foregroundStyle(themeManager.selectedTheme.textColor)
            .padding(padding)
            .frame(maxWidth: .infinity)
            .standardCardFrame(theme: themeManager.selectedTheme, cornerRadius: cornerRadius)
            .padding(.vertical, AppConstants.isIPad ? 8 : 5)
    }
}

extension View {
    func customTextStyleWithTheme() -> some View {
        self.modifier(CustomTextStyleWithThemeModifier())
    }
}
