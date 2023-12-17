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
    @EnvironmentObject var colorManager: ColorManager

    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .fill(colorManager.backgroundColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.bottom)
            ScrollView {
                VStack {
                    Text("Prayer after Tawaf of Kaaba.", bundle: settings.bundle)
                        .font(.custom("Lato-Black", size: 26))
                    Group {
                        
                        Text("Having completed seven circuits around the Kaaba", bundle: settings.bundle)
                        
                        Text("""
                        وَاتَّخِذُوا مِن مَّقَامِ إِبْرَاهِيمَ مُصَلًّ
                        """)
                        .customTextforSteps()
                        
                        PlayerView(fileName: "13")
                            .padding()
                        
                    }
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.selectedFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.selectedFontSize))
                    
                    Group {
                        Text("Place of standing of Ibrahim", bundle: settings.bundle)
                        
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
