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
    @State private var showThemeSelectionSheet = false
    @State private var selectedLanguage = "English"
    @State private var showPicker = false
    @EnvironmentObject var settings: UserSettings
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                settings.selectedTheme.lightBackgroundColor
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
                                .foregroundColor(settings.selectedTheme.primaryColor)
                            Text("text_button_feedback_string", bundle: settings.bundle)
                                .foregroundColor(.black)
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
                                .foregroundColor(settings.selectedTheme.primaryColor)
                            Text("text_button_rate_the_app_string", bundle: settings.bundle)
                                .foregroundColor(.black)
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
                                .foregroundColor(settings.selectedTheme.primaryColor)
                            Text("Notification Settings", bundle: settings.bundle)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .customTextStyle()
                    }
                    
                    // Language Selection
                    LanguageView()
                    
                    // Theme Selection
                    Button(action: {
                        showThemeSelectionSheet.toggle()
                    }) {
                        HStack {
                            Image(systemName: "paintbrush.fill")
                                .foregroundColor(settings.selectedTheme.primaryColor)
                            Text("theme_app_title", bundle: settings.bundle)
                                .foregroundColor(.black)
                            Spacer()
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(settings.selectedTheme.primaryColor)
                                    .frame(width: 20, height: 20)
                                Text(settings.selectedTheme.displayName(bundle: settings.bundle ?? Bundle.main))
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                            }
                        }
                        .customTextStyle()
                    }
                    
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
                .sheet(isPresented: $showThemeSelectionSheet) {
                    ThemePreviewView()
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




// MARK: - Theme Preview View
struct ThemePreviewView: View {
    @EnvironmentObject var settings: UserSettings
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                settings.selectedTheme.lightBackgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("theme_select_title", bundle: settings.bundle)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.top)
                    
                    VStack(spacing: 16) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            Button(action: {
                                settings.selectedTheme = theme
                                dismiss()
                            }) {
                                HStack(spacing: 16) {
                                    // Простой цветной кружок
                                    Circle()
                                        .fill(theme.primaryColor)
                                        .frame(width: 50, height: 50)
                                    
                                    Text(theme.displayName(bundle: settings.bundle ?? Bundle.main))
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    if settings.selectedTheme == theme {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(theme.primaryColor)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .shadow(color: theme.primaryColor.opacity(0.2), radius: 8, x: 0, y: 4)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("done_button", bundle: settings.bundle)
                            .foregroundColor(settings.selectedTheme.primaryColor)
                    }
                }
            }
        }
    }
    
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
