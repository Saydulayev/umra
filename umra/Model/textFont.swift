//
//  textEditorView.swift
//  umra
//
//  Created by Akhmed on 06.11.23.
//

import SwiftUI

@MainActor
@Observable
class FontManager {

    /// Сентинел-значение для системного шрифта SF Pro
    static let systemFontKey = "SF Pro (System)"

    // Вычисляемое свойство для динамического размера шрифта
    var dynamicFontSize: CGFloat {
        selectedFontSize
    }

    /// Шрифт для основного текста шагов (учитывает выбранный шрифт и размер)
    var bodyFont: Font {
        if selectedFont == FontManager.systemFontKey {
            return .system(size: dynamicFontSize)
        }
        return .custom(selectedFont, size: dynamicFontSize, relativeTo: .body)
    }

    /// Размер шрифта для заголовков секций (адаптивно iPad/iPhone)
    var sectionTitleFontSize: CGFloat {
        AppConstants.isIPad ? 28 : 26
    }

    /// Шрифт для заголовков секций
    var sectionTitleFont: Font {
        .custom("Lato-Black", size: sectionTitleFontSize, relativeTo: .title2)
    }

    var fonts: [String] = [
        FontManager.systemFontKey,
        "Arial",
        "Helvetica",
        "Times New Roman",
        "Courier",
        "Verdana",
        "Arial Rounded MT Bold",
        "Chalkduster",
        "Georgia",
        "Palatino",
        "Trebuchet MS",
        "Comic Sans MS",
        "Futura",
        "Gill Sans",
        "Optima",
        "Copperplate",
        "Papyrus",
        "Marker Felt",
        "Bradley Hand",
        "Trattatello",
        "Baskerville",
        "American Typewriter",
        "Hoefler Text",
        "Didot",
        "Savoye LET",
        "Bodoni 72",
        "Lato-Black",
        "Lato-Italic",
        "Lato-Blackitalic",
        "Lato-Bold"
    ]

    var selectedFont: String {
        didSet {
            UserDefaults.standard.set(selectedFont, forKey: UserDefaultsKey.selectedFont)
        }
    }

    var selectedFontSize: CGFloat {
        didSet {
            UserDefaults.standard.set(selectedFontSize, forKey: UserDefaultsKey.selectedFontSize)
        }
    }

    init() {
        let storedFont = UserDefaults.standard.string(forKey: UserDefaultsKey.selectedFont)
        // Миграция: старый дефолт "Lato-Black" и "Arial" заменяем на SF Pro
        if storedFont == nil || storedFont == "Lato-Black" || storedFont == "Arial" {
            self.selectedFont = FontManager.systemFontKey
            UserDefaults.standard.set(FontManager.systemFontKey, forKey: UserDefaultsKey.selectedFont)
        } else {
            self.selectedFont = storedFont!
        }
        let deviceDefault: CGFloat = AppConstants.isIPad ? 24 : 17
        let stored = UserDefaults.standard.double(forKey: UserDefaultsKey.selectedFontSize)
        self.selectedFontSize = stored == 0 ? deviceDefault : CGFloat(stored)
    }
}
