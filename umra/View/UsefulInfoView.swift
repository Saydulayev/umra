//
//  UsefulInfoView.swift
//  umra
//
//  Created by Saydulayev on 17.09.24.
//

import SwiftUI

/// Синий акцент раздела «Полезное» — лучше ассоциируется с меню
private let usefulInfoAccentBlue = Color(red: 0.29, green: 0.51, blue: 0.78)

// MARK: - UsefulInfoView
struct UsefulInfoView: View {
    @State private var isInfoPresented = false
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    
    var chapters: [Chapter] {
        [
            Chapter(title: "etiquette_manners".localized(bundle: localizationManager.bundle),
                    subChapters: [
                        SubChapter(title: "sincerity".localized(bundle: localizationManager.bundle), content: EtiquetteManners.text1(bundle: localizationManager.bundle)),
                        SubChapter(title: "laws".localized(bundle: localizationManager.bundle), content: EtiquetteManners.text2(bundle: localizationManager.bundle)),
                        SubChapter(title: "choice_of_companions".localized(bundle: localizationManager.bundle), content: EtiquetteManners.text3(bundle: localizationManager.bundle)),
                        SubChapter(title: "financial_independence".localized(bundle: localizationManager.bundle), content: EtiquetteManners.text4(bundle: localizationManager.bundle)),
                        SubChapter(title: "noble_manners".localized(bundle: localizationManager.bundle), content: EtiquetteManners.text5(bundle: localizationManager.bundle)),
                        SubChapter(title: "zikr_and_prayers".localized(bundle: localizationManager.bundle), content: EtiquetteManners.text6(bundle: localizationManager.bundle)),
                        SubChapter(title: "caution_in_relationships".localized(bundle: localizationManager.bundle), content: EtiquetteManners.text7(bundle: localizationManager.bundle)),
                    ]),
            Chapter(title: "hajj_umrah_virtues".localized(bundle: localizationManager.bundle),
                    subChapters: [
                        SubChapter(title: "atonement_and_rewards".localized(bundle: localizationManager.bundle), content: HajjUmrahVirtues.text1(bundle: localizationManager.bundle)),
                        SubChapter(title: "hajj_for_women".localized(bundle: localizationManager.bundle), content: HajjUmrahVirtues.text2(bundle: localizationManager.bundle)),
                        SubChapter(title: "perfect_hajj".localized(bundle: localizationManager.bundle), content: HajjUmrahVirtues.text3(bundle: localizationManager.bundle)),
                        SubChapter(title: "following_the_sunnah".localized(bundle: localizationManager.bundle), content: HajjUmrahVirtues.text4(bundle: localizationManager.bundle)),
                    ]),
            Chapter(title: "hajj_umrah_obligation".localized(bundle: localizationManager.bundle),
                    subChapters: [
                        SubChapter(title: "hajj_obligation_evidence".localized(bundle: localizationManager.bundle), content: HajjUmrahObligation.obligationEvidence(bundle: localizationManager.bundle)),
                        SubChapter(title: "umrah_obligation_evidence".localized(bundle: localizationManager.bundle), content: HajjUmrahObligation.evidenceUmrahObligation(bundle: localizationManager.bundle)),
                        SubChapter(title: "conclusion".localized(bundle: localizationManager.bundle), content: HajjUmrahObligation.concludingEvidence(bundle: localizationManager.bundle)),
                    ]),
            Chapter(title: "sunnahs_safar".localized(bundle: localizationManager.bundle),
                    subChapters: []),
            Chapter(title: "title_janaza_guide".localized(bundle: localizationManager.bundle),
                    subChapters: [
                        SubChapter(title: "basic_rules".localized(bundle: localizationManager.bundle),
                                 content: JanazaPrayerGuide.basicRules(bundle: localizationManager.bundle)),
                    ])
        ]
    }
    
