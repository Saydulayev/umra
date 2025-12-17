//
//  UsefulInfoView.swift
//  umra
//
//  Created by Saydulayev on 17.09.24.
//

import SwiftUI


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
            Chapter(title: "title_janaza_guide".localized(bundle: localizationManager.bundle),
                    subChapters: [
                        SubChapter(title: "basic_rules".localized(bundle: localizationManager.bundle),
                                 content: JanazaPrayerGuide.basicRules(bundle: localizationManager.bundle)),
                    ])
        ]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.selectedTheme.backgroundColor
                    .ignoresSafeArea(edges: .bottom)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(chapters) { chapter in
                            if chapter.title == "title_janaza_guide".localized(bundle: localizationManager.bundle) {
                                NavigationLink(destination: JanazaView()) {
                                    HStack {
                                        Text(chapter.title)
                                            .font(.system(size: getDynamicFontSize()))
                                            .foregroundStyle(themeManager.selectedTheme.textColor)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.blue)
                                    }
                                    .customListItemStyle(theme: themeManager.selectedTheme)
                                }
                                .buttonStyle(PlainButtonStyle())
                            } else {
                                NavigationLink(destination: ChapterDetailView(chapter: chapter)) {
                                    HStack {
                                        Text(chapter.title)
                                            .font(.system(size: getDynamicFontSize()))
                                            .foregroundStyle(themeManager.selectedTheme.textColor)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.blue)
                                    }
                                    .customListItemStyle(theme: themeManager.selectedTheme)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            Divider()
                        }
                    }
                }
                .navigationTitle("useful_info_title".localized(bundle: localizationManager.bundle))
                .navigationBarTitleDisplayMode(.inline)
                
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
                                .foregroundColor(.blue)
                        }
                        .popover(isPresented: $isInfoPresented, attachmentAnchor: .rect(.bounds), arrowEdge: .bottom) {
                            VStack {
                                Text("soon_available_text".localized(bundle: localizationManager.bundle))
                                    .font(.body)
                                    .padding()
                                    .multilineTextAlignment(.center)
                                    .frame(width: 350, height: 150)
                            }
                            .frame(width: 350, height: 200)
                            .presentationCompactAdaptation(.popover)
                        }
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
        }
    }
}


struct CustomDisclosureGroupStyle: DisclosureGroupStyle {
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
                        .foregroundStyle(.blue)
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

    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea(edges: .bottom)

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
                                    .foregroundStyle(.blue)
                            }
                        )
                        .disclosureGroupStyle(CustomDisclosureGroupStyle())
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
                                    .foregroundStyle(.blue)
                            }
                        )
                        .disclosureGroupStyle(CustomDisclosureGroupStyle())
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
                    .disclosureGroupStyle(CustomDisclosureGroupStyle())
                }
                .padding()
                .font(.system(size: getDynamicFontSize()))
                .foregroundStyle(themeManager.selectedTheme.textColor)
                .textSelection(.enabled)
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
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.selectedTheme.backgroundColor
                    .ignoresSafeArea(edges: .bottom)
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(chapter.subChapters) { subChapter in
                            NavigationLink(destination: SubChapterDetailView(subChapter: subChapter)) {
                                HStack {
                                    Text(subChapter.title)
                                        .font(.system(size: getDynamicFontSize()))
                                        .foregroundStyle(themeManager.selectedTheme.textColor)
                                        .textSelection(.enabled)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.blue)
                                }
                                .customListItemStyle(theme: themeManager.selectedTheme)
                            }
                            .buttonStyle(PlainButtonStyle())
                            Divider()
                        }
                    }
                }
                .navigationTitle(chapter.title)
                .toolbar(.hidden, for: .tabBar)
            }
        }
    }
}

struct SubChapterDetailView: View {
    let subChapter: SubChapter
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    
    var body: some View {
        ZStack {
            themeManager.selectedTheme.backgroundColor
                .ignoresSafeArea(edges: .bottom)
            ScrollView {
                Text(subChapter.content)
                    .font(.system(size: getDynamicFontSize()))
                    .foregroundStyle(themeManager.selectedTheme.textColor)
                    .padding()
                    .textSelection(.enabled)
            }
            .navigationTitle(subChapter.title)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

func getDynamicFontSize(forPad: CGFloat = 30, forPhone: CGFloat = 20) -> CGFloat {
    UIDevice.current.userInterfaceIdiom == .pad ? forPad : forPhone
}

struct Chapter: Identifiable {
    let id = UUID()
    let title: String
    let subChapters: [SubChapter]
}

struct SubChapter: Identifiable {
    let id = UUID()
    let title: String
    let content: String
}

#Preview {
    UsefulInfoView()
}

extension View {
    func customListItemStyle(theme: AppTheme) -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    theme.primaryColor.opacity(0.1)
                    
                    Rectangle()
                        .foregroundColor(.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [theme.gradientTopColor, theme.gradientBottomColor]), startPoint: .topLeading, endPoint: .bottomLeading))
                })
            .overlay(
                // Профессиональная темная обводка для лучшего разделения
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 20, y: 20)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
