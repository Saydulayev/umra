//
//  textEditorView.swift
//  umra
//
//  Created by Akhmed on 06.11.23.
//

import SwiftUI

class FontManager: ObservableObject {
    @Published var fonts: [String] = [
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
        "Zapfino",
        "Lato-Black",
        "Lato-Italic",
        "Lato-Blackitalic",
        "Lato-Bold",

    ]

    
    @Published var selectedFont: String {
        didSet {
            UserDefaults.standard.set(selectedFont, forKey: "SelectedFont")
        }
    }
    
    @Published var selectedFontSize: CGFloat {
        didSet {
            UserDefaults.standard.set(selectedFontSize, forKey: "SelectedFontSize")
        }
    }
    
    init() {
        self.selectedFont = UserDefaults.standard.string(forKey: "SelectedFont") ?? "Lato-Black"
        self.selectedFontSize = UserDefaults.standard.object(forKey: "SelectedFontSize") as? CGFloat ?? 20

    }
}
