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
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.selectedTheme.lightBackgroundColor
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
                                .foregroundColor(themeManager.selectedTheme.primaryColor)
                            Text("text_button_feedback_string", bundle: localizationManager.bundle)
                                .foregroundColor(themeManager.selectedTheme.textColor)
                            Spacer()
                        }
                        .customTextStyleWithTheme()
                    }
                    
                    // Rate the App Button
                    Button(action: {
                        showSafariView.toggle()
                    }) {
                        HStack {
                            Image(systemName: "star")
                                .foregroundColor(themeManager.selectedTheme.primaryColor)
                            Text("text_button_rate_the_app_string", bundle: localizationManager.bundle)
                                .foregroundColor(themeManager.selectedTheme.textColor)
                            Spacer()
                        }
                        .customTextStyleWithTheme()
                    }
                    
                    // Support View
                    PurchaseView()
                    
                    // Notification Settings Button
                    Button(action: {
                        showNotificationSettingsSheet.toggle()
                    }) {
                        HStack {
                            Image(systemName: "bell")
                                .foregroundColor(themeManager.selectedTheme.primaryColor)
                            Text("Notification Settings", bundle: localizationManager.bundle)
                                .foregroundColor(themeManager.selectedTheme.textColor)
                            Spacer()
                        }
                        .customTextStyleWithTheme()
                    }
                    
                    // Language Selection
                    LanguageView()
                    
                    // Theme Selection
                    Button(action: {
                        showThemeSelectionSheet.toggle()
                    }) {
                        HStack {
                            Image(systemName: "paintbrush.fill")
                                .foregroundColor(themeManager.selectedTheme.primaryColor)
                            Text("theme_app_title", bundle: localizationManager.bundle)
                                .foregroundColor(themeManager.selectedTheme.textColor)
                            Spacer()
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(themeManager.selectedTheme.primaryColor)
                                    .frame(width: 20, height: 20)
                                Text(themeManager.selectedTheme.displayName(bundle: localizationManager.bundle ?? Bundle.main))
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                            }
                        }
                        .customTextStyleWithTheme()
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationBarTitle(Text("settings_string", bundle: localizationManager.bundle), displayMode: .inline)
                .sheet(isPresented: $showSafariView) {
                    SafariView(url: URL(string: "https://apps.apple.com/app/id1673683355")!)
                }
                .sheet(isPresented: $showNotificationSettingsSheet) {
                    NotificationSettingsView()
                }
                .sheet(isPresented: $showThemeSelectionSheet) {
                    ThemePreviewView()
                }
                .toolbar(.hidden, for: .tabBar)
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
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.selectedTheme.lightBackgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("theme_select_title", bundle: localizationManager.bundle)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(themeManager.selectedTheme.textColor)
                        .padding(.top)
                    
                    VStack(spacing: 16) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            Button(action: {
                                themeManager.selectedTheme = theme
                                dismiss()
                            }) {
                                HStack(spacing: 16) {
                                    // Мягкий цветной кружок для превью
                                    Circle()
                                        .fill(theme.previewColor)
                                        .frame(width: 50, height: 50)
                                    
                                    Text(theme.displayName(bundle: localizationManager.bundle ?? Bundle.main))
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(themeManager.selectedTheme.textColor)
                                    
                                    Spacer()
                                    
                                    if themeManager.selectedTheme == theme {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(theme.primaryColor)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(themeManager.selectedTheme == .dark ? Color(UIColor(red: 0.25, green: 0.25, blue: 0.3, alpha: 1)) : Color.white)
                                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
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
                        Text("done_button", bundle: localizationManager.bundle)
                            .foregroundColor(themeManager.selectedTheme.primaryColor)
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
