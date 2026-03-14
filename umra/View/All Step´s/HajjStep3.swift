//
//  HajjStep3.swift
//  umra
//
//  Created on 25.01.25.
//

import SwiftUI

struct HajjStep3: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager

    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Секция: Фаджр
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step3_fajr_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: fontManager.sectionTitleFontSize))
                            .padding(.top, 8)
                        
                        Text("hajj_step3_fajr_text", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Секция: Аль-Маш'ар-аль-Харам
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step3_mashaar_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: fontManager.sectionTitleFontSize))
                            .padding(.top, 8)
                        
                        Text("hajj_step3_mashaar_text", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Секция: Мина
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step3_mina_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: fontManager.sectionTitleFontSize))
                            .padding(.top, 8)
                        
                        Text("hajj_step3_mina_text", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Секция: Бросание камешков
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step3_jamarat_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: fontManager.sectionTitleFontSize))
                            .padding(.top, 8)
                        
                        Text("hajj_step3_jamarat_text", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Секция: Частичный выход
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step3_partial_exit_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: fontManager.sectionTitleFontSize))
                            .padding(.top, 8)
                        
                        Text("hajj_step3_partial_exit_text", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Секция: Жертвоприношение
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step3_sacrifice_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: fontManager.sectionTitleFontSize))
                            .padding(.top, 8)
                        
                        Text("hajj_step3_sacrifice_text", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Секция: Бритьё
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step3_shaving_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: fontManager.sectionTitleFontSize))
                            .padding(.top, 8)
                        
                        Text("hajj_step3_shaving_text", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Секция: Таваф
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step3_tawaf_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: fontManager.sectionTitleFontSize))
                            .padding(.top, 8)
                        
                        Text("hajj_step3_tawaf_text", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Секция: Внимание для тех, кто не смог совершить обход
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step3_attention_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: fontManager.sectionTitleFontSize))
                            .padding(.top, 8)
                        
                        Text("hajj_step3_attention_text", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Секция: Полный выход
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step3_full_exit_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: fontManager.sectionTitleFontSize))
                            .padding(.top, 8)
                        
                        Text("hajj_step3_full_exit_text", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Секция: Возвращение
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step3_return_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: fontManager.sectionTitleFontSize))
                            .padding(.top, 8)
                        
                        Text("hajj_step3_return_text", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                    }
                }
                .foregroundStyle(.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .navigationTitle(Text(localizationManager.extractTitleOnly(from: "hajj_step3_title")))
                .navigationBarTitleDisplayMode(.inline)
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
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


