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
    
    private var appStoreURL: URL? {
        URL(string: "https://apps.apple.com/app/id1673683355")
    }
    
    
    private var contentSpacing: CGFloat {
        AppConstants.isIPad ? 24 : 16
    }
    
    private var contentPadding: CGFloat {
        AppConstants.isIPad ? 32 : 16
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
            themeManager.selectedTheme.backgroundColor
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

                        Button(action: { if appStoreURL != nil { showSafariView = true } }) {
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
                                        .font(.subheadline.weight(.medium))
                                        .foregroundStyle(secondaryTextColor)
                                }
                            )
                        }
                        .buttonStyle(.plain)
                        .confirmationDialog(
                            Text("select_language_settings_string", bundle: localizationManager.bundle),
                            isPresented: $showLanguageActionSheet
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
                                            .frame(width: AppConstants.isIPad ? 24 : 18, height: AppConstants.isIPad ? 24 : 18)
                                        Text(themeManager.themePreference.displayName(bundle: localizationManager.bundle ?? Bundle.main))
                                            .font(.subheadline.weight(.medium))
                                            .foregroundStyle(secondaryTextColor)
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
        .navigationTitle(Text("settings_string", bundle: localizationManager.bundle))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showSafariView) {
            if let url = appStoreURL {
                SafariView(url: url)
            } else {
                EmptyView()
            }
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

}

// MARK: - Settings Components

private enum SettingsMetrics {
    static var rowHorizontalPadding: CGFloat {
        AppConstants.isIPad ? 20 : 16
    }

    static var rowVerticalPadding: CGFloat {
        AppConstants.isIPad ? 16 : 12
    }

    static var rowSpacing: CGFloat {
        AppConstants.isIPad ? 16 : 12
    }

    static var iconContainerSize: CGFloat {
        AppConstants.isIPad ? 46 : 38
    }

    static var iconSize: CGFloat {
        AppConstants.isIPad ? 22 : 18
    }

    static var cornerRadius: CGFloat {
        AppConstants.isIPad ? 24 : 18
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
        .standardCardFrame(
            theme: themeManager.selectedTheme,
            cornerRadius: SettingsMetrics.cornerRadius,
            borderWidth: 1,
            fillColor: cardBackground,
            shadowRadius: AppConstants.isIPad ? 14 : 10,
            shadowYOffset: 2
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
        accentColor.opacity(themeManager.selectedTheme.isDarkAppearance ? 0.25 : 0.15)
    }

    var body: some View {
        HStack(spacing: SettingsMetrics.rowSpacing) {
            ZStack {
                Circle()
                    .fill(iconBackground)
                Image(systemName: icon)
                    .font(.system(size: SettingsMetrics.iconSize, weight: .semibold))
                    .foregroundStyle(accentColor)
            }
            .frame(width: SettingsMetrics.iconContainerSize, height: SettingsMetrics.iconContainerSize)

            VStack(alignment: .leading, spacing: 3) {
                title
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(themeManager.selectedTheme.textColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .allowsTightening(true)
                    .truncationMode(.tail)
                if let subtitle {
                    subtitle
                        .font(.footnote)
                        .foregroundStyle(themeManager.selectedTheme.textColor.opacity(0.6))
                }
            }

            Spacer(minLength: 8)

            HStack(spacing: 6) {
                accessory
                if showsChevron {
                    Image(systemName: "chevron.right")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(themeManager.selectedTheme.textColor.opacity(0.45))
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

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("theme_select_title", bundle: localizationManager.bundle)
                    .font(.headline)
                    .foregroundStyle(themeManager.selectedTheme.textColor)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(themeManager.selectedTheme.textColor.opacity(0.25))
                }
                .accessibilityLabel(Text("done_button", bundle: localizationManager.bundle))
            }
            .padding(.horizontal, AppConstants.isIPad ? 28 : 20)
            .padding(.top, AppConstants.isIPad ? 28 : 22)
            .padding(.bottom, AppConstants.isIPad ? 20 : 16)

            VStack(spacing: 0) {
                ForEach(Array(AppTheme.allCases.enumerated()), id: \.element) { index, theme in
                    themeRow(for: theme)

                    if index < AppTheme.allCases.count - 1 {
                        Divider()
                            .padding(.leading, AppConstants.isIPad ? 52 : 44)
                            .foregroundStyle(themeManager.selectedTheme.cardBorderColor)
                    }
                }
            }
            .background(themeManager.selectedTheme.cardColor)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(themeManager.selectedTheme.cardBorderColor, lineWidth: 1)
            }
            .padding(.horizontal, AppConstants.isIPad ? 28 : 16)
            .padding(.bottom, AppConstants.isIPad ? 32 : 24)
        }
        .presentationDetents([.height(AppConstants.isIPad ? 400 : 340)])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(28)
        .presentationBackground(themeManager.selectedTheme.backgroundColor)
    }

    private func themeRow(for theme: AppTheme) -> some View {
        let isSelected = themeManager.themePreference == theme

        return Button {
            withAnimation(AppAnimation.settingsToggle) {
                themeManager.themePreference = theme
            }
        } label: {
            HStack(spacing: AppConstants.isIPad ? 14 : 12) {
                themeCircle(for: theme)

                Text(theme.displayName(bundle: localizationManager.bundle ?? .main))
                    .font(.body)
                    .foregroundStyle(themeManager.selectedTheme.textColor)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(themeManager.selectedTheme.primaryColor)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, AppConstants.isIPad ? 18 : 16)
            .padding(.vertical, AppConstants.isIPad ? 16 : 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(theme.displayName(bundle: localizationManager.bundle ?? .main))
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }

    @ViewBuilder
    private func themeCircle(for theme: AppTheme) -> some View {
        let size: CGFloat = AppConstants.isIPad ? 22 : 18
        switch theme {
        case .auto:
            // Половина светлая, половина тёмная — отражает адаптацию к системе
            Circle()
                .fill(LinearGradient(
                    colors: [AppTheme.light.backgroundColor, AppTheme.dark.backgroundColor],
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .frame(width: size, height: size)
                .overlay {
                    Circle().strokeBorder(themeManager.selectedTheme.cardBorderColor, lineWidth: 0.5)
                }
        case .light:
            // Белый → зелёный — чистый светлый тон
            Circle()
                .fill(LinearGradient(
                    colors: [Color.white, theme.primaryColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: size, height: size)
                .overlay {
                    Circle().strokeBorder(themeManager.selectedTheme.cardBorderColor, lineWidth: 0.5)
                }
        case .dark:
            // Глубокий тёмный → изумруд — ночной акцент
            Circle()
                .fill(LinearGradient(
                    colors: [AppTheme.dark.backgroundColor, theme.primaryColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: size, height: size)
        case .emerald:
            // Изумруд → золото — премиальный акцент
            Circle()
                .fill(LinearGradient(
                    colors: [theme.primaryColor, theme.secondaryColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: size, height: size)
        }
    }
}
