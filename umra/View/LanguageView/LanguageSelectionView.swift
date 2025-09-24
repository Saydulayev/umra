//
//  LanguageSelectionView.swift
//  umra
//
//  Created by Saydulayev on 03.12.24.
//

import SwiftUI

struct Language: Identifiable {
    let code: String
    let title: String
    var id: String { code }
}

let languages: [Language] = [
    .init(code: "de", title: "Deutsch"),
    .init(code: "en", title: "English"),
    .init(code: "fr", title: "Français"),
    .init(code: "ru", title: "Русский"),
    .init(code: "tr", title: "Türkçe"),
    .init(code: "id", title: "Bahasa Indonesia"),
    // Добавляйте новые языки сюда
]

struct LanguageSelectionView: View {
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Базовый фон
                LinearGradient(
                    colors: [
                        Color.mint.opacity(0.35),
                        Color.black.opacity(0.45)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                // Полноэкранный «лист» материала без рамок и теней
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()

                VStack {
                    // Заголовок на стекле
                    ShimmeringText()
                        .minimumScaleFactor(0.7)
                        .padding(.bottom, geo.size.height * 0.02)
                    Spacer()
                    // Адаптивные параметры карточек
                    let contentWidth = adaptiveContentWidth(geo.size)
                    let cardCornerRadius: CGFloat = contentWidth >= 520 ? 28 : 24
                    let imageAspect: CGFloat = 16.0 / 9.0

                    // Картинка в стеклянной карточке с адаптивной шириной
                    Image("WelcomeImage")
                        .resizable()
                        .scaledToFit()
                        .padding(14)
                        .frame(width: contentWidth)
                        .aspectRatio(imageAspect, contentMode: .fit)
                        .glassContainer(cornerRadius: cardCornerRadius)
                        .padding(.bottom, geo.size.height * 0.02)

                    // Подсчитываем высоту кнопки + отступы
                    let buttonFontSize = geo.size.height * 0.025
                    let buttonVerticalPadding: CGFloat = 16
                    let buttonSpacing = geo.size.height * 0.015
                    let buttonFullHeight = buttonFontSize + buttonVerticalPadding * 2 + buttonSpacing
                    let maxListHeight = geo.size.height * 0.36
                    let maxVisibleButtons = Int(maxListHeight / buttonFullHeight)
                    let needChevron = languages.count > maxVisibleButtons

                    // Стеклянная карточка со списком кнопок — та же ширина, что у картинки
                    VStack(spacing: buttonSpacing) {
                        ScrollView {
                            VStack(spacing: buttonSpacing) {
                                ForEach(languages) { lang in
                                    Button(action: { selectLanguage(lang.code) }) {
                                        Text(lang.title)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(
                                        GlassButtonStyle(
                                            fontSize: buttonFontSize,
                                            verticalPadding: buttonVerticalPadding,
                                            cornerRadius: 20,
                                            material: .ultraThinMaterial
                                        )
                                    )
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 8)
                        }
                        .scrollIndicators(.hidden)
                        .frame(maxHeight: maxListHeight)
                    }
                    .padding(12)
                    .frame(width: contentWidth)
                    .glassContainer(cornerRadius: cardCornerRadius)

                    if needChevron {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.system(size: geo.size.height * 0.025, weight: .semibold, design: .rounded))
                            .padding(.top, 4)
                            .padding(.bottom, geo.size.height * 0.01)
                            .transition(.opacity)
                            .animation(.easeInOut, value: needChevron)
                    }
                }
                .padding(.horizontal, geo.size.width > 500 ? 64 : 16)
                .padding(.top, geo.size.height > 800 ? 48 : 16)
                .padding(.bottom, geo.size.height > 800 ? 32 : 12)
            }
        }
    }

    private func selectLanguage(_ lang: String) {
        settings.lang = lang
        settings.hasSelectedLanguage = true
    }

    // MARK: - Adaptive width helper
    private func adaptiveContentWidth(_ size: CGSize) -> CGFloat {
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let isLandscape = size.width > size.height

        // Доля ширины экрана для карточек
        let fraction: CGFloat = {
            if isPad {
                return isLandscape ? 0.5 : 0.6
            } else {
                return isLandscape ? 0.6 : 0.78
            }
        }()

        // Границы, чтобы ширина оставалась «человечной»
        let minW: CGFloat = isPad ? 420 : 300
        let maxW: CGFloat = isPad ? 640 : 460

        let proposed = size.width * fraction
        return min(max(proposed, minW), maxW)
    }
}

// Стеклянная кнопка под glassmorphism
struct GlassButtonStyle: ButtonStyle {
    var fontSize: CGFloat = 18
    var verticalPadding: CGFloat = 16
    var cornerRadius: CGFloat = 20
    var material: Material = .ultraThinMaterial

    func makeBody(configuration: Configuration) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        return configuration.label
            .font(.system(size: fontSize, weight: .semibold, design: .rounded))
            .foregroundStyle(.black.opacity(0.92))
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, 8)
            .background(
                shape
                    .fill(material)
                    .overlay(
                        shape.fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.05),
                                    Color.cyan.opacity(0.08)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    )
            )
            .overlay(
                shape
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.70),
                                Color.white.opacity(0.15)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.18), radius: 14, x: 0, y: 10)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: configuration.isPressed)
    }
}

#Preview {
    LanguageSelectionView()
        .environmentObject(UserSettings())
}
