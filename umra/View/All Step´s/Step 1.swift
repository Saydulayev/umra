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
                        
                        Text("O Allah, this Umrah is without any ostentation or fame", bundle: localizationManager.bundle)
                    }
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.dynamicFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.dynamicFontSize))
                    
                    Group {
                        Text("""
لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لاَ شَرِيكَ لَكَ لَبَّيْكَ،
إِنَّ الْحَمْدَ، وَالنِّعْمَةَ، لَكَ وَالْمُلْكَ، لاَ شَرِيكَ لَكَ
""")
                        .customTextforArabic()
                        
                        PlayerView(fileName: "3")
                        
                        Text("Labbayka Allahumma labbayk", bundle: localizationManager.bundle)
                        
                        Text("Entering the Sacred Mosque from the right foot", bundle: localizationManager.bundle)
                        
                        Group {
                            Text("""
اَللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَ سَلِّمْ،اَللَّهُمَّ افْتَحْ لِي اَبْوَابَ رَحْمَتِكَ
""")
                            .customTextforArabic()
                            
                            PlayerView(fileName: "4")
                            
                            Text("entering the Sacred Mosque", bundle: localizationManager.bundle)
                            
                            Text("Conditioning for Hajj or Umrah.", bundle: localizationManager.bundle)
                                .font(.custom("Lato-Black", size: 26))
                            
                            Text("If a pilgrim fears that some reason may prevent them from completing the Hajj", bundle: localizationManager.bundle)
                            
                            Text("""
اَللَّهُمَّ مَحِلِّي حَيْثُ حَبَسْتَنِي
""")
                            .customTextforArabic()
                            
                            PlayerView(fileName: "5")
                        }
                        
                        Text("Ihram text1", bundle: localizationManager.bundle)
                        
                        Group {
                            Text("Umrah for parents", bundle: localizationManager.bundle)
                                .font(.custom("Lato-Black", size: 26))
                            
                            Text("Umrah for parents explanation", bundle: localizationManager.bundle)
                            
                            Text("Umrah for father arabic", bundle: localizationManager.bundle)
                                .customTextforArabic()
                            
                            Text("Umrah for father", bundle: localizationManager.bundle)
                            
                            Text("Umrah for mother arabic", bundle: localizationManager.bundle)
                                .customTextforArabic()
                            
                            Text("Umrah for mother", bundle: localizationManager.bundle)
                            
                            Text("Umrah for other person arabic", bundle: localizationManager.bundle)
                                .customTextforArabic()
                            
                            Text("Umrah for other person", bundle: localizationManager.bundle)
                        }
                        
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
            .toolbar(.hidden, for: .tabBar)
        }
    }
}
