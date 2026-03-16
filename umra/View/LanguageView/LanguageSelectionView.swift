//
//  LanguageSelectionView.swift
//  umra
//
//  Created by Saydulayev on 03.12.24.
//

import SwiftUI

struct LanguageSelectionView: View {
    private static let languages: [Language] = [
        .init(code: "ar", title: "العربية"),
        .init(code: "de", title: "Deutsch"),
        .init(code: "en", title: "English"),
        .init(code: "fr", title: "Français"),
        .init(code: "ru", title: "Русский"),
        .init(code: "tr", title: "Türkçe"),
        .init(code: "id", title: "Bahasa Indonesia"),
    ]

    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var titleVisible = false
    @State private var logoVisible = false
    @State private var listVisible = false

    var body: some View {
        // GeometryReader используется осознанно для адаптивных отступов и размеров от высоты/ширины экрана.
        GeometryReader { geo in
            ZStack {
                themeManager.selectedTheme.backgroundColor
                    .ignoresSafeArea()

                VStack {
                    ShimmeringText(foregroundColor: themeManager.selectedTheme.textColor.opacity(0.6))
                        .padding(.bottom, geo.size.height * 0.02)
                        .opacity(titleVisible ? 1 : 0)
                        .offset(y: titleVisible ? 0 : -16)

                    Spacer(minLength: geo.size.height * 0.03)

                    Image("WelcomeImage")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            maxWidth: min(geo.size.width * 0.7, 400),
                            maxHeight: min(geo.size.height * 0.25, 400)
                        )
                        .padding(16)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .shadow(color: .black.opacity(0.12), radius: 12, y: 4)
                        .padding(.bottom, geo.size.height * 0.05)
                        .accessibilityHidden(true)
                        .opacity(logoVisible ? 1 : 0)
                        .scaleEffect(logoVisible ? 1 : 0.88)

                    Spacer(minLength: geo.size.height * 0.02)

                    let buttonSpacing = geo.size.height * 0.015
                    let maxListHeight = geo.size.height * 0.36
                    let needChevron = needsScrollChevron(geo: geo)

                    ScrollView {
                        VStack(spacing: buttonSpacing) {
                            ForEach(Self.languages) { lang in
                                LanguageButton(
                                    language: lang,
                                    theme: themeManager.selectedTheme
                                ) {
                                    selectLanguage(lang.code)
                                }
                            }
                        }
                        .padding(.bottom)
                    }
                    .scrollIndicators(.hidden)
                    .frame(maxHeight: maxListHeight)
                    .opacity(listVisible ? 1 : 0)
                    .offset(y: listVisible ? 0 : 24)

                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundStyle(themeManager.selectedTheme.textColor.opacity(0.4))
                        .padding(.top, 4)
                        .padding(.bottom, geo.size.height * 0.01)
                        .opacity(needChevron ? 1 : 0)
                        .animation(.smooth, value: needChevron)
                        .accessibilityHidden(!needChevron)
                }
                .padding(.horizontal, geo.size.width > 500 ? 64 : 16)
                .padding(.top, geo.size.height > 800 ? 48 : 16)
                .padding(.bottom, geo.size.height > 800 ? 32 : 12)
            }
        }
        .onAppear {
            guard !reduceMotion else {
                titleVisible = true
                logoVisible = true
                listVisible = true
                return
            }
            let spring = Animation.spring(response: 0.6, dampingFraction: 0.8)
            withAnimation(spring) {
                titleVisible = true
            } completion: {
                withAnimation(spring) {
                    logoVisible = true
                } completion: {
                    withAnimation(spring) {
                        listVisible = true
                    }
                }
            }
        }
    }

    private func selectLanguage(_ lang: String) {
        localizationManager.currentLanguage = lang
        localizationManager.hasSelectedLanguage = true
    }

    // Вычисление вынесено из body чтобы не пересчитывался на каждом рендере
    private func needsScrollChevron(geo: GeometryProxy) -> Bool {
        let spacing = geo.size.height * 0.015
        let rowHeight: CGFloat = 17 + 16 * 2 + spacing
        let listHeight = geo.size.height * 0.36
        return Self.languages.count > Int(listHeight / rowHeight)
    }
}

#Preview {
    LanguageSelectionView()
        .environment(ThemeManager())
        .environment(LocalizationManager())
}
