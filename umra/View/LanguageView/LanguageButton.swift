//
//  LanguageButton.swift
//  umra
//
//  Created by Saydulayev on 03.12.24.
//

import SwiftUI

struct LanguageButton: View {
    let language: Language
    let theme: AppTheme
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(language.title)
                .font(.body)
                .fontWeight(.medium)
                .minimumScaleFactor(0.75)
                .foregroundStyle(theme.textColor)
                .padding(.vertical, 16)
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity)
                .standardCardFrame(theme: theme, cornerRadius: 20, shadowRadius: 12, shadowYOffset: 4)
                .padding(.horizontal)
        }
    }
}
