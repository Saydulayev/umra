//
//  Step 2.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step2: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager
    
    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea(edges: .bottom)
            
            ScrollView {
                VStack {
                    Text("Kaaba text1", bundle: localizationManager.bundle)
                        .font(.custom("Lato-Black", size: 26))
                    
                    Group {
                        Text("Kaaba text2", bundle: localizationManager.bundle)
                        
                        Text("الله أكبر‎")
                            .customTextforArabic()
                        
                        PlayerView(fileName: "6")
                        
                        Text("Kaaba text3", bundle: localizationManager.bundle)
                        
                        Text("""
        رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ
        """)
                        .customTextforArabic()
                        
                        PlayerView(fileName: "7")
                        
                        Text("Kaaba text4", bundle: localizationManager.bundle)
                    }
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.dynamicFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.dynamicFontSize))
                }
                .foregroundStyle(themeManager.selectedTheme.textColor)
                .padding(.horizontal, 10)
                LanguageView()
                    .hidden()
                    .navigationTitle(Text("title_round_kaaba_screen", bundle: localizationManager.bundle))
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