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
    
    // Вычисляемое свойство для динамического размера шрифта
    var dynamicFontSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 30 : 20
    }
    
    var fonts: [String] = [
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
        self.selectedFont = UserDefaults.standard.string(forKey: UserDefaultsKey.selectedFont) ?? "Lato-Black"
        self.selectedFontSize = UserDefaults.standard.object(forKey: UserDefaultsKey.selectedFontSize) as? CGFloat ?? 20
    }
}
