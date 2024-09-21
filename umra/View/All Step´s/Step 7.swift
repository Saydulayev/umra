//
//  Step 7.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step7: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var fontManager: FontManager

    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))

                .edgesIgnoringSafeArea(.bottom)
            ScrollView {
                VStack {
                    Text("Shaving the head string", bundle: settings.bundle)
                        .font(.custom("Lato-Black", size: 26))
                    Group {
                        
                        Text("Men shorten or shave their hair.", bundle: settings.bundle)
                        Text("Du'a at the end.", bundle: settings.bundle)
                        
                        
                        
                        
                    }
                    .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.selectedFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.selectedFontSize))
                    Text("""

 ⵈ━══════╗◊╔══════━ⵈ
""")
                }
                .foregroundStyle(.black)
                .padding(10)
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
