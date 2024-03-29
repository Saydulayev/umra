//
//  ColorManager.swift
//  umra
//
//  Created by Akhmed on 31.10.23.
//

import SwiftUI

class ColorManager: ObservableObject {
    @Published var backgroundColor: Color {
        didSet {
            UserDefaults.standard.setColor(color: UIColor(backgroundColor), forKey: "backgroundColor")
        }
    }
    
    @Published var textColor: Color {
        didSet {
            UserDefaults.standard.setColor(color: UIColor(textColor), forKey: "textColor")
        }
    }

    init() {
        let defaultBackgroundColor = UIColor(red: 0.98108989, green: 0.9316333532, blue: 0.8719255924, alpha: 1)
        self.backgroundColor = Color(UserDefaults.standard.colorForKey(key: "backgroundColor") ?? defaultBackgroundColor)
        self.textColor = Color(UserDefaults.standard.colorForKey(key: "textColor") ?? UIColor.black)
    }
}

extension UserDefaults {
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: Data?
        if let color = color {
            try? colorData = NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        }
        set(colorData, forKey: key)
    }

    func colorForKey(key: String) -> UIColor? {
        var colorRetrieved: UIColor?
        if let colorData = data(forKey: key) {
            colorRetrieved = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        }
        return colorRetrieved
    }
}
