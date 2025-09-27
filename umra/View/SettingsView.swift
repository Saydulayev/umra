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
    @State private var showNotificationSettingsSheet = false
    @State private var selectedLanguage = "English"
    @State private var showPicker = false
    @EnvironmentObject var settings: UserSettings
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))
                    .ignoresSafeArea(edges: .bottom)
                VStack(alignment: .leading, spacing: 10) {
                    
                    // Feedback Button
                    Button(action: {
                        if let url = URL(string: "mailto:saydulayev.wien@gmail.com") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "message")
                                .foregroundColor(.blue)
                            Text("text_button_feedback_string", bundle: settings.bundle)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        .customTextStyle()
                    }
                    
                    // Rate the App Button
                    Button(action: {
                        showSafariView.toggle()
                    }) {
                        HStack {
                            Image(systemName: "star")
                                .foregroundColor(.blue)
                            Text("text_button_rate_the_app_string", bundle: settings.bundle)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        .customTextStyle()
                    }
                    
                    // Support View
                    PurchaseView()
                    
                    // Notification Settings Button
                    Button(action: {
                        showNotificationSettingsSheet.toggle()
                    }) {
                        HStack {
                            Image(systemName: "bell")
                                .foregroundColor(.blue)
                            Text("Notification Settings", bundle: settings.bundle)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        .customTextStyle()
                    }
                    
                    // Language Selection
                    LanguageView()
                    
                    
                    
                    Spacer()
                }
                .padding()
                .navigationBarTitle(Text("settings_string", bundle: settings.bundle), displayMode: .inline)
                .sheet(isPresented: $showSafariView) {
                    SafariView(url: URL(string: "https://apps.apple.com/app/id1673683355")!)
                }
                .sheet(isPresented: $showNotificationSettingsSheet) {
                    NotificationSettingsView()
                }
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
