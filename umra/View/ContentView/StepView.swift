//
//  StepView.swift
//  umra
//
//  Created by Saydulayev on 19.02.25.
//

import SwiftUI

struct StepView<Destination: View>: View {
    let imageName: String
    let destinationView: Destination
    let titleKey: LocalizedStringKey
    let index: Int?
    let fontSize: CGFloat
    let stepsCount: Int
    @Binding var imageDescriptions: [String: String]
    
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager

    private var accessibilityLabel: String {
        NSLocalizedString(imageDescriptions[imageName] ?? imageName, bundle: localizationManager.bundle ?? .main, comment: "")
    }

    var body: some View {
        VStack {
            NavigationLink(destination: destinationView) {
                if let index = index {
                    Image(imageName)
                        .styledImageWithIndexAndTheme(index: index, stepsCount: stepsCount, theme: themeManager.selectedTheme)
                        .accessibilityLabel(accessibilityLabel)
                } else {
                    Image(imageName)
                        .styledImageWithThemeColors(theme: themeManager.selectedTheme)
                        .accessibilityLabel(accessibilityLabel)
                }
            }
            Text(titleKey, bundle: localizationManager.bundle)
                .font(.custom("Lato-Black", size: fontSize))
                .multilineTextAlignment(.center)
            Divider()
        }
    }
}
