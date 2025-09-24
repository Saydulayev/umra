//
//  UsefulInfoView.swift
//  umra
//
//  Created by Saydulayev on 17.09.24.
//

import SwiftUI

// Круглая стеклянная кнопка (для info)
private struct LiquidGlassCircle: ViewModifier {
    var diameter: CGFloat = 44
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: diameter * 0.45, weight: .semibold))
            .foregroundStyle(
                LinearGradient(
                    colors: [Color.white.opacity(0.95), Color.white.opacity(0.75)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: diameter, height: diameter)
            .background(.ultraThinMaterial, in: Circle())
            .overlay(
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.9), Color.white.opacity(0.25)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.10), radius: 10, x: 0, y: 8)
            .shadow(color: .white.opacity(0.35), radius: 1, x: -1, y: -1)
            .contentShape(Circle())
    }
}

extension View {
    func liquidGlassCircle(diameter: CGFloat = 44) -> some View {
        modifier(LiquidGlassCircle(diameter: diameter))
    }
}

// Стеклянные стили для элементов списка и карточек
extension View {
    func listItemGlassStyle(cornerRadius: CGFloat = 16) -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .glassContainer(cornerRadius: cornerRadius)
    }
    
    func cardGlassStyle(cornerRadius: CGFloat = 20) -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .glassContainer(cornerRadius: cornerRadius)
    }
}

// MARK: - UsefulInfoView
struct UsefulInfoView: View {
    @State private var isInfoPresented = false
    @EnvironmentObject var settings: UserSettings
    
    var chapters: [Chapter] {
        [
            Chapter(title: "etiquette_manners".localized(bundle: settings.bundle),
                    subChapters: [
                        SubChapter(title: "sincerity".localized(bundle: settings.bundle), content: EtiquetteManners.text1(bundle: settings.bundle)),
                        SubChapter(title: "laws".localized(bundle: settings.bundle), content: EtiquetteManners.text2(bundle: settings.bundle)),
                        SubChapter(title: "choice_of_companions".localized(bundle: settings.bundle), content: EtiquetteManners.text3(bundle: settings.bundle)),
                        SubChapter(title: "financial_independence".localized(bundle: settings.bundle), content: EtiquetteManners.text4(bundle: settings.bundle)),
                        SubChapter(title: "noble_manners".localized(bundle: settings.bundle), content: EtiquetteManners.text5(bundle: settings.bundle)),
                        SubChapter(title: "zikr_and_prayers".localized(bundle: settings.bundle), content: EtiquetteManners.text6(bundle: settings.bundle)),
                        SubChapter(title: "caution_in_relationships".localized(bundle: settings.bundle), content: EtiquetteManners.text7(bundle: settings.bundle)),
                    ]),
            Chapter(title: "hajj_umrah_virtues".localized(bundle: settings.bundle),
                    subChapters: [
                        SubChapter(title: "atonement_and_rewards".localized(bundle: settings.bundle), content: HajjUmrahVirtues.text1(bundle: settings.bundle)),
                        SubChapter(title: "hajj_for_women".localized(bundle: settings.bundle), content: HajjUmrahVirtues.text2(bundle: settings.bundle)),
                        SubChapter(title: "perfect_hajj".localized(bundle: settings.bundle), content: HajjUmrahVirtues.text3(bundle: settings.bundle)),
                        SubChapter(title: "following_the_sunnah".localized(bundle: settings.bundle), content: HajjUmrahVirtues.text4(bundle: settings.bundle)),
                    ]),
            Chapter(title: "hajj_umrah_obligation".localized(bundle: settings.bundle),
                    subChapters: [
                        SubChapter(title: "hajj_obligation_evidence".localized(bundle: settings.bundle), content: HajjUmrahObligation.obligationEvidence(bundle: settings.bundle)),
                        SubChapter(title: "umrah_obligation_evidence".localized(bundle: settings.bundle), content: HajjUmrahObligation.evidenceUmrahObligation(bundle: settings.bundle)),
                        SubChapter(title: "conclusion".localized(bundle: settings.bundle), content: HajjUmrahObligation.concludingEvidence(bundle: settings.bundle)),
                    ]),
            Chapter(title: "title_janaza_guide".localized(bundle: settings.bundle),
                    subChapters: [
                        SubChapter(title: "basic_rules".localized(bundle: settings.bundle),
                                   content: JanazaPrayerGuide.basicRules(bundle: settings.bundle)),
                    ])
        ]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)),
                        Color(#colorLiteral(red: 0.835, green: 0.88, blue: 0.98, alpha: 1))
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(chapters) { chapter in
                            if chapter.title == "title_janaza_guide".localized(bundle: settings.bundle) {
                                NavigationLink(destination: JanazaView()) {
                                    HStack {
                                        Text(chapter.title)
                                            .font(.system(size: getDynamicFontSize()))
                                            .foregroundStyle(.primary)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.blue)
                                    }
                                    .listItemGlassStyle()
                                }
                                .buttonStyle(PlainButtonStyle())
                            } else {
                                NavigationLink(destination: ChapterDetailView(chapter: chapter)) {
                                    HStack {
                                        Text(chapter.title)
                                            .font(.system(size: getDynamicFontSize()))
                                            .foregroundStyle(.primary)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.blue)
                                    }
                                    .listItemGlassStyle()
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }
                .navigationTitle("useful_info_title".localized(bundle: settings.bundle))
                .navigationBarTitleDisplayMode(.inline)
                
                // Стеклянная кнопка info
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            isInfoPresented.toggle()
                        }) {
                            Image(systemName: "info")
                                .liquidGlassCircle(diameter: 44)
                                .accessibilityLabel(Text("Info", bundle: settings.bundle))
                        }
                        .popover(isPresented: $isInfoPresented, attachmentAnchor: .rect(.bounds), arrowEdge: .bottom) {
                            VStack {
                                Text("soon_available_text".localized(bundle: settings.bundle))
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(width: 320, height: 180)
                            .cardGlassStyle(cornerRadius: 18)
                            .padding()
                            .presentationCompactAdaptation(.popover)
                        }
                        .padding()
                    }
                }
            }
        }
    }
}


