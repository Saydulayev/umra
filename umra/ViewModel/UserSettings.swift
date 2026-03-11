//
//  UserSettings.swift
//  umra
//
//  Created by Saydulayev on 03.12.24.
//

import Foundation
import SwiftUI

// MARK: - Theme System
enum AppTheme: String, CaseIterable, Sendable {
    case light = "light"
    case dark = "dark"
    case emerald = "emerald"
    
    var colorScheme: ColorScheme {
        switch self {
        case .light: return .light
        case .dark, .emerald: return .dark
        }
    }

    var isDarkAppearance: Bool {
        switch self {
        case .light:
            return false
        case .dark, .emerald:
            return true
        }
    }

    var usesTintedArabicCards: Bool {
        self == .emerald
    }
    
    func displayName(bundle: Bundle) -> String {
        switch self {
        case .light:
            return NSLocalizedString("theme_nur", bundle: bundle, comment: "Light theme — Nur")
        case .dark:
            return NSLocalizedString("theme_layl", bundle: bundle, comment: "Dark theme — Layl")
        case .emerald:
            return NSLocalizedString("theme_emerald", bundle: bundle, comment: "Emerald theme")
        }
    }

    var subtitleKey: String {
        switch self {
        case .light:
            return "theme_nur_subtitle"
        case .dark:
            return "theme_layl_subtitle"
        case .emerald:
            return "theme_emerald_subtitle"
        }
    }

    var iconName: String {
        switch self {
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.stars.fill"
        case .emerald:
            return "sparkles"
        }
    }
    
    // MARK: - Primary Accent (Emerald Green)
    
    var primaryColor: Color {
        switch self {
        case .light:
            return Color(red: 0.063, green: 0.725, blue: 0.506)  // #10B981
        case .dark:
            return Color(red: 0.204, green: 0.827, blue: 0.600)  // #34D399
        case .emerald:
            return Color(red: 0.196, green: 0.776, blue: 0.592)  // #32C698
        }
    }
    
    // MARK: - Secondary Accent (Premium Gold)
    
    var secondaryColor: Color {
        switch self {
        case .light:
            return Color(red: 0.812, green: 0.686, blue: 0.353)  // #CFAF5A
        case .dark:
            return Color(red: 0.902, green: 0.784, blue: 0.471)  // #E6C878
        case .emerald:
            return Color(red: 0.847, green: 0.710, blue: 0.396)  // #D8B565
        }
    }
    
    // MARK: - Gradients
    
    var gradientTopColor: Color {
        switch self {
        case .light:
            return Color(red: 247/255, green: 247/255, blue: 247/255)  // #f7f7f7
        case .dark:
            return Color(red: 16/255, green: 16/255, blue: 16/255)  // #101010
        case .emerald:
            return Color(red: 13/255, green: 17/255, blue: 16/255)  // #0d1110
        }
    }
    
    var gradientBottomColor: Color {
        switch self {
        case .light:
            return Color(red: 247/255, green: 247/255, blue: 247/255)  // #f7f7f7
        case .dark:
            return Color(red: 16/255, green: 16/255, blue: 16/255)  // #101010
        case .emerald:
            return Color(red: 11/255, green: 14/255, blue: 13/255)  // #0b0e0d
        }
    }
    
    // MARK: - Backgrounds
    
    var backgroundColor: Color {
        switch self {
        case .light:
            return Color(red: 247/255, green: 247/255, blue: 247/255)  // #f7f7f7
        case .dark:
            return Color(red: 16/255, green: 16/255, blue: 16/255)  // #101010
        case .emerald:
            return Color(red: 12/255, green: 15/255, blue: 14/255)  // #0c0f0e
        }
    }
    
    var lightBackgroundColor: Color {
        switch self {
        case .light:
            return Color(red: 247/255, green: 247/255, blue: 247/255)  // #f7f7f7
        case .dark:
            return Color(red: 16/255, green: 16/255, blue: 16/255)  // #101010
        case .emerald:
            return Color(red: 12/255, green: 15/255, blue: 14/255)  // #0c0f0e
        }
    }
    
    var textBackgroundColor: Color {
        switch self {
        case .light:
            return Color(red: 247/255, green: 247/255, blue: 247/255)  // #f7f7f7
        case .dark:
            return Color(red: 16/255, green: 16/255, blue: 16/255)  // #101010
        case .emerald:
            return Color(red: 12/255, green: 15/255, blue: 14/255)  // #0c0f0e
        }
    }
    
    var cardColor: Color {
        switch self {
        case .light:
            return Color(red: 1.0, green: 1.0, blue: 1.0)        // #ffffff
        case .dark:
            return Color(red: 26/255, green: 26/255, blue: 26/255)  // #1a1a1a
        case .emerald:
            return Color(red: 22/255, green: 24/255, blue: 24/255)  // #161818
        }
    }
    
