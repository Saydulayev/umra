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
                Text("select_language_settings_string", bundle: settings.bundle)
                    .foregroundColor(.blue)
            }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Select a Language"), message: nil, buttons: [
                    .default(Text("Русский")) {
                        changeLanguage(to: "ru")
                    },
                    .default(Text("English")) {
                        changeLanguage(to: "en")
                    },
                    .default(Text("Deutsch")) {
                        changeLanguage(to: "de")
                    },
                    // .default(Text("Français")) {
                    //     changeLanguage(to: "fr")
                    // },
                    .cancel()
                ])
            }
        }
        .onAppear {
            // Load the saved language from UserDefaults
            let savedLang = UserDefaults.standard.string(forKey: "selectedLanguage")
            if let lang = savedLang {
                settings.lang = lang
            }
        }
        .onDisappear {
            // Save the selected language to UserDefaults
            UserDefaults.standard.set(settings.lang, forKey: "selectedLanguage")
        }
    }

    func changeLanguage(to lang: String) {
        settings.lang = lang
        UserDefaults.standard.set(lang, forKey: "selectedLanguage")
    }
}

class UserSettings: ObservableObject {
    @Published var lang: String = "ru"

    var bundle: Bundle? {
        guard let path = Bundle.main.path(forResource: lang, ofType: "lproj"),
              let resultBundle = Bundle(path: path) else {
            return nil
        }
        return resultBundle
    }
}




struct LanguageView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageView()
    }
}
