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

// Список поддерживаемых языков приложения
let languages: [Language] = [
    .init(code: "ar", title: "العربية"),
    .init(code: "de", title: "Deutsch"),
    .init(code: "en", title: "English"),
    .init(code: "fr", title: "Français"),
    .init(code: "ru", title: "Русский"),
    .init(code: "tr", title: "Türkçe"),
    .init(code: "id", title: "Bahasa Indonesia"),
    // Добавляйте новые языки сюда
]

struct LanguageSelectionView: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager

    var body: some View {
        GeometryReader { geo in
            ZStack {
                themeManager.selectedTheme.backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    ShimmeringText()
                        .font(.largeTitle)
                        .minimumScaleFactor(0.7)
                        .padding(.bottom, geo.size.height * 0.02)
                    
                    Spacer(minLength: geo.size.height * 0.03)
                    
                    Image("WelcomeImage")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            maxWidth: min(geo.size.width * 0.7, 400),
                            maxHeight: min(geo.size.height * 0.25, 400)
                        )
                        .padding(.bottom, geo.size.height * 0.05)
                    
                    Spacer(minLength: geo.size.height * 0.02)
                    
                    // Вычисляем размеры для адаптивного отображения списка языков
                    let buttonFontSize = geo.size.height * 0.025
                    let buttonVerticalPadding: CGFloat = 16
                    let buttonSpacing = geo.size.height * 0.015
                    let buttonFullHeight = buttonFontSize + buttonVerticalPadding * 2 + buttonSpacing
                    let maxListHeight = geo.size.height * 0.36
                    let maxVisibleButtons = Int(maxListHeight / buttonFullHeight)
                    // Показываем индикатор прокрутки, если языков больше, чем помещается на экране
                    let needChevron = languages.count > maxVisibleButtons

                    ZStack(alignment: .bottom) {
                        ScrollView {
                            VStack(spacing: buttonSpacing) {
                                ForEach(languages) { lang in
                                    Button(action: { selectLanguage(lang.code) }) {
                                        Text(lang.title)
                                            .welcomeButtonStyle(fontSize: buttonFontSize)
                                    }
                                }
                            }
                            .padding(.bottom)
                        }
                        .scrollIndicators(.hidden)
                        .frame(maxHeight: maxListHeight)
                    }

                    if needChevron {
                        Image(systemName: "chevron.down")
                            .foregroundStyle(themeManager.selectedTheme.textColor.opacity(0.4))
                            .font(.system(size: geo.size.height * 0.025))
                            .padding(.top, 4)
                            .padding(.bottom, geo.size.height * 0.01)
                            .transition(.opacity)
                            .animation(.smooth, value: needChevron)
                    }
                }
                .padding(.horizontal, geo.size.width > 500 ? 64 : 16)
                .padding(.top, geo.size.height > 800 ? 48 : 16)
                .padding(.bottom, geo.size.height > 800 ? 32 : 12)
            }
        }
    }

    private func selectLanguage(_ lang: String) {
        localizationManager.currentLanguage = lang
        localizationManager.hasSelectedLanguage = true
    }
}

extension Text {
    func buttonStyle(fontSize: CGFloat = 18, theme: AppTheme) -> some View {
        self.font(.system(size: fontSize, weight: .medium))
            .minimumScaleFactor(0.75)
            .foregroundStyle(theme.textColor)
            .padding(.vertical, 16)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity)
            .standardCardFrame(theme: theme, cornerRadius: 20, shadowRadius: 12, shadowYOffset: 4)
            .padding(.horizontal)
    }
    
    func welcomeButtonStyle(fontSize: CGFloat = 18) -> some View {
        let theme = AppTheme.light
        return self.font(.system(size: fontSize, weight: .medium))
            .minimumScaleFactor(0.75)
            .foregroundStyle(theme.textColor)
            .padding(.vertical, 16)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity)
            .standardCardFrame(theme: theme, cornerRadius: 20, shadowRadius: 12, shadowYOffset: 4)
            .padding(.horizontal)
    }
}

#Preview {
    LanguageSelectionView()
        .environment(ThemeManager())
        .environment(LocalizationManager())
}


