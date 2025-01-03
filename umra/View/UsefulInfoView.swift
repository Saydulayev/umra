//
//  UsefulInfoView.swift
//  umra
//
//  Created by Saydulayev on 17.09.24.
//

import SwiftUI

    struct UsefulInfoView: View {
        @State private var isInfoPresented = false
        @EnvironmentObject var settings: UserSettings
        
        
        let chapters: [Chapter] = [
            Chapter(title: "Этикет и нравы", subChapters: [
                SubChapter(title: "Искренность", content: EtiquetteManners.text1),
                SubChapter(title: "Законоположения", content: EtiquetteManners.text2),
                SubChapter(title: "Выбор спутников", content: EtiquetteManners.text3),
                SubChapter(title: "Финансовая независимость", content: EtiquetteManners.text4),
                SubChapter(title: "Благородные нравы", content: EtiquetteManners.text5),
                SubChapter(title: "Зикр и мольбы", content: EtiquetteManners.text6),
                SubChapter(title: "Осторожность в отношениях", content: EtiquetteManners.text7),
            ]),
            Chapter(title: "Достоинство хаджа и умры", subChapters: [
                SubChapter(title: "Искупление грехов и награда", content: HajjUmrahVirtues.text1),
                SubChapter(title: "Хадж для женщин", content: HajjUmrahVirtues.text2),
                SubChapter(title: "Безупречный хадж", content: HajjUmrahVirtues.text3),
                SubChapter(title: "Следование сунне", content: HajjUmrahVirtues.text4),
            ]),
            Chapter(title: "Обязательность хаджа и умры", subChapters: [
                SubChapter(title: "Доказательства обязательности хаджа", content: HajjUmrahObligation.obligationEvidence),
                SubChapter(title: "Доказательства обязательности умры", content: HajjUmrahObligation.evidenceUmrahObligation),
                SubChapter(title: "Заключение", content: HajjUmrahObligation.concludingEvidence),
            ]),
            // Можно добавить дополнительные главы и подглавы здесь
        ]
        
        var body: some View {
            NavigationStack {
                ZStack {
                    Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))
                        .ignoresSafeArea(edges: .bottom)
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(chapters) { chapter in
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
                                Divider()
                            }
                        }
                        
                    }
                    .navigationTitle("Полезная информация")
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
                                    Text("soon_available_text", bundle: settings.bundle)
                                        .font(.body)
                                        .padding()
                                        .multilineTextAlignment(.center)
                                        .frame(width: 250, height: 150)
                                }
                                .frame(width: 250, height: 200)
                                .presentationCompactAdaptation(.popover)
                            }
                        }
                    }
                }
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
