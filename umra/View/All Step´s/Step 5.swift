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
            Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))

                .edgesIgnoringSafeArea(.bottom)
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
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.selectedFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.selectedFontSize))
                }
                .foregroundStyle(.black)
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

