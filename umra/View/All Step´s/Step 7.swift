//
//  Step 7.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step7: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager
    
    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Shaving the head string", bundle: localizationManager.bundle)
                        .font(fontManager.sectionTitleFont)
                    
                    Group {
                        Text("Men shorten or shave their hair.", bundle: localizationManager.bundle)
                        Text("Du'a at the end.", bundle: localizationManager.bundle)
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