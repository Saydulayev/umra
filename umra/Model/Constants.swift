//
//  Constants.swift
//  umra
//
//  Created for application constants
//

import Foundation
import SwiftUI

// MARK: - Product IDs

enum ProductID: String, CaseIterable {
    case umrahSunnah1 = "UmrahSunnah1"
    case umrahSunnah2 = "UmrahSunnah2"
    case umrahSunnah3 = "UmrahSunnah3"
    case umrahSunnah4 = "UmrahSunnah4"
    case umrahSunnah5 = "UmrahSunnah5"
    case umrahSunnah6 = "UmrahSunnah6"
    
    var displayPrice: String {
        switch self {
        case .umrahSunnah1: return "$0.99"
        case .umrahSunnah2: return "$4.99"
        case .umrahSunnah3: return "$9.99"
        case .umrahSunnah4: return "$19.99"
        case .umrahSunnah5: return "$49.99"
        case .umrahSunnah6: return "$99.99"
        }
    }
    
    static var allProductIDs: [String] {
        ProductID.allCases.map(\.rawValue)
    }
}

// MARK: - App Constants

enum AppConstants {
    // Константы таймера
    static let reviewRequestTimeInterval: TimeInterval = 300 // 5 минут
    
    // Константы фоновых задач
    static let backgroundTaskInterval: TimeInterval = 3600 // 1 час
    
    // Константы ожидающих транзакций
    static let pendingTransactionExpirationInterval: TimeInterval = 24 * 60 * 60 // 24 часа
    
    // Вычисление времени молитв
    static let meccaLatitude: Double = 21.4225
    static let meccaLongitude: Double = 39.8262
    static let medinaLatitude: Double = 24.4672
    static let medinaLongitude: Double = 39.6111
    
    // Макет сетки (только для iPhone)
    static let gridColumnCount = 2
    static let gridColumnSpacing: CGFloat = 10
    
    // Интервалы уведомлений
    static let notification30MinutesInterval: TimeInterval = 30 * 60 // 30 минут в секундах
}

// MARK: - UserDefaults Keys

enum UserDefaultsKey {
    static let selectedTheme = "selectedTheme"
    static let selectedLanguage = "selectedLanguage"
    static let hasSelectedLanguage = "hasSelectedLanguage"
    static let isGridView = "isGridView"
    static let hasRatedApp = "hasRatedApp"
    static let selectedFont = "SelectedFont"
    static let selectedFontSize = "SelectedFontSize"
    static let tawafCircuitCount = "tawafCircuitCount"
    static let prayerCity = "prayerCity"
}

// MARK: - Prayer City

enum PrayerCity: String, CaseIterable {
    case mecca
    case medina

    var latitude: Double {
        switch self {
        case .mecca: return AppConstants.meccaLatitude
        case .medina: return AppConstants.medinaLatitude
        }
    }

    var longitude: Double {
        switch self {
        case .mecca: return AppConstants.meccaLongitude
        case .medina: return AppConstants.medinaLongitude
        }
    }
}
