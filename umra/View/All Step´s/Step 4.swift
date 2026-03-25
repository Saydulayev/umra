//
//  Step 4.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step4: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager
    
    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Drinking Zamzam water.", bundle: localizationManager.bundle)
                        .font(fontManager.sectionTitleFont)
                    
                    Group {
                        Text("Zamzam text", bundle: localizationManager.bundle)
                    }
                    .font(fontManager.bodyFont)
                }
                .foregroundStyle(.primary)
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
        }
    }
}