    var cardBorderColor: Color {
        switch self {
        case .light:
            return Color.black.opacity(0.14)
        case .dark:
            return Color.white.opacity(0.12)
        case .emerald:
            return Color.white.opacity(0.13)
        }
    }
    
    var cardFrameShadowColor: Color {
        switch self {
        case .light:
            return Color.black.opacity(0.08)
        case .dark:
            return Color.black.opacity(0.18)
        case .emerald:
            return Color.black.opacity(0.28)
        }
    }

    var cardShadowColor: Color {
        switch self {
        case .light:
            return Color.black.opacity(0.10)
        case .dark:
            return Color.black.opacity(0.45)
        case .emerald:
            return Color.black.opacity(0.52)
        }
    }
    
    /// Нейтральная подсветка карточки (вместо зелёного оттенка primaryColor)
    var cardTintColor: Color {
        switch self {
        case .light:
            return Color.white.opacity(0.6)
        case .dark:
            return Color.white.opacity(0.06)
        case .emerald:
            return Color(red: 0.83, green: 0.93, blue: 0.88).opacity(0.10)
        }
    }
    
    // MARK: - Preview & Buttons
    
    var previewColor: Color {
        switch self {
        case .light:
            return Color(red: 0.063, green: 0.725, blue: 0.506).opacity(0.12)  // Emerald tint
        case .dark:
            return Color(red: 0.204, green: 0.827, blue: 0.600).opacity(0.12)  // Emerald tint
        case .emerald:
            return Color(red: 0.196, green: 0.776, blue: 0.592).opacity(0.18)
        }
    }
    
    var activeButtonColor: Color {
        switch self {
        case .light:
            return Color(red: 0.063, green: 0.725, blue: 0.506)  // #10B981
        case .dark:
            return Color(red: 0.204, green: 0.827, blue: 0.600)  // #34D399
        case .emerald:
            return Color(red: 0.196, green: 0.776, blue: 0.592)  // #32C698
        }
    }
    
    // MARK: - Text
    
    var textColor: Color {
        switch self {
        case .light:
            return Color(red: 0.110, green: 0.110, blue: 0.118)  // #1C1C1E
        case .dark:
            return Color(red: 0.918, green: 0.918, blue: 0.925)  // #EAEAEC
        case .emerald:
            return Color(red: 0.932, green: 0.944, blue: 0.938)  // #eef1ef
        }
    }
}

// MARK: - Extensions for Localization
extension String {
    func localized(bundle: Bundle?) -> String {
        guard let bundle = bundle else { return self }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: self, comment: "")
    }
}

// MARK: - Theme Manager
@MainActor
@Observable
class ThemeManager {
    var selectedTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: UserDefaultsKey.selectedTheme)
        }
    }
    
    init() {
        let saved = UserDefaults.standard.string(forKey: UserDefaultsKey.selectedTheme) ?? "light"
        if let theme = AppTheme(rawValue: saved) {
            selectedTheme = theme
        } else {
            selectedTheme = (saved == "dark") ? .dark : .light
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: UserDefaultsKey.selectedTheme)
        }
    }
}

// MARK: - Localization Manager
@MainActor
@Observable
class LocalizationManager {
    var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: UserDefaultsKey.selectedLanguage)
            loadBundle()
        }
    }
    
    var hasSelectedLanguage: Bool {
        didSet {
            UserDefaults.standard.set(hasSelectedLanguage, forKey: UserDefaultsKey.hasSelectedLanguage)
        }
    }
    
    var bundle: Bundle?
    
    init() {
        currentLanguage = UserDefaults.standard.string(forKey: UserDefaultsKey.selectedLanguage) ?? "ru"
        hasSelectedLanguage = UserDefaults.standard.bool(forKey: UserDefaultsKey.hasSelectedLanguage)
        loadBundle()
    }
    
    private func loadBundle() {
        guard let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
              let resultBundle = Bundle(path: path) else {
            bundle = nil
            return
        }
        bundle = resultBundle
    }
}

// MARK: - User Preferences Manager
@MainActor
@Observable
class UserPreferences {
    var hasSelectedLanguage: Bool {
        didSet {
            UserDefaults.standard.set(hasSelectedLanguage, forKey: UserDefaultsKey.hasSelectedLanguage)
        }
    }
    
    var isGridView: Bool {
        didSet {
            UserDefaults.standard.set(isGridView, forKey: UserDefaultsKey.isGridView)
        }
    }
    
    var hasRatedApp: Bool {
        didSet {
            UserDefaults.standard.set(hasRatedApp, forKey: UserDefaultsKey.hasRatedApp)
        }
    }
    
    init() {
        hasSelectedLanguage = UserDefaults.standard.bool(forKey: UserDefaultsKey.hasSelectedLanguage)
        isGridView = UserDefaults.standard.bool(forKey: UserDefaultsKey.isGridView) || UIDevice.current.userInterfaceIdiom == .pad
        hasRatedApp = UserDefaults.standard.bool(forKey: UserDefaultsKey.hasRatedApp)
    }
}