struct CustomDisclosureGroupStyle: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 8) {
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
                .contentShape(Rectangle())
            }
            if configuration.isExpanded {
                configuration.content
            }
        }
        .padding(.vertical, 6)
    }
}

struct JanazaView: View {
    @EnvironmentObject var settings: UserSettings
    @State private var isDuaExpanded = false
    @State private var isSecondTakbirExpanded = false
    @State private var isThirdTakbirExpanded = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)),
                    Color(#colorLiteral(red: 0.835, green: 0.88, blue: 0.98, alpha: 1))
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Group {
                        Text(JanazaPrayerGuide.janazaBasicRules(bundle: settings.bundle))
                            .fontWeight(.bold)
                        Divider()

                        Text(JanazaPrayerGuide.firstTakbirTitle(bundle: settings.bundle))
                            .fontWeight(.bold)
                        Text(JanazaPrayerGuide.firstTakbirText(bundle: settings.bundle))
                            .padding(.bottom)
                        Divider()
                        Text(JanazaPrayerGuide.secondTakbirTitle(bundle: settings.bundle))
                            .fontWeight(.bold)
                        Text(JanazaPrayerGuide.secondTakbirText(bundle: settings.bundle))
                            .padding(.bottom)
                        DisclosureGroup(
                            isExpanded: $isDuaExpanded,
                            content: {
                                Text(JanazaPrayerGuide.translateSecondTakbirText(bundle: settings.bundle))
                                    .padding(.vertical)
                            },
                            label: {
                                Text("translate_text", bundle: settings.bundle)
                                    .font(.headline)
                                    .foregroundStyle(.blue)
                            }
                        )
                        .disclosureGroupStyle(CustomDisclosureGroupStyle())
                    }

                    Divider()

                    Group {
                        Text(JanazaPrayerGuide.thirdTakbirTitle(bundle: settings.bundle))
                            .fontWeight(.bold)
                        Text(JanazaPrayerGuide.thirdTakbirText(bundle: settings.bundle))
                            .padding(.bottom)
                        
                        DisclosureGroup(
                            isExpanded: $isThirdTakbirExpanded,
                            content: {
                                Text(JanazaPrayerGuide.translateThirdTakbirText(bundle: settings.bundle))
                                    .padding(.vertical)
                            },
                            label: {
                                Text("translate_text", bundle: settings.bundle)
                                    .font(.headline)
                                    .foregroundStyle(.blue)
                            }
                        )
                        .disclosureGroupStyle(CustomDisclosureGroupStyle())
                    }

                    Divider()

                    Group {
                        Text(JanazaPrayerGuide.fourthTakbirTitle(bundle: settings.bundle))
                            .fontWeight(.bold)
                        Text(JanazaPrayerGuide.fourthTakbirText(bundle: settings.bundle))
                        Text(JanazaPrayerGuide.fourthTakbirAdditionalInfo(bundle: settings.bundle))
                            .padding(.bottom)
                        Divider()
                        Text(JanazaPrayerGuide.taslimTitle(bundle: settings.bundle))
                            .fontWeight(.bold)
                        Text(JanazaPrayerGuide.taslimText(bundle: settings.bundle))
                    }
                    Divider()
                    
                    DisclosureGroup(
                        isExpanded: $isSecondTakbirExpanded,
                        content: {
                            Text(JanazaPrayerGuide.duaVariationsText(bundle: settings.bundle))
                                .padding(.vertical)
                        },
                        label: {
                            Text(JanazaPrayerGuide.duaVariationsTitle(bundle: settings.bundle))
                                .fontWeight(.bold)
                        }
                    )
                    .disclosureGroupStyle(CustomDisclosureGroupStyle())
                }
                .padding()
                .font(.system(size: getDynamicFontSize()))
                .foregroundStyle(.primary)
                .textSelection(.enabled)
                .cardGlassStyle(cornerRadius: 22)
                .padding()
            }
            .navigationTitle(JanazaPrayerGuide.title(bundle: settings.bundle))
        }
    }
}

struct ChapterDetailView: View {
    let chapter: Chapter
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)),
                        Color(#colorLiteral(red: 0.835, green: 0.88, blue: 0.98, alpha: 1))
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(chapter.subChapters) { subChapter in
                            NavigationLink(destination: SubChapterDetailView(subChapter: subChapter)) {
                                HStack {
                                    Text(subChapter.title)
                                        .font(.system(size: getDynamicFontSize()))
                                        .foregroundStyle(.primary)
                                        .textSelection(.enabled)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.blue)
                                }
                                .listItemGlassStyle()
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }
                .navigationTitle(chapter.title)
            }
        }
    }
}

struct SubChapterDetailView: View {
    let subChapter: SubChapter
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)),
                    Color(#colorLiteral(red: 0.835, green: 0.88, blue: 0.98, alpha: 1))
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            ScrollView {
                Text(subChapter.content)
                    .font(.system(size: getDynamicFontSize()))
                    .foregroundStyle(.primary)
                    .padding()
                    .textSelection(.enabled)
                    .cardGlassStyle(cornerRadius: 22)
                    .padding()
            }
            .navigationTitle(subChapter.title)
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
