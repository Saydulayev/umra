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
    
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var fontManager: FontManager

    private var accessibilityLabel: String {
        NSLocalizedString(imageDescriptions[imageName] ?? imageName, bundle: settings.bundle ?? .main, comment: "")
    }

    var body: some View {
        VStack {
            NavigationLink(destination: destinationView) {
                if let index = index {
                    Image(imageName)
                        .styledImageWithIndexAndTheme(index: index, stepsCount: stepsCount, theme: settings.selectedTheme)
                        .accessibilityLabel(accessibilityLabel)
                } else {
                    Image(imageName)
                        .styledImageWithThemeColors(theme: settings.selectedTheme)
                        .accessibilityLabel(accessibilityLabel)
                }
            }
            Text(titleKey, bundle: settings.bundle)
                .font(.custom("Lato-Black", size: fontSize))
                .multilineTextAlignment(.center)
            Divider()
        }
    }
}
