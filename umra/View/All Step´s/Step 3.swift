//
//  Step 3.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step3: View {
    
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var fontManager: FontManager
    
    var body: some View {
        ZStack {
            settings.selectedTheme.lightBackgroundColor
                .ignoresSafeArea(edges: .bottom)
            ScrollView {
                VStack {
                    Text("Prayer after Tawaf of Kaaba.", bundle: settings.bundle)
                        .font(.custom("Lato-Black", size: 26))
                    Group {
                        
                        Text("Having completed seven circuits around the Kaaba", bundle: settings.bundle)
                        
                        Text("""
                        وَاتَّخِذُوا مِن مَّقَامِ إِبْرَاهِيمَ مُصَلًّ
                        """)
                        .customTextforArabic()
                        
                        PlayerView(fileName: "13")
                        
                    }
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.dynamicFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.dynamicFontSize))
                    
                    Group {
                        Text("Place of standing of Ibrahim", bundle: settings.bundle)
                        
                    }
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.dynamicFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.dynamicFontSize))
                }
                .foregroundStyle(.black)
                .padding(.horizontal, 10)
                LanguageView()
                    .hidden()
                    .navigationTitle(Text("title_place_ibrohim_stand_screen", bundle: settings.bundle))
                    .navigationBarTitleDisplayMode(.inline)
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
