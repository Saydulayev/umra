//
//  Step 6.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step6: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager
    
    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea(edges: .bottom)
            
            ScrollView {
                VStack {
                    Text("Safa and Marwa", bundle: localizationManager.bundle)
                        .font(.custom("Lato-Black", size: 26))
                    
                    Group {
                        Text("Head towards the hill of Safa", bundle: localizationManager.bundle)
                        Text("""
                        إِنَّ الصَّفَا وَالْمَرْوَةَ مِنْ شَعَائِرِ اللهِ ۖ فَمَنْ حَجَّ الْبَيْتَ أَوِ اعْتَمَرَ فَلَا جُنَاحَ عَلَيْهِ أَنْ يَطَّوَّفَ بِهِمَا ۚ وَمَنْ تَطَوَّعَ خَيْرًا فَإِنَّ اللهَ شَاكِرٌ عَلِيمٌ
                        """)
                        .customTextforArabic()
                        
                        PlayerView(fileName: "8")
                        
                        Text("Surah Al-Baqarah, verse 158.", bundle: localizationManager.bundle)
                        
                        Text("""
نَبْدَأُ بِمَا بَدَأَ اللهُ بِهِ
""")
                        .customTextforArabic()
                        
                        PlayerView(fileName: "9")
                        
                        Text("We begin with that string", bundle: localizationManager.bundle)
                    }
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.dynamicFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.dynamicFontSize))
                    
                    Group {
                        Text("""
                        اَلله أَكْبَرُ الله أَكْبَرُ الله اَكْبَرُ، لٰا إِلَهَ إِلَّا اللهُ وَحْدَهُ لٰا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَ لَهُ الْحَمْدُ، يُحْيِي وَ يُمِيتُ ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، لَا إِلٰهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، أَنْجَزَ وَعْدَهُ، وَنَصَرَ عَبْدَهُ، وَهَزَمَ الْأَحْزَابَ وَحْدَهُ.
                        """)
                        .customTextforArabic()
                        CounterTapView()
                            
                        PlayerView(fileName: "10")
                        
                        Text("Remembrance of Allah during the Sa'i of Safa and Marwa.", bundle: localizationManager.bundle)
                        
                        Text("""
                        رَبِّ اغْفِرْ وَ ارْحَمْ، إِنَّكَ أَنْتَ الْأَعَزُّ الْاَكْرَمُ.
                        """)
                        .customTextforArabic()
                        
                        PlayerView(fileName: "11")
                        
                        Text("Du'a during the Sa'i ritual of Safa and Marwa.", bundle: localizationManager.bundle)
                        
                        Text("""
                        اَللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَ سَلِّمْ ، اَللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ.
                        """)
                        .customTextforArabic()
                        
                        PlayerView(fileName: "12")
                        
                        Text("Du'a upon exiting the Sacred Mosque.", bundle: localizationManager.bundle)
                    }
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.dynamicFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.dynamicFontSize))
                }
                .foregroundStyle(themeManager.selectedTheme.textColor)
                .padding(.horizontal, 10)
                LanguageView()
                    .hidden()
                    .navigationTitle(Text("title_safa_and_marva_screen", bundle: localizationManager.bundle))
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