//
//  Step 3.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step3: View {
    
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
                    Text("Prayer after Tawaf of Kaaba.", bundle: localizationManager.bundle)
                        .font(.custom("Lato-Black", size: 26))
                    Group {
                        
                        Text("Having completed seven circuits around the Kaaba", bundle: localizationManager.bundle)
                        
                        Text("""
                        وَاتَّخِذُوا مِن مَّقَامِ إِبْرَاهِيمَ مُصَلًّ
                        """)
                        .customTextforArabic()
                        
                        PlayerView(fileName: "13")
                        
                    }
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.dynamicFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.dynamicFontSize))
                    
                    Group {
                        Text("Place of standing of Ibrahim", bundle: localizationManager.bundle)
                        
                    }
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.dynamicFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.dynamicFontSize))
                }
                .foregroundStyle(.black)
                .padding(.horizontal, 10)
                LanguageView()
                    .hidden()
                    .navigationTitle(Text("title_place_ibrohim_stand_screen", bundle: localizationManager.bundle))
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
