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
//    @EnvironmentObject var fontManager: FontManager
//    @StateObject var colorManager = ColorManager()





    
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
                            .foregroundColor(.green)
                        
                    }
                    LanguageView()
                }
//                Section(header: Text("Color")) {
//                    Image(systemName: "paintbrush")
//                        .foregroundColor(.orange)
//                    
//                        HStack {
//                            Text("background_color", bundle: settings.bundle)
//                                .foregroundStyle(.blue)
//                            ColorPicker("", selection: $colorManager.backgroundColor)
//                        }
//                        HStack {
//                            Text("text_color", bundle: settings.bundle)
//                                .foregroundStyle(.blue)
//                            ColorPicker("", selection: $colorManager.textColor)
//                        }
//                }
//                
//                Section(header: Text("Text")) {
//                    Image(systemName: "textformat")
//                        .foregroundColor(.green)
//                    HStack {
//                        Text("_font_", bundle: settings.bundle)
//                            .foregroundStyle(.blue)
//                        Picker("", selection: $fontManager.selectedFont) {
//                            ForEach(fontManager.fonts, id: \.self) { font in
//                                Text(font).tag(font)
//                                
//                            }
//                        }
//                    }
//                    HStack {
//                        Text("_size_", bundle: settings.bundle)
//                            .foregroundStyle(.blue)
//                        Picker("", selection: $fontManager.selectedFontSize) {
//                            ForEach([14, 16, 18, 20, 22, 24, 26], id: \.self) { size in
//                                Text("\(size) pt").tag(CGFloat(size))
//                            }
//                        }
//                    }
//                }
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
