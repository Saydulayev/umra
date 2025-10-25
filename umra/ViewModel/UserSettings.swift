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
            // Небесная тема - более яркий голубой для лучшей видимости обводки
            return Color(#colorLiteral(red: 0.3, green: 0.6, blue: 0.9, alpha: 1))
        case .green:
            // Оазис тема - более яркий зеленый для лучшей видимости обводки
            return Color(#colorLiteral(red: 0.2, green: 0.7, blue: 0.3, alpha: 1))
        case .gold:
            // Золотая тема - более яркий золотой для лучшей видимости обводки
            return Color(#colorLiteral(red: 0.8, green: 0.6, blue: 0.1, alpha: 1))
        case .turquoise:
            // Бирюзовая тема - более яркий бирюзовый для лучшей видимости обводки
            return Color(#colorLiteral(red: 0.1, green: 0.7, blue: 0.7, alpha: 1))
        }
    }
    
    var gradientTopColor: Color {
        switch self {
        case .blue:
            // Небесная тема - светлый голубой градиент
            return Color(#colorLiteral(red: 0.94, green: 0.97, blue: 1.0, alpha: 1))
        case .green:
            // Оазис тема - светлый зеленый градиент
            return Color(#colorLiteral(red: 0.95, green: 0.98, blue: 0.95, alpha: 1))
        case .gold:
            // Золотая тема - светлый теплый кремовый градиент
            return Color(#colorLiteral(red: 0.98, green: 0.95, blue: 0.88, alpha: 1))
        case .turquoise:
            // Бирюзовая тема - светлый бирюзовый градиент
            return Color(#colorLiteral(red: 0.95, green: 0.98, blue: 0.98, alpha: 1))
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
            // Небесная тема - очень светлый голубой с легким оттенком
            return Color(UIColor(red: 0.99, green: 0.995, blue: 1.0, alpha: 1))
        case .green:
            // Оазис тема - очень светлый зеленый с легким оттенком
            return Color(UIColor(red: 0.99, green: 1.0, blue: 0.99, alpha: 1))
        case .gold:
            // Золотая тема - очень светлый теплый кремовый
            return Color(UIColor(red: 1.0, green: 0.995, blue: 0.98, alpha: 1))
        case .turquoise:
            // Бирюзовая тема - очень светлый бирюзовый с легким оттенком
            return Color(UIColor(red: 0.99, green: 1.0, blue: 1.0, alpha: 1))
        }
    }
    
    var textBackgroundColor: Color {
        switch self {
        case .blue:
            // Небесная тема - светлый голубой с хорошим контрастом
            return Color(#colorLiteral(red: 0.92, green: 0.96, blue: 0.98, alpha: 1))
        case .green:
            // Оазис тема - светлый зеленый с хорошим контрастом
            return Color(#colorLiteral(red: 0.94, green: 0.98, blue: 0.94, alpha: 1))
        case .gold:
            // Золотая тема - светлый теплый кремовый с хорошим контрастом
            return Color(#colorLiteral(red: 0.98, green: 0.96, blue: 0.92, alpha: 1))
        case .turquoise:
            // Бирюзовая тема - светлый бирюзовый с хорошим контрастом
            return Color(#colorLiteral(red: 0.94, green: 0.98, blue: 0.98, alpha: 1))
        }
    }
    
    // Мягкие цвета для превью в выборе темы
    var previewColor: Color {
        switch self {
        case .blue:
            // Небесная тема - мягкий голубой для превью
            return Color(#colorLiteral(red: 0.5, green: 0.7, blue: 0.9, alpha: 1))
        case .green:
            // Оазис тема - мягкий зеленый для превью
            return Color(#colorLiteral(red: 0.4, green: 0.7, blue: 0.5, alpha: 1))
        case .gold:
            // Золотая тема - мягкий золотой для превью
            return Color(#colorLiteral(red: 0.8, green: 0.7, blue: 0.3, alpha: 1))
        case .turquoise:
            // Бирюзовая тема - мягкий бирюзовый для превью
            return Color(#colorLiteral(red: 0.3, green: 0.7, blue: 0.7, alpha: 1))
        }
    }
    
    // Яркие цвета для активных кнопок плеера
    var activeButtonColor: Color {
        switch self {
        case .blue:
            // Небесная тема - яркий синий для активных кнопок
            return Color(#colorLiteral(red: 0.0, green: 0.5, blue: 1.0, alpha: 1))
        case .green:
            // Оазис тема - яркий зеленый для активных кнопок
            return Color(#colorLiteral(red: 0.0, green: 0.8, blue: 0.0, alpha: 1))
        case .gold:
            // Золотая тема - яркий золотой для активных кнопок
            return Color(#colorLiteral(red: 1.0, green: 0.8, blue: 0.0, alpha: 1))
        case .turquoise:
            // Бирюзовая тема - яркий бирюзовый для активных кнопок
            return Color(#colorLiteral(red: 0.0, green: 0.8, blue: 0.8, alpha: 1))
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


