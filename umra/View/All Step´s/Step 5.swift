//
//  Step 5.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step5: View {
    
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var fontManager: FontManager
    
    var body: some View {
        ZStack {
            settings.selectedTheme.lightBackgroundColor
                .ignoresSafeArea(edges: .bottom)
            ScrollView {
                VStack {
                    Text("Return to the Black Stone.", bundle: settings.bundle)
                        .font(.custom("Lato-Black", size: 26))
                    Group {
                        
                        Text("Return to the Black Stone, recite the Takbir.", bundle: settings.bundle)
                        Spacer()
                        
                        Text("Allah is great.", bundle: settings.bundle)
                        Text("الله أكبر‎")
                            .customTextforArabic()
                        
                        PlayerView(fileName: "6")
                        
                    }
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.dynamicFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.dynamicFontSize))
                }
                .foregroundStyle(.black)
                .padding(.horizontal, 10)
                LanguageView()
                    .hidden()
                    .navigationTitle(Text("title_black_stone_screen", bundle: settings.bundle))
                    .navigationBarTitleDisplayMode(.inline)
            }
            .scrollBounceBehavior(.basedOnSize)
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

