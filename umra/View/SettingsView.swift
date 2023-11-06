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
    @StateObject var colorManager = ColorManager()





    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Feedback")) {
                    Image(systemName: "message")
                        .foregroundColor(.purple)
                    Button(action: {
                        if let url = URL(string: "mailto:saydulayev.wien@gmail.com") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Text("text_button_feedback_string", bundle: settings.bundle)
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Section(header: Text("Evaluate the app")) {
                    Image(systemName: "star")
                        .foregroundColor(.yellow)
                    Button(action: {
                        showSafariView.toggle()
                    }) {
                        Text("text_button_rate_the_app_string", bundle: settings.bundle)
                    }
                    .foregroundColor(.blue)
                }

                
                Section(header: Text("Support the developer")) {
                    Image(systemName: "heart")
                        .foregroundColor(.red)
                    
                        DonationButton()
//                        .environmentObject(UserSettings())

                    
                }
                Section(header: Text("LANGUAGE SELECTION")) {
                    VStack {
                        Image(systemName: "globe")
                            .foregroundColor(.blue)
                        
                    }
                    LanguageView()
                }
                
                Section(header: Text("Color")) {
                    Image(systemName: "paintbrush")
                        .foregroundColor(.green)
                    VStack {
                        HStack {
                            Text("background_color", bundle: settings.bundle)
                            ColorPicker("", selection: $colorManager.backgroundColor)
                        }
                        Divider()
                        HStack {
                            Text("text_color", bundle: settings.bundle)
                            ColorPicker("", selection: $colorManager.textColor)
                        }
                        Divider()
                    } .foregroundStyle(.blue)
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
