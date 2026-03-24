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

    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Секция: Пребывание в Мине
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step4_stay_title", bundle: localizationManager.bundle)
                            .font(fontManager.sectionTitleFont)
                            .padding(.top, 8)
                        
                        Text("hajj_step4_stay_text", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Секция: Бросание камешков
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step4_jamarat_title", bundle: localizationManager.bundle)
                            .font(fontManager.sectionTitleFont)
                            .padding(.top, 8)
                        
                        Text("hajj_step4_jamarat_text", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                    }
                }
                .foregroundStyle(.primary)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .navigationTitle(Text(localizationManager.extractTitleOnly(from: "hajj_step4_title")))
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