    private var listPadding: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16
    }

    private var listCardCornerRadius: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 28 : 24
    }
    
    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(chapters.enumerated()), id: \.element.id) { idx, chapter in
                        NavigationLink(value: chapter) {
                            HStack {
                                Text(chapter.title)
                                    .font(.system(size: getDynamicFontSize()))
                                    .foregroundStyle(themeManager.selectedTheme.textColor)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(usefulInfoAccentBlue.opacity(0.9))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .padding(.horizontal, listPadding)
                            .padding(.vertical, 16)
                        }
                        .buttonStyle(.plain)
                        
                        if idx < chapters.count - 1 {
                            Divider()
                                .background(themeManager.selectedTheme.textColor.opacity(0.10))
                                .padding(.leading, listPadding)
                        }
                    }
                }
                .standardCardFrame(theme: themeManager.selectedTheme, cornerRadius: listCardCornerRadius)
                .padding(.horizontal, listPadding)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isInfoPresented.toggle()
                    }) {
                        Image(systemName: "info.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                            .foregroundStyle(usefulInfoAccentBlue)
                    }
                    .popover(isPresented: $isInfoPresented, attachmentAnchor: .rect(.bounds), arrowEdge: .bottom) {
                        VStack {
                            Text("soon_available_text".localized(bundle: localizationManager.bundle))
                                .font(.body)
                                .padding()
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: 350)
                        .presentationCompactAdaptation(.popover)
                    }
                }
            }
        }
        .navigationTitle("useful_info_title".localized(bundle: localizationManager.bundle))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}


struct CustomDisclosureGroupStyle: DisclosureGroupStyle {
    var accentColor: Color = Color(red: 0.063, green: 0.725, blue: 0.506)
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            Button(action: {
                withAnimation {
                    configuration.isExpanded.toggle()
                }
            }) {
                HStack {
                    configuration.label
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundStyle(accentColor)
                        .rotationEffect(.degrees(configuration.isExpanded ? 180 : 0))
                }
            }
            if configuration.isExpanded {
                configuration.content
            }
        }
    }
}

struct JanazaView: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @State private var isDuaExpanded = false
    @State private var isSecondTakbirExpanded = false
    @State private var isThirdTakbirExpanded = false

    private var contentPadding: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16
    }
    
    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        Text(JanazaPrayerGuide.janazaBasicRules(bundle: localizationManager.bundle))
                            .fontWeight(.bold)
                        Divider()

                        Text(JanazaPrayerGuide.firstTakbirTitle(bundle: localizationManager.bundle))
                            .fontWeight(.bold)
                        Text(JanazaPrayerGuide.firstTakbirText(bundle: localizationManager.bundle))
                            .padding(.bottom)
                        Divider()
                        Text(JanazaPrayerGuide.secondTakbirTitle(bundle: localizationManager.bundle))
                            .fontWeight(.bold)
                        Text(JanazaPrayerGuide.secondTakbirText(bundle: localizationManager.bundle))
                            .padding(.bottom)
                        DisclosureGroup(
                            isExpanded: $isDuaExpanded,
                            content: {
                                Text(JanazaPrayerGuide.translateSecondTakbirText(bundle: localizationManager.bundle))
                                    .padding(.vertical)
                            },
                            label: {
                                Text("translate_text", bundle: localizationManager.bundle)            .font(.headline)
                                    .foregroundStyle(usefulInfoAccentBlue)
                            }
                        )
                        .disclosureGroupStyle(CustomDisclosureGroupStyle(accentColor: usefulInfoAccentBlue))
                    }

                    Divider()

                    Group {
                        Text(JanazaPrayerGuide.thirdTakbirTitle(bundle: localizationManager.bundle))
                            .fontWeight(.bold)
                        Text(JanazaPrayerGuide.thirdTakbirText(bundle: localizationManager.bundle))
                            .padding(.bottom)
                        
                        DisclosureGroup(
                            isExpanded: $isThirdTakbirExpanded,
                            content: {
                                Text(JanazaPrayerGuide.translateThirdTakbirText(bundle: localizationManager.bundle))
                                    .padding(.vertical)
                            },
                            label: {
                                Text("translate_text", bundle: localizationManager.bundle)            .font(.headline)
                                    .foregroundStyle(usefulInfoAccentBlue)
                            }
                        )
                        .disclosureGroupStyle(CustomDisclosureGroupStyle(accentColor: usefulInfoAccentBlue))
                    }

                    Divider()

                    Group {
                        Text(JanazaPrayerGuide.fourthTakbirTitle(bundle: localizationManager.bundle))
                            .fontWeight(.bold)
                        Text(JanazaPrayerGuide.fourthTakbirText(bundle: localizationManager.bundle))
                        Text(JanazaPrayerGuide.fourthTakbirAdditionalInfo(bundle: localizationManager.bundle))
                            .padding(.bottom)
                        Divider()
                        Text(JanazaPrayerGuide.taslimTitle(bundle: localizationManager.bundle))
                            .fontWeight(.bold)
                        Text(JanazaPrayerGuide.taslimText(bundle: localizationManager.bundle))
                    }
                    Divider()
                    
                    DisclosureGroup(
                        isExpanded: $isSecondTakbirExpanded,
                        content: {
                            Text(JanazaPrayerGuide.duaVariationsText(bundle: localizationManager.bundle))
                                .padding(.vertical)
                        },
                        label: {
                            Text(JanazaPrayerGuide.duaVariationsTitle(bundle: localizationManager.bundle))
                                .fontWeight(.bold)
                        }
                    )
                    .disclosureGroupStyle(CustomDisclosureGroupStyle(accentColor: usefulInfoAccentBlue))
                }
                .padding(contentPadding)
                .font(.system(size: getDynamicFontSize()))
                .foregroundStyle(themeManager.selectedTheme.textColor)
                .textSelection(.enabled)
                .padding(.bottom, 32)
            }
            .navigationTitle(JanazaPrayerGuide.title(bundle: localizationManager.bundle))
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

