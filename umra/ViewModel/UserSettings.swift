//
//  UserSettings.swift
//  umra
//
//  Created by Saydulayev on 03.12.24.
//

import Foundation

// MARK: - Extensions for Localization
extension String {
    func localized(bundle: Bundle?) -> String {
        guard let bundle = bundle else { return self }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: self, comment: "")
    }
}

// MARK: - UserSettings
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
    
    var bundle: Bundle?
    
    init() {
        lang = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "ru"
        hasSelectedLanguage = UserDefaults.standard.bool(forKey: "hasSelectedLanguage")
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


