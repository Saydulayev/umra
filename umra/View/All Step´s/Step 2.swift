//
//  Step 2.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step2: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var fontManager: FontManager

    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))

                .edgesIgnoringSafeArea(.bottom)
            ScrollView {
                VStack {
                    Text("Kaaba text1", bundle: settings.bundle)
                        .font(.custom("Lato-Black", size: 26))
                    Group {
                        
                        
                        Text("Kaaba text2", bundle: settings.bundle)
                        
                        
                        Text("الله أكبر‎")
                            .customTextforArabic()
                        
                        PlayerView(fileName: "6")
                        
                        Text("Kaaba text3", bundle: settings.bundle)
                        
                        Text("""
        رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ
        """)
                        .customTextforArabic()
                        
                        PlayerView(fileName: "7")
                        
                        Text("Kaaba text4", bundle: settings.bundle)
                        
                        
                        
                        
                    }
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.selectedFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.selectedFontSize))
                }
                .padding(.horizontal, 10)
                LanguageView()
                    .hidden()
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    CustomToolbar(
                        selectedFont: $fontManager.selectedFont,
                        fonts: fontManager.fonts
                    )
                    .environmentObject(settings) 
                }
            }
        }
    }
}

