//
//  HajjStep5.swift
//  umra
//
//  Created on 25.01.25.
//

import SwiftUI

struct HajjStep5: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager

    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Секция: Прощальный обход
                    VStack(alignment: .leading, spacing: 12) {
                        Text("hajj_step5_title", bundle: localizationManager.bundle)
                            .font(fontManager.sectionTitleFont)
                            .padding(.top, 8)
                        
                        Text("hajj_step5_farewell_text", bundle: localizationManager.bundle)
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


