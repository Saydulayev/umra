//
//  SettingsView.swift
//  umra
//
//  Created by Akhmed on 08.04.23.
//

import SwiftUI
import SafariServices

struct SettingsView: View {
    @State private var showSafariView = false
    @State private var selectedLanguage = "English"
    @State private var showPicker = false
    @EnvironmentObject var settings: UserSettings
    @Environment(\.dismiss) var dismiss
//    @EnvironmentObject var fontManager: FontManager
//    @StateObject var colorManager = ColorManager()





    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("text_button_feedback_string", bundle: settings.bundle)) {
                    Button(action: {
                        if let url = URL(string: "mailto:saydulayev.wien@gmail.com") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "message")
                                .foregroundColor(.purple)
                            Text("text_button_feedback_string", bundle: settings.bundle)
                        }
                    }
                }
                
                Section(header: Text("text_button_rate_the_app_string", bundle: settings.bundle)) {

                    Button(action: {
                        showSafariView.toggle()
                    }) {
                        HStack {
                            Image(systemName: "star")
                                .foregroundColor(.yellow)
                            Text("text_button_rate_the_app_string", bundle: settings.bundle)
                        }
                    }
                    .foregroundColor(.blue)
                }

                
                Section(header: Text("text_button_support_string", bundle: settings.bundle)) {
                    HStack {
                        Image(systemName: "heart")
                            .foregroundColor(.red)
                        PurchaseView()
                    }
                }
                Section(header: Text("select_language_settings_string", bundle: settings.bundle)) {
                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(.green)
                        LanguageView()
                    }
                }
            }
            .navigationBarTitle(Text("settings_string", bundle: settings.bundle), displayMode: .inline)
            .sheet(isPresented: $showSafariView) {
                SafariView(url: URL(string: "https://apps.apple.com/app/id1673683355")!)
            }
                
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariView = SFSafariViewController(url: url)
        return safariView
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}


//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
