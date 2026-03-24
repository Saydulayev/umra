//
//  Step 3.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step3: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager
    
    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    Text("Prayer after Tawaf of Kaaba.", bundle: localizationManager.bundle)
                        .font(fontManager.sectionTitleFont)
                    
                    Group {
                        Text("Having completed seven circuits around the Kaaba", bundle: localizationManager.bundle)
                        
                        Text("""
                        وَاتَّخِذُوا مِن مَّقَامِ إِبْرَاهِيمَ مُصَلًّ
                        """)
                        .customTextforArabic()
                        
                        PlayerView(fileName: "13")
                    }
                    .font(fontManager.bodyFont)
                    
                    Group {
                        Text("Place of standing of Ibrahim", bundle: localizationManager.bundle)
                    }
                    .font(fontManager.bodyFont)
                }
                .foregroundStyle(.primary)
                .padding(.horizontal, 20)
            }
        }
    }
}