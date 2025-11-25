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
    @Bindable private var bindableFontManager: FontManager
    
    init() {
        self._bindableFontManager = Bindable(FontManager())
    }
    
    private func syncFontManager() {
        if bindableFontManager.selectedFont != fontManager.selectedFont {
            fontManager.selectedFont = bindableFontManager.selectedFont
        }
    }
    
    var body: some View {
        ZStack {
            themeManager.selectedTheme.lightBackgroundColor
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
                .foregroundStyle(.black)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                LanguageView()
                    .hidden()
                    .navigationTitle(Text("hajj_step4_title", bundle: localizationManager.bundle))
                    .navigationBarTitleDisplayMode(.inline)
            }
            .onAppear {
                syncFontManager()
            }
            .onChange(of: bindableFontManager.selectedFont) { _, newFont in
                fontManager.selectedFont = newFont
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    CustomToolbar(
                        selectedFont: $bindableFontManager.selectedFont,
                        fonts: bindableFontManager.fonts
                    )
                    .environment(themeManager)
                }
            }
        }
    }
}


