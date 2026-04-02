//
//  DuaBookView.swift
//  umra
//

import SwiftUI

// MARK: - DuaBookView (категории)

struct DuaBookView: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager

    private var listPadding: CGFloat { AppConstants.isIPad ? 20 : 16 }
    private var cardCornerRadius: CGFloat { AppConstants.isIPad ? 28 : 24 }

    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(DuaBookData.categories.enumerated()), id: \.element.id) { idx, category in
                        NavigationLink(value: category) {
                            HStack(spacing: 14) {
                                Image(systemName: category.sfSymbol)
                                    .font(.title3.weight(.semibold))
                                    .foregroundStyle(themeManager.selectedTheme.primaryColor)
                                    .frame(width: 32)

                                Text(localizationManager.localized(category.titleKey))
                                    .font(fontManager.bodyFont)
                                    .foregroundStyle(themeManager.selectedTheme.textColor)

                                Spacer()

                                Text("\(category.duas.count)")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(themeManager.selectedTheme.textColor.opacity(0.4))

                                Image(systemName: "chevron.right")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(themeManager.selectedTheme.textColor.opacity(0.25))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .padding(.horizontal, listPadding)
                            .padding(.vertical, 16)
                        }
                        .buttonStyle(.plain)

                        if idx < DuaBookData.categories.count - 1 {
                            Divider()
                                .background(themeManager.selectedTheme.textColor.opacity(0.10))
                                .padding(.horizontal, listPadding)
                        }
                    }
                }
                .standardCardFrame(theme: themeManager.selectedTheme, cornerRadius: cardCornerRadius)
                .padding(.horizontal, listPadding)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle(localizationManager.localized("dua_book_nav_title"))
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(for: DuaCategory.self) { category in
            DuaCategoryView(category: category)
        }
        .navigationDestination(for: Dua.self) { dua in
            DuaDetailView(dua: dua)
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

// MARK: - DuaCategoryView (список дуа)

struct DuaCategoryView: View {
    let category: DuaCategory

    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager

    private var listPadding: CGFloat { AppConstants.isIPad ? 20 : 16 }
    private var cardCornerRadius: CGFloat { AppConstants.isIPad ? 28 : 24 }

    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(category.duas.enumerated()), id: \.element.id) { idx, dua in
                        NavigationLink(value: dua) {
                            HStack(spacing: 12) {
                                Text(dua.arabic)
                                    .font(.custom("KFGQPC Uthman Taha Naskh", size: 18))
                                    .foregroundStyle(themeManager.selectedTheme.primaryColor)
                                    .lineLimit(1)
                                    .frame(width: 80, alignment: .trailing)
                                    .environment(\.layoutDirection, .rightToLeft)

                                Text(localizationManager.localized(dua.titleKey))
                                    .font(fontManager.bodyFont)
                                    .foregroundStyle(themeManager.selectedTheme.textColor)
                                    .multilineTextAlignment(.leading)

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(themeManager.selectedTheme.textColor.opacity(0.25))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .padding(.horizontal, listPadding)
                            .padding(.vertical, 14)
                        }
                        .buttonStyle(.plain)

                        if idx < category.duas.count - 1 {
                            Divider()
                                .background(themeManager.selectedTheme.textColor.opacity(0.10))
                                .padding(.horizontal, listPadding)
                        }
                    }
                }
                .standardCardFrame(theme: themeManager.selectedTheme, cornerRadius: cardCornerRadius)
                .padding(.horizontal, listPadding)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle(localizationManager.localized(category.titleKey))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

// MARK: - DuaDetailView (арабский + транслитерация + перевод + аудио)

struct DuaDetailView: View {
    let dua: Dua

    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager

    private let contentPadding: CGFloat = 20

    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // Арабский текст
                    Text(dua.arabic)
                        .customTextforArabic()

                    // Аудио плеер
                    if let audioFile = dua.audioFile {
                        PlayerView(fileName: audioFile)
                            .padding(.horizontal, contentPadding)
                            .padding(.top, 16)
                    }

                    // Транслитерация
                    VStack(alignment: .leading, spacing: 6) {
                        Text(localizationManager.localized("dua_detail_translit_label"))
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(themeManager.selectedTheme.primaryColor)
                            .textCase(.uppercase)

                        Text(dua.transliteration)
                            .font(fontManager.bodyFont.italic())
                            .foregroundStyle(themeManager.selectedTheme.textColor.opacity(0.85))
                            .lineSpacing(4)
                            .textSelection(.enabled)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(contentPadding)
                    .standardCardFrame(theme: themeManager.selectedTheme, cornerRadius: 20)
                    .padding(.horizontal, contentPadding)
                    .padding(.top, 16)

                    // Перевод
                    VStack(alignment: .leading, spacing: 6) {
                        Text(localizationManager.localized("dua_detail_trans_label"))
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(themeManager.selectedTheme.primaryColor)
                            .textCase(.uppercase)

                        Text(localizationManager.localized(dua.translationKey))
                            .font(fontManager.bodyFont)
                            .foregroundStyle(themeManager.selectedTheme.textColor)
                            .lineSpacing(4)
                            .textSelection(.enabled)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(contentPadding)
                    .standardCardFrame(theme: themeManager.selectedTheme, cornerRadius: 20)
                    .padding(.horizontal, contentPadding)
                    .padding(.top, 16)

                    Spacer(minLength: 32)
                }
            }
        }
        .navigationTitle(localizationManager.localized(dua.titleKey))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}
