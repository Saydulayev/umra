//
//  LanguageSelectionView.swift
//  umra
//
//  Created by Saydulayev on 03.12.24.
//

import SwiftUI

struct LanguageSelectionView: View {
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))
                .ignoresSafeArea()

            VStack {

                // Мерцающий текст
                ShimmeringText()
                    .padding(.bottom, 20)
                Spacer()
                // Центр изображения
                Image("WelcomeImage")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300, maxHeight: 300)
                    .padding(.bottom, 40)

                Spacer() // Пушим кнопки вниз

                // Кнопки внизу
                VStack(spacing: 20) {
                    Button(action: {
                        selectLanguage("ru")
                    }) {
                        Text("Русский")
                            .buttonStyle()
                    }

                    Button(action: {
                        selectLanguage("en")
                    }) {
                        Text("English")
                            .buttonStyle()
                    }

                    Button(action: {
                        selectLanguage("fr")
                    }) {
                        Text("Français")
                            .buttonStyle()
                    }

                    Button(action: {
                        selectLanguage("de")
                    }) {
                        Text("Deutsch")
                            .buttonStyle()
                    }
                }
            }
            .padding(.vertical)
        }
    }

    private func selectLanguage(_ lang: String) {
        settings.lang = lang
        settings.hasSelectedLanguage = true
    }
}

extension Text {
    func buttonStyle() -> some View {
        self.foregroundColor(.black)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(2)
                })
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20)
            .padding(.horizontal)
    }
}

#Preview {
    LanguageSelectionView()
}
