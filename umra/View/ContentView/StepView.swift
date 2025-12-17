//
//  StepView.swift
//  umra
//
//  Created by Saydulayev on 19.02.25.
//

import SwiftUI

struct StepView: View {
    let imageName: String
    let titleKey: LocalizedStringKey
    let stringKey: String
    let index: Int?
    let fontSize: CGFloat
    let stepsCount: Int
    let hideLastIndex: Bool
    @Binding var imageDescriptions: [String: String]
    
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager

    private var accessibilityLabel: String {
        NSLocalizedString(imageDescriptions[imageName] ?? imageName, bundle: localizationManager.bundle ?? .main, comment: "")
    }

    /// Парсит строку локализации и разделяет на название и дату
    private var parsedTitle: (name: String, date: String?) {
        let fullText = NSLocalizedString(stringKey, bundle: localizationManager.bundle ?? .main, comment: "")
        // Пробуем разные варианты разделителей: длинное тире, обычное тире, дефис
        let separators = [" — ", " - ", " – ", " —", " — "]
        for separator in separators {
            let components = fullText.components(separatedBy: separator)
            if components.count == 2 {
                let date = components[0].trimmingCharacters(in: .whitespaces)
                let name = components[1].trimmingCharacters(in: .whitespaces)
                if !date.isEmpty && !name.isEmpty {
                    return (name: name, date: date)
                }
            }
        }
        return (name: fullText, date: nil)
    }
    
    var body: some View {
        VStack {
            if let index = index {
                Image(imageName)
                    .styledImageWithIndexAndTheme(index: index, stepsCount: stepsCount, theme: themeManager.selectedTheme, hideLastIndex: hideLastIndex)
                    .accessibilityLabel(accessibilityLabel)
            } else {
                Image(imageName)
                    .styledImageWithThemeColors(theme: themeManager.selectedTheme)
                    .accessibilityLabel(accessibilityLabel)
            }
            VStack(spacing: 4) {
                Text(parsedTitle.name)
                    .font(.custom("Lato-Black", size: fontSize))
                    .foregroundColor(themeManager.selectedTheme.textColor)
                    .multilineTextAlignment(.center)
                if let date = parsedTitle.date {
                    Text(date)
                        .font(.system(size: fontSize * 0.6, weight: .regular))
                        .foregroundStyle(themeManager.selectedTheme.textColor.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
            }
            Divider()
        }
    }
}
