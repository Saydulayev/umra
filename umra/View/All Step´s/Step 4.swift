//
//  Step 4.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step4: View {
    
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager
    @Bindable private var bindableFontManager: FontManager
    
    init() {
        // Инициализируем bindableFontManager
        self._bindableFontManager = Bindable(FontManager())
    }
    
    var body: some View {
        ZStack {
            themeManager.selectedTheme.lightBackgroundColor
                .ignoresSafeArea(edges: .bottom)
            ScrollView {
                VStack {
                    Text("Drinking Zamzam water.", bundle: localizationManager.bundle)
                        .font(.custom("Lato-Black", size: 26))
                    Group {
                        
                        Text("Zamzam text", bundle: localizationManager.bundle)
                        
                    }
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.dynamicFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.dynamicFontSize))
                }
                .foregroundStyle(.black)
                .padding(.horizontal, 10)
                LanguageView()
                    .hidden()
                    .navigationTitle(Text("title_water_zamzam_screen", bundle: localizationManager.bundle))
                    .navigationBarTitleDisplayMode(.inline)
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