struct ChapterDetailView: View {
    let chapter: Chapter
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    
    private var listPadding: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16
    }

    private var listCardCornerRadius: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 28 : 24
    }
    
    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(chapter.subChapters.enumerated()), id: \.element.id) { idx, subChapter in
                        NavigationLink(value: subChapter) {
                            HStack {
                                Text(subChapter.title)
                                    .font(.system(size: getDynamicFontSize()))
                                    .foregroundStyle(themeManager.selectedTheme.textColor)
                                    .textSelection(.enabled)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(usefulInfoAccentBlue.opacity(0.9))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .padding(.horizontal, listPadding)
                            .padding(.vertical, 16)
                        }
                        .buttonStyle(.plain)
                        
                        if idx < chapter.subChapters.count - 1 {
                            Divider()
                                .background(themeManager.selectedTheme.textColor.opacity(0.10))
                                .padding(.leading, listPadding)
                        }
                    }
                }
                .standardCardFrame(theme: themeManager.selectedTheme, cornerRadius: listCardCornerRadius)
                .padding(.horizontal, listPadding)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle(chapter.title)
        .toolbar(.hidden, for: .tabBar)
    }
}

// MARK: - Formatted content (заголовки зелёные и жирные, цитаты «...» жирные)
private struct FormattedContentBlock {
    enum Style {
        case heading(String)
        case body(String)
    }
    let style: Style
}

private func parseFormattedContent(_ content: String) -> [FormattedContentBlock] {
    let blocks = content.components(separatedBy: "\n\n")
    var result: [FormattedContentBlock] = []
    let headingPattern = try? NSRegularExpression(pattern: "^\\d+\\)", options: [])
    
    for block in blocks {
        let trimmed = block.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { continue }
        let lines = trimmed.components(separatedBy: "\n")
        let firstLine = lines.first ?? trimmed
        
        let isHeading = headingPattern?.firstMatch(in: firstLine, range: NSRange(firstLine.startIndex..., in: firstLine)) != nil
        if isHeading && !lines.isEmpty {
            result.append(FormattedContentBlock(style: .heading(firstLine)))
            let rest = lines.dropFirst()
            if !rest.isEmpty {
                result.append(FormattedContentBlock(style: .body(rest.joined(separator: "\n"))))
            }
        } else {
            result.append(FormattedContentBlock(style: .body(trimmed)))
        }
    }
    return result
}

private func containsArabic(_ string: String) -> Bool {
    string.unicodeScalars.contains { scalar in
        (0x0600...0x06FF).contains(scalar.value) || (0x0750...0x077F).contains(scalar.value)
    }
}

