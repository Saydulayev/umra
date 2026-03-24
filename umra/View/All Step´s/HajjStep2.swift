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

    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Секция: Арафат
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step2_arafat_title", bundle: localizationManager.bundle)
                            .font(fontManager.sectionTitleFont)
                            .padding(.top, 8)
                        
                        Text("hajj_step2_arafat_text", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Секция: Стояние на Арафате
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step2_standing_title", bundle: localizationManager.bundle)
                            .font(fontManager.sectionTitleFont)
                            .padding(.top, 8)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("hajj_step2_standing_text", bundle: localizationManager.bundle)
                                .font(fontManager.bodyFont)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("hajj_step2_dua_arabic", bundle: localizationManager.bundle)
                                    .customTextforArabic()
                                    .padding(.top, 4)
                                    .padding(.bottom, 16)
                                
                                PlayerView(fileName: "16")
                                
                                Text("hajj_step2_dua_transliteration", bundle: localizationManager.bundle)
                                    .font(fontManager.bodyFont)
                                    .italic()
                                
                                Text("hajj_step2_dua_translation", bundle: localizationManager.bundle)
                                    .font(fontManager.bodyFont)
                            }
                            .padding(.leading, 12)
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Секция: Муздалифа
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step2_muzdalifah_title", bundle: localizationManager.bundle)
                            .font(fontManager.sectionTitleFont)
                            .padding(.top, 8)
                        
                        Text("hajj_step2_muzdalifah_text", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Секция: Ночёвка
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step2_night_title", bundle: localizationManager.bundle)
                            .font(fontManager.sectionTitleFont)
                            .padding(.top, 8)
                        
                        Text("hajj_step2_night_text", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                    }
                }
                .foregroundStyle(.primary)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
        }
    }
}


