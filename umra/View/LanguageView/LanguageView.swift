//
//  LanguageView.swift
//  umra
//
//  Created by Akhmed on 06.05.23.
//

import SwiftUI


struct LanguageView: View {
    @EnvironmentObject var settings: UserSettings
    @State private var showingActionSheet = false

    var body: some View {
        VStack {
            Button(action: {
                showingActionSheet = true
            }) {
                HStack {
                    Image(systemName: "globe")
                        .foregroundColor(settings.selectedTheme.primaryColor)
                    Text("select_language_settings_string", bundle: settings.bundle)
                        .foregroundColor(.black)
                    Spacer()
                }
                .customTextStyle()
            }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("select_language_settings_string", bundle: settings.bundle)
                    .foregroundColor(settings.selectedTheme.primaryColor), message: nil, buttons: [
                        .default(Text("Русский")) {
                            settings.lang = "ru"
                        },
                        .default(Text("English")) {
                            settings.lang = "en"
                        },
                        .default(Text("Deutsch")) {
                            settings.lang = "de"
                        },
                        .default(Text("Français")) {
                            settings.lang = "fr"
                        },
                        .default(Text("Türkçe")) {
                            settings.lang = "tr"
                        },
                        .default(Text("Bahasa Indonesia")) {
                            settings.lang = "id"
                        },
                        .cancel()
                    ])
            }
        }
    }
}








