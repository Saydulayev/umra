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
                Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))
                    .ignoresSafeArea(edges: .bottom)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(chapters) { chapter in
                            if chapter.title == "title_janaza_guide".localized(bundle: settings.bundle) {
                                NavigationLink(destination: JanazaView()) {
                                    HStack {
                                        Text(chapter.title)
                                            .font(.system(size: getDynamicFontSize()))
                                            .foregroundStyle(.black)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.blue)
                                    }
                                    .customListItemStyle()
                                }
                                .buttonStyle(PlainButtonStyle())
                            } else {
                                NavigationLink(destination: ChapterDetailView(chapter: chapter)) {
                                    HStack {
                                        Text(chapter.title)
                                            .font(.system(size: getDynamicFontSize()))
                                            .foregroundStyle(.black)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.blue)
                                    }
                                    .customListItemStyle()
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            Divider()
                        }
                    }
                }
                .navigationTitle("useful_info_title".localized(bundle: settings.bundle))
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
                                Text("soon_available_text".localized(bundle: settings.bundle))
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
        }
    }
}

struct JanazaView: View {
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))
                .ignoresSafeArea(edges: .bottom)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        Text(JanazaPrayerGuide.janazaBasicRules(bundle: settings.bundle))
                            .font(.headline)
                        Divider()

                        Text(JanazaPrayerGuide.firstTakbirTitle(bundle: settings.bundle))
                            .font(.headline)
                        Text(JanazaPrayerGuide.firstTakbirText(bundle: settings.bundle))
                            .padding(.bottom)
                        Divider()
                        Text(JanazaPrayerGuide.secondTakbirTitle(bundle: settings.bundle))
                            .font(.headline)
                        Text(JanazaPrayerGuide.secondTakbirText(bundle: settings.bundle))
                            .padding(.bottom)
                    }
                    
                    Divider()
                    
                    Group {
                        Text(JanazaPrayerGuide.thirdTakbirTitle(bundle: settings.bundle))
                            .font(.headline)
                        Text(JanazaPrayerGuide.thirdTakbirText(bundle: settings.bundle))
                            .padding(.bottom)
                        Divider()

                        Text(JanazaPrayerGuide.duaVariationsTitle(bundle: settings.bundle))
                            .font(.headline)
                        Text(JanazaPrayerGuide.duaVariationsText(bundle: settings.bundle))
                            .padding(.bottom)
                    }
                    
                    Divider()
                    
                    Group {
                        Text(JanazaPrayerGuide.fourthTakbirTitle(bundle: settings.bundle))
                            .font(.headline)
                        Text(JanazaPrayerGuide.fourthTakbirText(bundle: settings.bundle))
                        Text(JanazaPrayerGuide.fourthTakbirAdditionalInfo(bundle: settings.bundle))
                            .padding(.bottom)
                        Divider()
                        Text(JanazaPrayerGuide.taslimTitle(bundle: settings.bundle))
                            .font(.headline)
                        Text(JanazaPrayerGuide.taslimText(bundle: settings.bundle))
                    }
                }
                .padding()
                .font(.system(size: getDynamicFontSize()))
                .foregroundStyle(.black)
                .textSelection(.enabled)
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
                Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))
                    .ignoresSafeArea(edges: .bottom)
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(chapter.subChapters) { subChapter in
                            NavigationLink(destination: SubChapterDetailView(subChapter: subChapter)) {
                                HStack {
                                    Text(subChapter.title)
                                        .font(.system(size: getDynamicFontSize()))
                                        .foregroundStyle(.black)
                                        .textSelection(.enabled)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.blue)
                                }
                                .customListItemStyle()
                            }
                            .buttonStyle(PlainButtonStyle())
                            Divider()
                        }
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
            Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))
                .ignoresSafeArea(edges: .bottom)
            ScrollView {
                Text(subChapter.content)
                    .font(.system(size: getDynamicFontSize()))
                    .foregroundStyle(.black)
                    .padding()
                    .textSelection(.enabled)
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

extension View {
    func customListItemStyle() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                    
                    Rectangle()
                        .foregroundColor(.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8980392157, green: 0.933333333, blue: 1, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomLeading))
                })
            .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20)
            .clipShape(RoundedRectangle(cornerRadius: 0))
    }
}