@ViewBuilder
private func bodyParagraphView(paragraph: String, fontSize: CGFloat, textColor: Color) -> some View {
    let lines = paragraph.components(separatedBy: "\n")
    VStack(alignment: .leading, spacing: 6) {
        ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
            let lineContent = textWithBoldQuotes(line, fontSize: fontSize, textColor: textColor)
                .font(containsArabic(line) ? .custom("KFGQPC Uthman Taha Naskh", size: fontSize) : .system(size: fontSize))
                .textSelection(.enabled)
                .fixedSize(horizontal: false, vertical: true)
            if containsArabic(line) {
                lineContent
                    .padding(.vertical, 10)
            } else {
                lineContent
            }
        }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
}

private func textWithBoldQuotes(_ paragraph: String, fontSize: CGFloat, textColor: Color) -> Text {
    var attributed = AttributedString()
    let parts = paragraph.components(separatedBy: "«")
    for (index, part) in parts.enumerated() {
        if index == 0 {
            var segment = AttributedString(part)
            segment.foregroundColor = textColor
            attributed.append(segment)
            continue
        }
        let subParts = part.components(separatedBy: "»")
        if subParts.count >= 2 {
            var quoteSegment = AttributedString("«\(subParts[0])»")
            quoteSegment.foregroundColor = textColor
            quoteSegment.font = .system(size: fontSize, weight: .semibold)
            attributed.append(quoteSegment)
            var rest = AttributedString(subParts.dropFirst().joined(separator: "»"))
            rest.foregroundColor = textColor
            attributed.append(rest)
        } else {
            var segment = AttributedString("«\(part)")
            segment.foregroundColor = textColor
            attributed.append(segment)
        }
    }
    return Text(attributed)
}

private struct FormattedContentView: View {
    let content: String
    @Environment(ThemeManager.self) private var themeManager
    
    private var headingColor: Color {
        usefulInfoAccentBlue
    }
    
    var body: some View {
        let blocks = parseFormattedContent(content)
        let fontSize = getDynamicFontSize()
        let textColor = themeManager.selectedTheme.textColor
        
        VStack(alignment: .leading, spacing: 14) {
            ForEach(Array(blocks.enumerated()), id: \.offset) { _, block in
                switch block.style {
                case FormattedContentBlock.Style.heading(let text):
                    Text(text)
                        .font(.system(size: fontSize + 1, weight: .bold))
                        .foregroundStyle(headingColor)
                        .textSelection(.enabled)
                        .fixedSize(horizontal: false, vertical: true)
                case FormattedContentBlock.Style.body(let paragraph):
                    bodyParagraphView(paragraph: paragraph, fontSize: fontSize, textColor: textColor)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Контент раздела «Путешествие» — текст сразу внутри раздела, без подглавы
struct JourneyContentView: View {
    let chapter: Chapter
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    
    private var contentPadding: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16
    }
    
    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea()
            ScrollView {
                FormattedContentView(content: SafarSunnahs.content(bundle: localizationManager.bundle))
                    .padding(contentPadding)
                    .padding(.bottom, 32)
            }
            .navigationTitle(chapter.title)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

struct SubChapterDetailView: View {
    let subChapter: SubChapter
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    
    private var useFormattedContent: Bool {
        subChapter.content.contains("1) ") || subChapter.content.hasPrefix("1)")
    }
    
    private var contentPadding: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16
    }
    
    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea()
            ScrollView {
                Group {
                    if useFormattedContent {
                        FormattedContentView(content: subChapter.content)
                    } else {
                        Text(subChapter.content)
                            .font(.system(size: getDynamicFontSize()))
                            .foregroundStyle(themeManager.selectedTheme.textColor)
                            .textSelection(.enabled)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(contentPadding)
                .padding(.bottom, 32)
            }
            .navigationTitle(subChapter.title)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

func getDynamicFontSize(forPad: CGFloat = 30, forPhone: CGFloat = 20) -> CGFloat {
    UIDevice.current.userInterfaceIdiom == .pad ? forPad : forPhone
}

struct Chapter: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let subChapters: [SubChapter]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Chapter, rhs: Chapter) -> Bool {
        lhs.id == rhs.id
    }
}

struct SubChapter: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let content: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: SubChapter, rhs: SubChapter) -> Bool {
        lhs.id == rhs.id
    }
}

#Preview {
    UsefulInfoView()
}

extension View {
    func customListItemStyle(theme: AppTheme) -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .standardCardFrame(theme: theme, cornerRadius: 8)
    }
}
