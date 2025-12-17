//
//  HajjStep4.swift
//  umra
//
//  Created on 25.01.25.
//

import SwiftUI

struct HajjStep4: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager
    
    /// Извлекает только заголовок без даты из строки локализации
    private func extractTitleOnly(from key: String) -> String {
        let fullText = NSLocalizedString(key, bundle: localizationManager.bundle ?? .main, comment: "")
        // Пробуем разные варианты разделителей: длинное тире, обычное тире, дефис
        let separators = [" — ", " - ", " – ", " —", " — "]
        for separator in separators {
            let components = fullText.components(separatedBy: separator)
            if components.count == 2 {
                let title = components[1].trimmingCharacters(in: .whitespaces)
                if !title.isEmpty {
                    return title
                }
            }
        }
        // Если разделитель не найден, возвращаем всю строку
        return fullText
    }
    
    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea(edges: .bottom)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Секция: Пребывание в Мине
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step4_stay_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: 26))
                            .padding(.top, 8)
                        
                        Text("hajj_step4_stay_text", bundle: localizationManager.bundle)
                            .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.dynamicFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.dynamicFontSize))
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Секция: Бросание камешков
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step4_jamarat_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: 26))
                            .padding(.top, 8)
                        
                        Text("hajj_step4_jamarat_text", bundle: localizationManager.bundle)
                            .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.dynamicFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.dynamicFontSize))
                    }
                }
                .foregroundStyle(themeManager.selectedTheme.textColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                LanguageView()
                    .hidden()
                    .navigationTitle(Text(extractTitleOnly(from: "hajj_step4_title")))
                    .navigationBarTitleDisplayMode(.inline)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    CustomToolbar(
                        selectedFont: Bindable(fontManager).selectedFont,
                        fonts: fontManager.fonts
                    )
                    .environment(themeManager)
                }
            }
            .toolbar(.hidden, for: .tabBar)
        }
    }
}


