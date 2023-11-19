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
    @StateObject var colorManager = ColorManager()
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .fill(colorManager.backgroundColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                        .customTextforSteps()
                        
                        PlayerView(fileName: "1")
                            .padding()
                        
                        Text("Turn your face towards the Qiblah and say:", bundle: settings.bundle)
                        
                        
                        Text("""
اَللُّهُمَّ هَذِهِ عُمْرَةً لاٰ رِيَاءَ فِيهَا وَلَا سُمْعَةَ
""")
                        
                        .customTextforSteps()
                        
                        PlayerView(fileName: "2")
                            .padding()
                        
                        Text("O Allah, this Umrah is without any ostentation or fame", bundle: settings.bundle)
                        
                    }
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.selectedFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.selectedFontSize))

                    
                    
                    Group {
                        Text("""
                        لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لاَ شَرِيكَ لَكَ لَبَّيْكَ،
                        إِنَّ الْحَمْدَ، وَالنِّعْمَةَ، لَكَ وَالْمُلْكَ، لاَ شَرِيكَ لَكَ
                        """)
                        .customTextforSteps()
                        
                        PlayerView(fileName: "3")
                            .padding()
                        
                        Text("Labbayka Allahumma labbayk", bundle: settings.bundle)
                        
                        
                        Text("Entering the Sacred Mosque from the right foot", bundle: settings.bundle)
                        Group {
                            Text("""
    اَللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَ سَلِّمْ،اَللَّهُمَّ افْتَحْ لِي اَبْوَابَ رَحْمَتِكَ
    """)
                            .customTextforSteps()
                            
                            PlayerView(fileName: "4")
                                .padding()
                            
                            
                            
                            
                            Text("entering the Sacred Mosque", bundle: settings.bundle)
                            Text("Conditioning for Hajj or Umrah.", bundle: settings.bundle)
                                .font(.custom("Lato-Black", size: 26))
                            
                            Text("If a pilgrim fears that some reason may prevent them from completing the Hajj", bundle: settings.bundle)
                            Text("""
                         اَللَّهُمَّ مَحِلِّي حَيْثُ حَبَسْتَنِي
                         """)
                            .customTextforSteps()
                            
                            PlayerView(fileName: "5")
                                .padding()
                        }
                        
                        Text("Ihram text1", bundle: settings.bundle)
                        
                    }
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.selectedFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.selectedFontSize))                }
                .foregroundColor(colorManager.textColor)
                .padding(.horizontal, 10)
                //                .environmentObject(settings)
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


