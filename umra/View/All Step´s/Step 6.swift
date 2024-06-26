//
//  Step 6.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step6: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var fontManager: FontManager
    @EnvironmentObject var colorManager: ColorManager

    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .fill(colorManager.backgroundColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.bottom)
            ScrollView {
                VStack {
                    Text("Safa and Marwa", bundle: settings.bundle)
                        .font(.custom("Lato-Black", size: 26))
                    Group {
                        
                        Text("Head towards the hill of Safa", bundle: settings.bundle)
                        Text("""
                        إِنَّ الصَّفَا وَالْمَرْوَةَ مِنْ شَعَائِرِ اللهِ ۖ فَمَنْ حَجَّ الْبَيْتَ أَوِ اعْتَمَرَ فَلَا جُنَاحَ عَلَيْهِ أَنْ يَطَّوَّفَ بِهِمَا ۚ وَمَنْ تَطَوَّعَ خَيْرًا فَإِنَّ اللهَ شَاكِرٌ عَلِيمٌ
                        """)
                        .customTextforArabic()
                        
                        PlayerView(fileName: "8")
                            .padding()
                        
                        Text("Surah Al-Baqarah, verse 158.", bundle: settings.bundle)
                        
                        Text("""
نَبْدَأُ بِمَا بَدَأَ اللهُ بِهِ
""")
                        .customTextforArabic()
                        
                        PlayerView(fileName: "9")
                            .padding()
                        
                        Text("We begin with that string", bundle: settings.bundle)
                    }
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.selectedFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.selectedFontSize))
                    Group {
                        Text("""
                        اَلله أَكْبَرُ الله أَكْبَرُ الله اَكْبَرُ، لٰا إِلَهَ إِلَّا اللهُ وَحْدَهُ لٰا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَ لَهُ الْحَمْدُ، يُحْيِي وَ يُمِيتُ ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، لَا إِلٰهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، أَنْجَزَ وَعْدَهُ، وَنَصَرَ عَبْدَهُ، وَهَزَمَ الْأَحْزَابَ وَحْدَهُ.
                        """)
                        .customTextforArabic()
                        CounterTapView()
                        
                        PlayerView(fileName: "10")
                            .padding()
                        
                        Text("Remembrance of Allah during the Sa'i of Safa and Marwa.", bundle: settings.bundle)
                        
                        Text("""
                        رَبِّ اغْفِرْ وَ ارْحَمْ، إِنَّكَ أَنْتَ الْأَعَزُّ الْاَكْرَمُ.
                        """)
                        .customTextforArabic()
                        
                        PlayerView(fileName: "11")
                            .padding()
                        
                        Text("Du'a during the Sa'i ritual of Safa and Marwa.", bundle: settings.bundle)
                        
                        Text("""
                        اَللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَ سَلِّمْ ، اَللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ.
                        """)
                        .customTextforArabic()
                        
                        PlayerView(fileName: "12")
                            .padding()
                        
                        Text("Du'a upon exiting the Sacred Mosque.", bundle: settings.bundle)
                        
                    }
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.selectedFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.selectedFontSize))
                }
                .foregroundColor(colorManager.textColor)
                .padding(.horizontal, 10)
                LanguageView()
                    .hidden()
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    CustomToolbar(
                        selectedFont: $fontManager.selectedFont,
                        backgroundColor: $colorManager.backgroundColor,
                        textColor: $colorManager.textColor,
                        fonts: fontManager.fonts
                    )
                    .environmentObject(settings) // Предоставляем доступ к настройкам через объект окружения
                }
            }
        }
    }
}

