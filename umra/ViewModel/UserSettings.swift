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
    case blue = "blue"
    case green = "green"
    case gold = "gold"
    case turquoise = "turquoise"
    case dark = "dark"
    
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
        case .dark:
            return NSLocalizedString("theme_dark", bundle: bundle, comment: "Dark theme")
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
            // Золотая тема - золотой цвет для видимости иконок, но светлее для одинакового контраста фона
            return Color(#colorLiteral(red: 0.7, green: 0.55, blue: 0.25, alpha: 1))
        case .turquoise:
            // Бирюзовая тема - более яркий бирюзовый для лучшей видимости обводки
            return Color(#colorLiteral(red: 0.1, green: 0.7, blue: 0.7, alpha: 1))
        case .dark:
            // Темная тема - светло-серый для акцентов
            return Color(#colorLiteral(red: 0.7, green: 0.7, blue: 0.7, alpha: 1))
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
            // Золотая тема - более светлый кремовый градиент для одинакового контраста
            return Color(#colorLiteral(red: 0.99, green: 0.97, blue: 0.95, alpha: 1))
        case .turquoise:
            // Бирюзовая тема - светлый бирюзовый градиент
            return Color(#colorLiteral(red: 0.95, green: 0.98, blue: 0.98, alpha: 1))
        case .dark:
            // Темная тема - темно-серый градиент
            return Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.25, alpha: 1))
        }
    }
    
    var gradientBottomColor: Color {
        switch self {
        case .dark:
            // Темная тема - еще более темный цвет для градиента
            return Color(#colorLiteral(red: 0.12, green: 0.12, blue: 0.18, alpha: 1))
        default:
            // Для светлых тем - белый
            return Color.white
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .blue:
            return Color(UIColor(red: 0.898, green: 0.933, blue: 1, alpha: 1))
        case .green:
            return Color(UIColor(red: 0.9, green: 0.95, blue: 0.9, alpha: 1))
        case .gold:
            return Color(UIColor(red: 0.98, green: 0.96, blue: 0.94, alpha: 1))
        case .turquoise:
            return Color(UIColor(red: 0.9, green: 0.95, blue: 0.95, alpha: 1))
        case .dark:
            // Темная тема - не слишком черный, темно-серый
            return Color(UIColor(red: 0.15, green: 0.15, blue: 0.2, alpha: 1))
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
        case .dark:
            // Темная тема - немного светлее основного фона
            return Color(UIColor(red: 0.18, green: 0.18, blue: 0.23, alpha: 1))
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
        case .dark:
            // Темная тема - темно-серый фон для текста
            return Color(#colorLiteral(red: 0.22, green: 0.22, blue: 0.27, alpha: 1))
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
        case .dark:
            // Темная тема - темно-серый для превью
            return Color(#colorLiteral(red: 0.3, green: 0.3, blue: 0.35, alpha: 1))
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
        case .dark:
            // Темная тема - светло-серый для активных кнопок
            return Color(#colorLiteral(red: 0.9, green: 0.9, blue: 0.9, alpha: 1))
        }
    }
    
    // Цвет текста - белый для темной темы, черный для остальных
    var textColor: Color {
        switch self {
        case .dark:
            return .white
        default:
            return .black
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
        selectedTheme = AppTheme(rawValue: UserDefaults.standard.string(forKey: UserDefaultsKey.selectedTheme) ?? "blue") ?? .blue
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



