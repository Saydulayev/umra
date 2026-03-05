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
    @State private var showLanguageActionSheet = false
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(\.dismiss) var dismiss
    
    // URL App Store - гарантированно валидный
    private let appStoreURL = URL(string: "https://apps.apple.com/app/id1673683355")!
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var contentSpacing: CGFloat {
        isIPad ? 24 : 16
    }
    
    private var contentPadding: CGFloat {
        isIPad ? 32 : 16
    }

    private var currentLanguageDisplayName: String {
        switch localizationManager.currentLanguage {
        case "ar":
            return "العربية"
        case "ru":
            return "Русский"
        case "en":
            return "English"
        case "de":
            return "Deutsch"
        case "fr":
            return "Français"
        case "tr":
            return "Türkçe"
        case "id":
            return "Bahasa Indonesia"
        default:
            return localizationManager.currentLanguage
        }
    }

    private var secondaryTextColor: Color {
        themeManager.selectedTheme.textColor.opacity(0.6)
    }
    
    var body: some View {
        ZStack {
            themeManager.selectedTheme.lightBackgroundColor
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: contentSpacing) {
                    SettingsSection {
                        Button(action: openFeedbackEmail) {
                            SettingsRow(
                                icon: "message",
                                title: Text("text_button_feedback_string", bundle: localizationManager.bundle),
                                accentColor: themeManager.selectedTheme.primaryColor
                            )
                        }
                        .buttonStyle(.plain)

                        SettingsDivider()

                        Button(action: { showSafariView.toggle() }) {
                            SettingsRow(
                                icon: "star",
                                title: Text("text_button_rate_the_app_string", bundle: localizationManager.bundle),
                                accentColor: themeManager.selectedTheme.primaryColor
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    SettingsSection {
                        Button(action: { showNotificationSettingsSheet.toggle() }) {
                            SettingsRow(
                                icon: "bell",
                                title: Text("Notification Settings", bundle: localizationManager.bundle),
                                accentColor: themeManager.selectedTheme.primaryColor
                            )
                        }
                        .buttonStyle(.plain)

                        SettingsDivider()

                        Button(action: { showLanguageActionSheet = true }) {
                            SettingsRow(
                                icon: "globe",
                                title: Text("select_language_settings_string", bundle: localizationManager.bundle),
                                accentColor: themeManager.selectedTheme.primaryColor,
                                accessory: {
                                    Text(currentLanguageDisplayName)
                                        .font(.system(size: SettingsMetrics.isIPad ? 18 : 14, weight: .medium))
                                        .foregroundColor(secondaryTextColor)
                                }
                            )
                        }
                        .buttonStyle(.plain)
                        .actionSheet(isPresented: $showLanguageActionSheet) {
                            languageActionSheet
                        }

                        SettingsDivider()

                        Button(action: { showThemeSelectionSheet.toggle() }) {
                            SettingsRow(
                                icon: "paintbrush.fill",
                                title: Text("theme_app_title", bundle: localizationManager.bundle),
                                accentColor: themeManager.selectedTheme.primaryColor,
                                accessory: {
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(themeManager.selectedTheme.primaryColor)
                                            .frame(width: isIPad ? 24 : 18, height: isIPad ? 24 : 18)
                                        Text(themeManager.selectedTheme.displayName(bundle: localizationManager.bundle ?? Bundle.main))
                                            .font(.system(size: SettingsMetrics.isIPad ? 18 : 14, weight: .medium))
                                            .foregroundColor(secondaryTextColor)
                                    }
                                }
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    SettingsSection {
                        PurchaseView()
                    }
                }
                .padding(contentPadding)
                .padding(.vertical, 8)
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarTitle(Text("settings_string", bundle: localizationManager.bundle), displayMode: .inline)
        .sheet(isPresented: $showSafariView) {
            SafariView(url: appStoreURL)
        }
        .sheet(isPresented: $showNotificationSettingsSheet) {
            NotificationSettingsView()
        }
        .sheet(isPresented: $showThemeSelectionSheet) {
            ThemePreviewView()
        }
        .toolbar(.hidden, for: .tabBar)
    }

    private func openFeedbackEmail() {
        if let url = URL(string: "mailto:saydulayev.wien@gmail.com") {
            UIApplication.shared.open(url)
        }
    }

    private var languageActionSheet: ActionSheet {
        ActionSheet(
            title: Text("select_language_settings_string", bundle: localizationManager.bundle)
                .foregroundColor(themeManager.selectedTheme.primaryColor),
            message: nil,
            buttons: [
                .default(Text("العربية")) { localizationManager.currentLanguage = "ar" },
                .default(Text("Русский")) { localizationManager.currentLanguage = "ru" },
                .default(Text("English")) { localizationManager.currentLanguage = "en" },
                .default(Text("Deutsch")) { localizationManager.currentLanguage = "de" },
                .default(Text("Français")) { localizationManager.currentLanguage = "fr" },
                .default(Text("Türkçe")) { localizationManager.currentLanguage = "tr" },
                .default(Text("Bahasa Indonesia")) { localizationManager.currentLanguage = "id" },
                .cancel()
            ]
        )
    }
}

// MARK: - Settings Components

private enum SettingsMetrics {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    static var rowHorizontalPadding: CGFloat {
        isIPad ? 20 : 16
    }

    static var rowVerticalPadding: CGFloat {
        isIPad ? 16 : 12
    }

    static var rowSpacing: CGFloat {
        isIPad ? 16 : 12
    }

    static var iconContainerSize: CGFloat {
        isIPad ? 46 : 38
    }

    static var iconSize: CGFloat {
        isIPad ? 22 : 18
    }

    static var cornerRadius: CGFloat {
        isIPad ? 24 : 18
    }
}

struct SettingsSection<Content: View>: View {
    @Environment(ThemeManager.self) private var themeManager
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    private var cardBackground: Color {
        themeManager.selectedTheme.cardColor
    }

    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(
            RoundedRectangle(cornerRadius: SettingsMetrics.cornerRadius, style: .continuous)
                .fill(cardBackground)
                .shadow(color: themeManager.selectedTheme.cardShadowColor,
                        radius: SettingsMetrics.isIPad ? 14 : 10,
                        x: 0,
                        y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: SettingsMetrics.cornerRadius, style: .continuous)
                        .stroke(themeManager.selectedTheme.cardBorderColor, lineWidth: 1)
                )
        )
    }
}

struct SettingsRow<Accessory: View>: View {
    @Environment(ThemeManager.self) private var themeManager
    let icon: String
    let title: Text
    let subtitle: Text?
    let accentColor: Color
    let showsChevron: Bool
    let accessory: Accessory

    init(
        icon: String,
        title: Text,
        subtitle: Text? = nil,
        accentColor: Color,
        showsChevron: Bool = true,
        @ViewBuilder accessory: () -> Accessory = { EmptyView() }
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.accentColor = accentColor
        self.showsChevron = showsChevron
        self.accessory = accessory()
    }

    private var iconBackground: Color {
        accentColor.opacity(themeManager.selectedTheme == .dark ? 0.25 : 0.15)
    }

    var body: some View {
        HStack(spacing: SettingsMetrics.rowSpacing) {
            ZStack {
                Circle()
                    .fill(iconBackground)
                Image(systemName: icon)
                    .font(.system(size: SettingsMetrics.iconSize, weight: .semibold))
                    .foregroundColor(accentColor)
            }
            .frame(width: SettingsMetrics.iconContainerSize, height: SettingsMetrics.iconContainerSize)

            VStack(alignment: .leading, spacing: 3) {
                title
                    .font(.system(size: SettingsMetrics.isIPad ? 20 : 16, weight: .semibold))
                    .foregroundColor(themeManager.selectedTheme.textColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .allowsTightening(true)
                    .truncationMode(.tail)
                if let subtitle {
                    subtitle
                        .font(.system(size: SettingsMetrics.isIPad ? 15 : 12))
                        .foregroundColor(themeManager.selectedTheme.textColor.opacity(0.6))
                }
            }

            Spacer(minLength: 8)

            HStack(spacing: 6) {
                accessory
                if showsChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: SettingsMetrics.isIPad ? 16 : 14, weight: .semibold))
                        .foregroundColor(themeManager.selectedTheme.textColor.opacity(0.45))
                }
            }
        }
        .padding(.horizontal, SettingsMetrics.rowHorizontalPadding)
        .padding(.vertical, SettingsMetrics.rowVerticalPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}

struct SettingsDivider: View {
    private var leadingInset: CGFloat {
        SettingsMetrics.rowHorizontalPadding + SettingsMetrics.iconContainerSize + SettingsMetrics.rowSpacing
    }

    var body: some View {
        Divider()
            .padding(.leading, leadingInset)
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
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.selectedTheme.lightBackgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: isIPad ? 28 : 20) {
                    Text("theme_select_title", bundle: localizationManager.bundle)
                        .font(.system(size: isIPad ? 28 : 22, weight: .bold))
                        .foregroundColor(themeManager.selectedTheme.textColor)
                        .padding(.top, isIPad ? 24 : 16)
                    
                    VStack(spacing: isIPad ? 16 : 12) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            Button {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    themeManager.selectedTheme = theme
                                }
                            } label: {
                                themeCard(for: theme)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, isIPad ? 24 : 16)
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("done_button", bundle: localizationManager.bundle)
                            .foregroundColor(themeManager.selectedTheme.primaryColor)
                    }
                }
            }
        }
    }
    
    private func themeCard(for theme: AppTheme) -> some View {
        let isSelected = themeManager.selectedTheme == theme
        
        return HStack(spacing: isIPad ? 18 : 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [theme.primaryColor, theme.primaryColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: isIPad ? 56 : 46, height: isIPad ? 56 : 46)
                
                Image(systemName: theme == .dark ? "moon.stars.fill" : "sun.max.fill")
                    .font(.system(size: isIPad ? 22 : 18, weight: .medium))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(theme.displayName(bundle: localizationManager.bundle ?? Bundle.main))
                    .font(.system(size: isIPad ? 20 : 17, weight: .semibold))
                    .foregroundColor(themeManager.selectedTheme.textColor)
                
                Text(theme == .dark ? "theme_layl_subtitle" : "theme_nur_subtitle",
                     bundle: localizationManager.bundle)
                    .font(.system(size: isIPad ? 15 : 13))
                    .foregroundColor(themeManager.selectedTheme.textColor.opacity(0.5))
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: isIPad ? 26 : 22))
                    .foregroundColor(theme.primaryColor)
            }
        }
        .padding(isIPad ? 20 : 16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(themeManager.selectedTheme.cardColor)
                .shadow(color: themeManager.selectedTheme.cardShadowColor,
                        radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? theme.primaryColor.opacity(0.5) : themeManager.selectedTheme.cardBorderColor, lineWidth: isSelected ? 2 : 1)
                )
        )
    }
}
