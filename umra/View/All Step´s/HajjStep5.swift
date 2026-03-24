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
                .navigationTitle(Text(localizationManager.extractTitleOnly(from: "hajj_step5_title")))
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


