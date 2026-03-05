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
        let fullText = NSLocalizedString(stringKey, bundle: localizationManager.bundle ?? .main, comment: "")
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
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var badgeDiameter: CGFloat {
        isIPad ? 80 : 60
    }
    
    private var badgeFontSize: CGFloat {
        let len = badgeText.count
        let base: CGFloat = isIPad ? 14 : 10
        if len > 6 { return base * 0.78 }
        if len > 4 { return base * 0.9 }
        return base
    }
    
    var body: some View {
        VStack(spacing: 6) {
            ZStack(alignment: .topTrailing) {
                ZStack {
                    Circle()
                        .fill(badgeColor.opacity(0.15))
                    Text(badgeText)
                        .font(.system(size: badgeFontSize, weight: .bold, design: .rounded))
                        .foregroundColor(badgeColor)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }
                .frame(width: badgeDiameter, height: badgeDiameter)
                .frame(maxWidth: .infinity)
                .padding(.vertical, isIPad ? 16 : 12)
                .background(
                    RoundedRectangle(cornerRadius: isIPad ? 24 : 20)
                        .fill(themeManager.selectedTheme.cardColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: isIPad ? 24 : 20)
                                .stroke(themeManager.selectedTheme.cardBorderColor, lineWidth: 1)
                        )
                        .shadow(color: themeManager.selectedTheme.cardShadowColor,
                                radius: 10, x: 0, y: 3)
                )
                
                if let index, !(hideLastIndex && index == stepsCount - 1) {
                    Text("\(index + 1)")
                        .font(.system(size: isIPad ? 14 : 11, weight: .bold))
                        .foregroundColor(themeManager.selectedTheme.textColor)
                        .padding(isIPad ? 9 : 7)
                        .background(
                            Circle()
                                .fill(themeManager.selectedTheme.cardColor)
                                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
                        )
                        .offset(x: isIPad ? -8 : -4, y: isIPad ? 8 : 4)
                }
            }
            
            VStack(spacing: 3) {
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
