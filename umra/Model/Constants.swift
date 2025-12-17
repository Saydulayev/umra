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
    // Timer constants
    static let reviewRequestTimeInterval: TimeInterval = 300 // 5 minutes
    
    // Background task constants
    static let backgroundTaskInterval: TimeInterval = 3600 // 1 hour
    
    // Pending transaction constants
    static let pendingTransactionExpirationInterval: TimeInterval = 24 * 60 * 60 // 24 hours
    
    // Prayer time calculation
    static let meccaLatitude: Double = 21.4225
    static let meccaLongitude: Double = 39.8262
    
    // Grid layout
    static let gridColumnCount = 2
    static let gridColumnSpacing: CGFloat = 10
    
    // Notification intervals
    static let notification30MinutesInterval: TimeInterval = 30 * 60 // 30 minutes in seconds
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
}
