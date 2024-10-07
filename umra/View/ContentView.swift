//
//  ContentView.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct StepView<Destination: View>: View {
    let imageName: String
    let destinationView: Destination
    let titleKey: LocalizedStringKey
    let index: Int?
    let fontSize: CGFloat
    let stepsCount: Int
    
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var fontManager: FontManager
    
    var body: some View {
        VStack {
            NavigationLink(destination: destinationView) {
                if let index = index {
                    Image(imageName)
                        .styledImageWithIndex(index: index, stepsCount: stepsCount) 
                } else {
                    Image(imageName)
                        .styledImage()
                }
            }
            Text(titleKey, bundle: settings.bundle)
                .font(.custom("Lato-Black", size: fontSize))
                .multilineTextAlignment(.center)
            Divider()
        }
    }
}


struct ContentView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var fontManager: FontManager
    
    @State private var isGridView = UIDevice.current.userInterfaceIdiom == .pad
    @State private var showPrayerTimes = false
    
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
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))
                    .ignoresSafeArea(edges: .bottom)
                
                ScrollView {
                    content
                }
                .navigationBarTitle("UMRA", displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        isGridView.toggle()
                    }) {
                        Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                            .imageScale(.large)
                            .foregroundColor(.primary)
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    @ViewBuilder
    private var content: some View {
        if isGridView {
            LazyVGrid(columns: gridColumns, spacing: 20) {
                stepsView(showIndex: true, fontSize: 10)
            }
        } else {
            VStack {
                stepsView(showIndex: false, fontSize: 38)
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
                fontSize: fontSize, stepsCount: steps.count
            )
            .foregroundStyle(.black)
        }
    }

    private var gridColumns: [GridItem] {
        // Расчет ширины колонки
        let screenWidth = UIScreen.main.bounds.width
        let columnWidth = screenWidth / 2 - 10  // Вычитаем отступы
        
        return [GridItem(.fixed(columnWidth)), GridItem(.fixed(columnWidth))]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserSettings())
            .environmentObject(FontManager())
    }
}































