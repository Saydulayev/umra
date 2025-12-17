//
//  HajjStep2.swift
//  umra
//
//  Created on 25.01.25.
//

import SwiftUI

struct HajjStep2: View {
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
                    // Секция: Арафат
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step2_arafat_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: 26))
                            .padding(.top, 8)
                        
                        Text("hajj_step2_arafat_text", bundle: localizationManager.bundle)
                            .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.dynamicFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.dynamicFontSize))
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Секция: Стояние на Арафате
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step2_standing_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: 26))
                            .padding(.top, 8)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("hajj_step2_standing_text", bundle: localizationManager.bundle)
                                .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.dynamicFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.dynamicFontSize))
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("hajj_step2_dua_arabic", bundle: localizationManager.bundle)
                                    .customTextforArabic()
                                    .padding(.top, 4)
                                    .padding(.bottom, 16)
                                
                                Text("hajj_step2_dua_transliteration", bundle: localizationManager.bundle)
                                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.dynamicFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.dynamicFontSize))
                                    .italic()
                                
                                Text("hajj_step2_dua_translation", bundle: localizationManager.bundle)
                                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.dynamicFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.dynamicFontSize))
                            }
                            .padding(.leading, 12)
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Секция: Муздалифа
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step2_muzdalifah_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: 26))
                            .padding(.top, 8)
                        
                        Text("hajj_step2_muzdalifah_text", bundle: localizationManager.bundle)
                            .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.dynamicFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.dynamicFontSize))
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Секция: Ночёвка
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step2_night_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: 26))
                            .padding(.top, 8)
                        
                        Text("hajj_step2_night_text", bundle: localizationManager.bundle)
                            .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.dynamicFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.dynamicFontSize))
                    }
                }
                .foregroundStyle(themeManager.selectedTheme.textColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                LanguageView()
                    .hidden()
                    .navigationTitle(Text(extractTitleOnly(from: "hajj_step2_title")))
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


