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
                        .foregroundStyle(themeManager.selectedTheme.primaryColor)
                    Text("select_language_settings_string", bundle: localizationManager.bundle)
                        .foregroundStyle(.primary)
                    Spacer()
                }
                .customTextStyleWithTheme()
            }
            .confirmationDialog(
                Text("select_language_settings_string", bundle: localizationManager.bundle),
                isPresented: $showingActionSheet
            ) {
                Button("العربية") { localizationManager.currentLanguage = "ar" }
                Button("Русский") { localizationManager.currentLanguage = "ru" }
                Button("English") { localizationManager.currentLanguage = "en" }
                Button("Deutsch") { localizationManager.currentLanguage = "de" }
                Button("Français") { localizationManager.currentLanguage = "fr" }
                Button("Türkçe") { localizationManager.currentLanguage = "tr" }
                Button("Bahasa Indonesia") { localizationManager.currentLanguage = "id" }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}








