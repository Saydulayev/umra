//
//  ContentView.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var fontManager: FontManager

    @AppStorage("isGridView") private var isGridView: Bool = UIDevice.current.userInterfaceIdiom == .pad
    @State private var showPrayerTimes = false
    @State private var imageDescriptions: [String: String] = [
        "image 1": "title_ihram_screen",
        "image 2": "title_round_kaaba_screen",
        "image 3": "title_place_ibrohim_stand_screen",
        "image 4": "title_water_zamzam_screen",
        "image 5": "title_black_stone_screen",
        "image 6": "title_safa_and_marva_screen",
        "image 7": "title_shave_head_screen",
        "image 8": "Useful"
    ]
    @State private var usageTime: TimeInterval = 0
    @State private var timer: Timer?
    @AppStorage("hasRatedApp") private var hasRatedApp: Bool = false
    @Environment(\.requestReview) var requestReview

    let steps = [
        ("image 1", AnyView(Step1()), "title_ihram_screen"),
        ("image 2", AnyView(Step2()), "title_round_kaaba_screen"),
        ("image 3", AnyView(Step3()), "title_place_ibrohim_stand_screen"),
        ("image 4", AnyView(Step4()), "title_water_zamzam_screen"),
        ("image 5", AnyView(Step5()), "title_black_stone_screen"),
        ("image 6", AnyView(Step6()), "title_safa_and_marva_screen"),
        ("image 7", AnyView(Step7()), "title_shave_head_screen"),
        ("image 8", AnyView(UsefulInfoView()), "Useful")
    ]

    private var dynamicFontSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 30 : 10
    }

    var body: some View {
        Group {
            if settings.hasSelectedLanguage {
                mainContentView
            } else {
                LanguageSelectionView()
            }
        }
        .animation(.easeInOut, value: settings.hasSelectedLanguage)
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }

    private var mainContentView: some View {
        NavigationStack {
            ZStack {
                Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))
                    .ignoresSafeArea(edges: .bottom)
                
                ScrollView {
                    content
                        .padding(.vertical, 8)
                }
                .navigationBarTitle("UMRA", displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        if UIDevice.current.userInterfaceIdiom != .pad {
                            isGridView.toggle()
                        }
                    }) {
                        Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                            .imageScale(.large)
                            .foregroundColor(.primary)
                            .opacity(UIDevice.current.userInterfaceIdiom == .pad ? 0.0 : 1.0)
                    },
                    trailing: HStack {
                        Button(action: {
                            showPrayerTimes = true
                        }) {
                            Image(systemName: "clock")
                                .imageScale(.large)
                                .foregroundColor(.primary)
                        }
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape")
                                .imageScale(.large)
                                .foregroundColor(.primary)
                        }
                    }
                )
                .sheet(isPresented: $showPrayerTimes) {
                    PrayerTimeModalView(isPresented: $showPrayerTimes)
                }
                LanguageView().hidden()
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if isGridView {
            LazyVGrid(columns: gridColumns, spacing: 20) {
                stepsView(showIndex: true, fontSize: dynamicFontSize)
            }
        } else {
            VStack {
                stepsView(showIndex: false, fontSize: dynamicFontSize * 3.8)
            }
        }
    }

    private func stepsView(showIndex: Bool, fontSize: CGFloat) -> some View {
        ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
            StepView(
                imageName: step.0,
                destinationView: step.1,
                titleKey: LocalizedStringKey(step.2),
                index: showIndex ? index : nil,
                fontSize: fontSize,
                stepsCount: steps.count,
                imageDescriptions: $imageDescriptions
            )
            .foregroundStyle(.black)
        }
    }

    private var gridColumns: [GridItem] {
        let screenWidth = UIScreen.main.bounds.width
        let columnWidth = screenWidth / 2 - 10
        return [GridItem(.fixed(columnWidth)), GridItem(.fixed(columnWidth))]
    }

    func startTimer() {
        guard !hasRatedApp else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            usageTime += 1
            if usageTime >= 300 {
                timer?.invalidate()
                timer = nil
                requestReviewIfNeeded()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func requestReviewIfNeeded() {
        guard !hasRatedApp else { return }
        requestReview()
        hasRatedApp = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserSettings())
            .environmentObject(FontManager())
    }
}































