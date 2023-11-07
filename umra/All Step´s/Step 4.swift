//
//  Step 4.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step4: View {
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
                    Text("Drinking Zamzam water.", bundle: settings.bundle)
                        .font(.custom("Lato-Black", size: 26))
                    Group {
                        
                        Text("Zamzam text", bundle: settings.bundle)
                        
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
                        selectedFontSize: $fontManager.selectedFontSize,
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
