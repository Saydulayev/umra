//
//  Step 1.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI


struct Step1: View {
    
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var fontManager: FontManager


    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))

                .edgesIgnoringSafeArea(.bottom)
            ScrollView {
                VStack {
                    Text("into the state of Ihram", bundle: settings.bundle)
                    
                        .font(.custom("Lato-Black", size: 26))
                    Group {
                        
                        Text("When entering the state of Ihram, say:", bundle: settings.bundle)
                        
                        
                        Text("""
   لَبَّيْكَ اللَّهُمَّ بِعُمْرَةَ
   """)
                        .customTextforArabic()
                        
                        PlayerView(fileName: "1")
                        
                        Text("Turn your face towards the Qiblah and say:", bundle: settings.bundle)
                        
                        
                        Text("""
اَللُّهُمَّ هَذِهِ عُمْرَةً لاٰ رِيَاءَ فِيهَا وَلَا سُمْعَةَ
""")
                        
                        .customTextforArabic()
                        
                        PlayerView(fileName: "2")
                        
                        Text("O Allah, this Umrah is without any ostentation or fame", bundle: settings.bundle)
                        
                    }
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.selectedFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.selectedFontSize))

                    
                    
                    Group {
                        Text("""
                        لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لاَ شَرِيكَ لَكَ لَبَّيْكَ،
                        إِنَّ الْحَمْدَ، وَالنِّعْمَةَ، لَكَ وَالْمُلْكَ، لاَ شَرِيكَ لَكَ
                        """)
                        .customTextforArabic()
                        
                        PlayerView(fileName: "3")
                        
                        Text("Labbayka Allahumma labbayk", bundle: settings.bundle)
                        
                        
                        Text("Entering the Sacred Mosque from the right foot", bundle: settings.bundle)
                        Group {
                            Text("""
    اَللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَ سَلِّمْ،اَللَّهُمَّ افْتَحْ لِي اَبْوَابَ رَحْمَتِكَ
    """)
                            .customTextforArabic()
                            
                            PlayerView(fileName: "4")
                            
                            
                            
                            
                            Text("entering the Sacred Mosque", bundle: settings.bundle)
                            Text("Conditioning for Hajj or Umrah.", bundle: settings.bundle)
                                .font(.custom("Lato-Black", size: 26))
                            
                            Text("If a pilgrim fears that some reason may prevent them from completing the Hajj", bundle: settings.bundle)
                            Text("""
                         اَللَّهُمَّ مَحِلِّي حَيْثُ حَبَسْتَنِي
                         """)
                            .customTextforArabic()
                            
                            PlayerView(fileName: "5")
                        }
                        
                        Text("Ihram text1", bundle: settings.bundle)
                        
                    }
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.selectedFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.selectedFontSize))                }
                .padding(.horizontal, 10)
                //                .environmentObject(settings)
                LanguageView()
                    .hidden()
            }
            
            
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    CustomToolbar(
                        selectedFont: $fontManager.selectedFont,
                        fonts: fontManager.fonts
                    )
                    .environmentObject(settings) // Предоставляем доступ к настройкам через объект окружения
                }
            }
        }
    }
}


