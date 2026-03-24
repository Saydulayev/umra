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
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    Text("Kaaba text1", bundle: localizationManager.bundle)
                        .font(fontManager.sectionTitleFont)
                    
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
                        
                        TawafCounterView()
                        
                        Text("Kaaba text4", bundle: localizationManager.bundle)
                    }
                    .font(fontManager.bodyFont)
                }
                .foregroundStyle(.primary)
                .padding(.horizontal, 20)
                .navigationTitle(Text("title_round_kaaba_screen", bundle: localizationManager.bundle))
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