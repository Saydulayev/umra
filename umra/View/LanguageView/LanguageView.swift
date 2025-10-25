//
//  LanguageView.swift
//  umra
//
//  Created by Akhmed on 06.05.23.
//

import SwiftUI
import Foundation


struct LanguageView: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @State private var showingActionSheet = false

    var body: some View {
        VStack {
            Button(action: {
                showingActionSheet = true
            }) {
                HStack {
                    Image(systemName: "globe")
                        .foregroundColor(themeManager.selectedTheme.primaryColor)
                    Text("select_language_settings_string", bundle: localizationManager.bundle)
                        .foregroundColor(.black)
                    Spacer()
                }
                .customTextStyle()
            }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("select_language_settings_string", bundle: localizationManager.bundle)
                    .foregroundColor(themeManager.selectedTheme.primaryColor), message: nil, buttons: [
                        .default(Text("Русский")) {
                            localizationManager.currentLanguage = "ru"
                        },
                        .default(Text("English")) {
                            localizationManager.currentLanguage = "en"
                        },
                        .default(Text("Deutsch")) {
                            localizationManager.currentLanguage = "de"
                        },
                        .default(Text("Français")) {
                            localizationManager.currentLanguage = "fr"
                        },
                        .default(Text("Türkçe")) {
                            localizationManager.currentLanguage = "tr"
                        },
                        .default(Text("Bahasa Indonesia")) {
                            localizationManager.currentLanguage = "id"
                        },
                        .cancel()
                    ])
            }
        }
    }
}








