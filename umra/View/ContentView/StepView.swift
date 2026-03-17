//
//  StepView.swift
//  umra
//
//  Created by Saydulayev on 19.02.25.
//

import SwiftUI

struct StepView: View {
    let badgeText: String
    let badgeColor: Color
    let titleKey: LocalizedStringKey
    let stringKey: String
    let index: Int?
    let fontSize: CGFloat
    let stepsCount: Int
    let hideLastIndex: Bool
    
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager

    private var parsedTitle: (name: String, date: String?) {
        let fullText = localizationManager.localized(stringKey)
        let separators = [" — ", " - ", " – ", " —"]
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
    
    
    private var badgeDiameter: CGFloat {
        AppConstants.isIPad ? 80 : 60
    }
    
    private var badgeFontSize: CGFloat {
        let longestLine = badgeText.components(separatedBy: "\n").map(\.count).max() ?? 0
        let base: CGFloat = AppConstants.isIPad ? 14 : 10
        if longestLine > 6 { return base * 0.78 }
        if longestLine > 4 { return base * 0.9 }
        return base
    }
    
    var body: some View {
        VStack(spacing: 6) {
            ZStack(alignment: .topTrailing) {
                ZStack {
                    Circle()
                        .fill(badgeColor.opacity(0.15))
                    Text(badgeText)
                        .font(.system(size: badgeFontSize, design: .rounded))
                        .bold()
                        .foregroundStyle(badgeColor)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .frame(width: badgeDiameter, height: badgeDiameter)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppConstants.isIPad ? 16 : 12)
                .standardCardFrame(
                    theme: themeManager.selectedTheme,
                    cornerRadius: AppConstants.isIPad ? 24 : 20,
                    borderWidth: 1,
                    shadowRadius: 10,
                    shadowYOffset: 3
                )
                
                if let index, !(hideLastIndex && index == stepsCount - 1) {
                    Text("\(index + 1)")
                        .font(.caption.bold())
                        .foregroundStyle(themeManager.selectedTheme.textColor)
                        .padding(AppConstants.isIPad ? 9 : 7)
                        .background(
                            Circle()
                                .fill(themeManager.selectedTheme.cardColor)
                                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
                        )
                        .offset(x: AppConstants.isIPad ? -8 : -4, y: AppConstants.isIPad ? 8 : 4)
                }
            }
            
            VStack(spacing: 3) {
                Text(parsedTitle.name)
                    .font(.custom("Lato-Black", size: fontSize, relativeTo: .title2))
                    .foregroundStyle(themeManager.selectedTheme.textColor)
                    .multilineTextAlignment(.center)
                if let date = parsedTitle.date {
                    Text(date)
                        .font(.footnote)
                        .foregroundStyle(themeManager.selectedTheme.textColor.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
            }
            Divider()
        }
    }
}
