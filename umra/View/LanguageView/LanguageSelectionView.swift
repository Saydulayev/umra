//
//  LanguageSelectionView.swift
//  umra
//
//  Created by Saydulayev on 03.12.24.
//

import SwiftUI

struct Language: Identifiable {
    let code: String
    let title: String
    var id: String { code }
}

let languages: [Language] = [
    .init(code: "de", title: "Deutsch"),
    .init(code: "en", title: "English"),
    .init(code: "fr", title: "Français"),
    .init(code: "ru", title: "Русский"),
    .init(code: "tr", title: "Türkçe"),
    .init(code: "id", title: "Bahasa Indonesia"),
    // Добавляйте новые языки сюда
]

struct LanguageSelectionView: View {
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))
                    .ignoresSafeArea()
                
                VStack {
                    ShimmeringText()
                        .font(.largeTitle)
                        .minimumScaleFactor(0.7)
                        .padding(.bottom, geo.size.height * 0.02)
                    
                    Spacer(minLength: geo.size.height * 0.03)
                    
                    Image("WelcomeImage")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            maxWidth: min(geo.size.width * 0.7, 400),
                            maxHeight: min(geo.size.height * 0.25, 400)
                        )
                        .padding(.bottom, geo.size.height * 0.05)
                    
                    Spacer(minLength: geo.size.height * 0.02)
                    
                    // Подсчитываем высоту кнопки + отступы
                    let buttonFontSize = geo.size.height * 0.025
                    let buttonVerticalPadding: CGFloat = 16
                    let buttonSpacing = geo.size.height * 0.015
                    let buttonFullHeight = buttonFontSize + buttonVerticalPadding * 2 + buttonSpacing
                    let maxListHeight = geo.size.height * 0.36
                    let maxVisibleButtons = Int(maxListHeight / buttonFullHeight)
                    let needChevron = languages.count > maxVisibleButtons

                    ZStack(alignment: .bottom) {
                        ScrollView {
                            VStack(spacing: buttonSpacing) {
                                ForEach(languages) { lang in
                                    Button(action: { selectLanguage(lang.code) }) {
                                        Text(lang.title)
                                            .buttonStyle(fontSize: buttonFontSize)
                                    }
                                }
                            }
                            .padding(.bottom)
                        }
                        .scrollIndicators(.hidden)
                        .frame(maxHeight: maxListHeight)
                    }

                    if needChevron {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                            .font(.system(size: geo.size.height * 0.025))
                            .padding(.top, 4)
                            .padding(.bottom, geo.size.height * 0.01)
                            .transition(.opacity)
                            .animation(.easeInOut, value: needChevron)
                    }
                }
                .padding(.horizontal, geo.size.width > 500 ? 64 : 16)
                .padding(.top, geo.size.height > 800 ? 48 : 16)
                .padding(.bottom, geo.size.height > 800 ? 32 : 12)
            }
        }
    }

    private func selectLanguage(_ lang: String) {
        settings.lang = lang
        settings.hasSelectedLanguage = true
    }
}

extension Text {
    func buttonStyle(fontSize: CGFloat = 18) -> some View {
        self.font(.system(size: fontSize, weight: .medium))
            .minimumScaleFactor(0.75)
            .foregroundColor(.black)
            .padding(.vertical, 16)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)),
                                    Color.white
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .padding(2)
                })
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal)
    }
}

#Preview {
    LanguageSelectionView()
        .environmentObject(UserSettings())
}



