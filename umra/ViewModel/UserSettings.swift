//
//  UserSettings.swift
//  umra
//
//  Created by Saydulayev on 03.12.24.
//

import Foundation
import SwiftUI

// MARK: - Theme System
enum AppTheme: String, CaseIterable {
    case blue = "blue"
    case green = "green"
    case gold = "gold"
    case turquoise = "turquoise"
    
    func displayName(bundle: Bundle) -> String {
        switch self {
        case .blue:
            return NSLocalizedString("theme_heavenly", bundle: bundle, comment: "Heavenly theme")
        case .green:
            return NSLocalizedString("theme_oasis", bundle: bundle, comment: "Oasis theme")
        case .gold:
            return NSLocalizedString("theme_gold", bundle: bundle, comment: "Gold theme")
        case .turquoise:
            return NSLocalizedString("theme_turquoise", bundle: bundle, comment: "Turquoise theme")
        }
    }
    
    var primaryColor: Color {
        switch self {
        case .blue:
            return Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
        case .green:
            return Color(#colorLiteral(red: 0.6, green: 0.8, blue: 0.6, alpha: 1))
        case .gold:
            return Color(#colorLiteral(red: 0.9, green: 0.8, blue: 0.4, alpha: 1))
        case .turquoise:
            return Color(#colorLiteral(red: 0.4, green: 0.8, blue: 0.8, alpha: 1))
        }
    }
    
    var gradientTopColor: Color {
        switch self {
        case .blue:
            return Color(#colorLiteral(red: 0.8980392157, green: 0.933333333, blue: 1, alpha: 1))
        case .green:
            return Color(#colorLiteral(red: 0.9, green: 0.95, blue: 0.9, alpha: 1))
        case .gold:
            return Color(#colorLiteral(red: 0.95, green: 0.9, blue: 0.7, alpha: 1))
        case .turquoise:
            return Color(#colorLiteral(red: 0.9, green: 0.95, blue: 0.95, alpha: 1))
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .blue:
            return Color(UIColor(red: 0.898, green: 0.933, blue: 1, alpha: 1))
        case .green:
            return Color(UIColor(red: 0.9, green: 0.95, blue: 0.9, alpha: 1))
        case .gold:
            return Color(UIColor(red: 0.95, green: 0.9, blue: 0.7, alpha: 1))
        case .turquoise:
            return Color(UIColor(red: 0.9, green: 0.95, blue: 0.95, alpha: 1))
        }
    }
    
    var lightBackgroundColor: Color {
        switch self {
        case .blue:
            // Профессиональный подход: высокая яркость (95%+) с легким оттенком темы
            return Color(UIColor(red: 0.98, green: 0.99, blue: 1.0, alpha: 1))
        case .green:
            // Оптимальный контраст для черного текста с зеленым оттенком
            return Color(UIColor(red: 0.98, green: 1.0, blue: 0.98, alpha: 1))
        case .gold:
            // Теплый, но очень светлый фон для максимальной читаемости
            return Color(UIColor(red: 1.0, green: 0.99, blue: 0.95, alpha: 1))
        case .turquoise:
            // Светлый бирюзовый с высокой яркостью для контраста
            return Color(UIColor(red: 0.98, green: 1.0, blue: 1.0, alpha: 1))
        }
    }
    
    var textBackgroundColor: Color {
        switch self {
        case .blue:
            // Профессиональный подход: достаточная яркость для читаемости черного текста
            return Color(#colorLiteral(red: 0.85, green: 0.92, blue: 0.95, alpha: 1))
        case .green:
            // Оптимизированный зеленый с высокой яркостью
            return Color(#colorLiteral(red: 0.88, green: 0.95, blue: 0.88, alpha: 1))
        case .gold:
            // Теплый золотистый с достаточным контрастом
            return Color(#colorLiteral(red: 0.95, green: 0.92, blue: 0.85, alpha: 1))
        case .turquoise:
            // Светлый бирюзовый для оптимальной читаемости
            return Color(#colorLiteral(red: 0.88, green: 0.95, blue: 0.95, alpha: 1))
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
@available(iOS 17.0, *)
@Observable
class ThemeManager {
    var selectedTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: "selectedTheme")
        }
    }
    
    init() {
        selectedTheme = AppTheme(rawValue: UserDefaults.standard.string(forKey: "selectedTheme") ?? "blue") ?? .blue
    }
}

// MARK: - Localization Manager
@available(iOS 17.0, *)
@Observable
class LocalizationManager {
    var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "selectedLanguage")
            loadBundle()
        }
    }
    
    var hasSelectedLanguage: Bool {
        didSet {
            UserDefaults.standard.set(hasSelectedLanguage, forKey: "hasSelectedLanguage")
        }
    }
    
    var bundle: Bundle?
    
    init() {
        currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "ru"
        hasSelectedLanguage = UserDefaults.standard.bool(forKey: "hasSelectedLanguage")
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
@available(iOS 17.0, *)
@Observable
class UserPreferences {
    var hasSelectedLanguage: Bool {
        didSet {
            UserDefaults.standard.set(hasSelectedLanguage, forKey: "hasSelectedLanguage")
        }
    }
    
    var isGridView: Bool {
        didSet {
            UserDefaults.standard.set(isGridView, forKey: "isGridView")
        }
    }
    
    var hasRatedApp: Bool {
        didSet {
            UserDefaults.standard.set(hasRatedApp, forKey: "hasRatedApp")
        }
    }
    
    init() {
        hasSelectedLanguage = UserDefaults.standard.bool(forKey: "hasSelectedLanguage")
        isGridView = UserDefaults.standard.bool(forKey: "isGridView") || UIDevice.current.userInterfaceIdiom == .pad
        hasRatedApp = UserDefaults.standard.bool(forKey: "hasRatedApp")
    }
}

// MARK: - UserSettings (Legacy - для обратной совместимости)
class UserSettings: ObservableObject {
    @Published var lang: String {
        didSet {
            UserDefaults.standard.set(lang, forKey: "selectedLanguage")
            loadBundle()
        }
    }
    @Published var hasSelectedLanguage: Bool {
        didSet {
            UserDefaults.standard.set(hasSelectedLanguage, forKey: "hasSelectedLanguage")
        }
    }
    @Published var selectedTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: "selectedTheme")
        }
    }
    
    var bundle: Bundle?
    
    init() {
        lang = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "ru"
        hasSelectedLanguage = UserDefaults.standard.bool(forKey: "hasSelectedLanguage")
        selectedTheme = AppTheme(rawValue: UserDefaults.standard.string(forKey: "selectedTheme") ?? "blue") ?? .blue
        loadBundle()
    }
    
    private func loadBundle() {
        guard let path = Bundle.main.path(forResource: lang, ofType: "lproj"),
              let resultBundle = Bundle(path: path) else {
            bundle = nil
            return
        }
        bundle = resultBundle
    }
}


