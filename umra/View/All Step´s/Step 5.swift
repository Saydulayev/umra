//
//  Step 5.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step5: View {
    
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
                    Text("Return to the Black Stone.", bundle: localizationManager.bundle)
                        .font(.custom("Lato-Black", size: 26))
                    Group {
                        
                        Text("Return to the Black Stone, recite the Takbir.", bundle: localizationManager.bundle)
                        Spacer()
                        
                        Text("Allah is great.", bundle: localizationManager.bundle)
                        Text("الله أكبر‎")
                            .customTextforArabic()
                        
                        PlayerView(fileName: "6")
                        
                    }
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.dynamicFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.dynamicFontSize))
                }
                .foregroundStyle(.black)
                .padding(.horizontal, 10)
                LanguageView()
                    .hidden()
                    .navigationTitle(Text("title_black_stone_screen", bundle: localizationManager.bundle))
                    .navigationBarTitleDisplayMode(.inline)
            }
            .scrollBounceBehavior(.basedOnSize)
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

