//
//  Step 1.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step1: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager
    @Bindable private var bindableFontManager: FontManager
    
    init() {
        // Создаем bindable wrapper для глобального FontManager
        self._bindableFontManager = Bindable(FontManager())
    }
    
    // Синхронизируем изменения между bindableFontManager и глобальным fontManager
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
                VStack {
                    Text("into the state of Ihram", bundle: localizationManager.bundle)
                        .font(.custom("Lato-Black", size: 26))
                    
                    Group {
                        Text("When entering the state of Ihram, say:", bundle: localizationManager.bundle)
                        
                        Text("""
   لَبَّيْكَ اللَّهُمَّ بِعُمْرَةَ
   """)
                        .customTextforArabic()
                        
                        PlayerView(fileName: "1")
                        
                        Text("Turn your face towards the Qiblah and say:", bundle: localizationManager.bundle)
                        
                        Text("""
اَللُّهُمَّ هَذِهِ عُمْرَةً لاٰ رِيَاءَ فِيهَا وَلَا سُمْعَةَ
""")
                        .customTextforArabic()
                        
                        PlayerView(fileName: "2")
                        
                        Text("Turn your face towards the Qiblah and say:", bundle: localizationManager.bundle)
                        
                        Text("""
اَللُّهُمَّ هَذِهِ عُمْرَةً لاٰ رِيَاءَ فِيهَا وَلَا سُمْعَةَ
""")
                        .customTextforArabic()
                        
                        PlayerView(fileName: "3")
                        
                        Text("Turn your face towards the Qiblah and say:", bundle: localizationManager.bundle)
                        
                        Text("""
اَللُّهُمَّ هَذِهِ عُمْرَةً لاٰ رِيَاءَ فِيهَا وَلَا سُمْعَةَ
""")
                        .customTextforArabic()
                        
                        PlayerView(fileName: "4")
                        
                        Text("Turn your face towards the Qiblah and say:", bundle: localizationManager.bundle)
                        
                        Text("""
اَللُّهُمَّ هَذِهِ عُمْرَةً لاٰ رِيَاءَ فِيهَا وَلَا سُمْعَةَ
""")
                        .customTextforArabic()
                        
                        PlayerView(fileName: "5")
                    }
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.dynamicFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.dynamicFontSize))
                }
                .foregroundStyle(.black)
                .padding(.horizontal, 10)
                LanguageView()
                    .hidden()
                    .navigationTitle(Text("title_ihram_screen", bundle: localizationManager.bundle))
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