//
//  ContentView.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct StepView: View {
    let imageName: String
    let destinationView: AnyView
    let titleKey: LocalizedStringKey
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var colorManager: ColorManager
    @EnvironmentObject var fontManager: FontManager
    
    
    var body: some View {
        VStack {
            Divider()
            NavigationLink(destination: destinationView) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .imageCustomModifier()
            }
            Text(titleKey, bundle: settings.bundle)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var colorManager: ColorManager
    @EnvironmentObject var fontManager: FontManager
    
    @State private var isGridView = false
    @State private var showSettings = false
    @State private var showPrayerTimes = false
    
    let steps = [
        ("image 1", AnyView(Step1()), "title_ihram_screen"),
        ("image 2", AnyView(Step2()), "title_round_kaaba_screen"),
        ("image 3", AnyView(Step3()), "title_place_ibrohim_stand_screen"),
        ("image 4", AnyView(Step4()), "title_water_zamzam_screen"),
        ("image 5", AnyView(Step5()), "title_black_stone_screen"),
        ("image 6", AnyView(Step6()), "title_safa_and_marva_screen"),
        ("image 7", AnyView(Step7()), "title_shave_head_screen"),
        ("image 8", AnyView(PDFViewWrapper()), "title_link_book_screen")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea(edges: .bottom)
                ScrollView {
                    if isGridView {
                        LazyVGrid(columns: gridColumns, spacing: 20) {
                            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                                StepView(imageName: step.0, destinationView: step.1, titleKey: LocalizedStringKey(step.2))
                                    .font(.custom("Lato-Black", size: 10))
                                    .foregroundStyle(Color.init(#colorLiteral(red: 0.5188618898, green: 0.2738361061, blue: 0.2221542895, alpha: 1)))
                            }
                        }
                    } else {
                        VStack {
                            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                                StepView(imageName: step.0, destinationView: step.1, titleKey: LocalizedStringKey(step.2))
                                    .titleTextModifier()
                            }
                        }
                    }
                }
                .navigationBarTitle("UMRA", displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        isGridView.toggle()
                    }) {
                        Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2").imageScale(.large).foregroundColor(.primary)
                    },
                    trailing: HStack {
                        Button(action: {
                            showPrayerTimes = true
                        }) {
                            Image(systemName: "clock").imageScale(.large).foregroundColor(.primary)
                        }
                        Button(action: {
                            showSettings = true
                        }) {
                            Image(systemName: "gearshape").imageScale(.large).foregroundColor(.primary)
                        }
                    }
                )
                .sheet(isPresented: $showSettings) {
                    // Модальное окно с настройками
                    SettingsView()
                }
                .fullScreenCover(isPresented: $showPrayerTimes) {
                    PrayerTimeModalView(isPresented: $showPrayerTimes)
                }
                LanguageView().hidden()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    private var gridColumns: [GridItem] {
        // Расчет ширины колонки
        let screenWidth = UIScreen.main.bounds.width
        let columnWidth = screenWidth / 2 - 20 // Вычитаем отступы
        
        return [GridItem(.fixed(columnWidth)), GridItem(.fixed(columnWidth))]
    }
}









struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserSettings())
            .environmentObject(FontManager())
            .environmentObject(ColorManager())
    }
}














//Old Code

//struct ContentView: View {
//
//    @EnvironmentObject var settings: UserSettings
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Color.white
//                    .edgesIgnoringSafeArea(.bottom)
//                ScrollView {
//                    VStack {
//
//                        VStack {
//                            Divider()
//                            NavigationLink(destination: Step1()) {
//                                Image("image 1")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .imageCustomMidifier()
//                            }
//                            Text("title_ihram_screen", bundle: settings.bundle)
//                                .titleTextMidifier()
//                        }
//
//                        VStack {
//                            Divider()
//                            NavigationLink(destination: Step2()) {
//                                Image("image 2")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .imageCustomMidifier()
//                            }
//                            Text("title_round_kaaba_screen", bundle: settings.bundle)
//                                .titleTextMidifier()
//                        }
//
//                        VStack {
//                            Divider()
//                            NavigationLink(destination: Step3()) {
//                                Image("image 3")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .imageCustomMidifier()
//                            }
//                            Text("title_place_ibrohim_stand_screen", bundle: settings.bundle)
//                                .titleTextMidifier()
//                        }
//
//                        VStack {
//                            Divider()
//                            NavigationLink(destination: Step4()) {
//                                Image("image 4")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .imageCustomMidifier()
//                            }
//                            Text("title_water_zamzam_screen", bundle: settings.bundle)
//                                .titleTextMidifier()
//                        }
//
//                        VStack {
//                            Divider()
//                            NavigationLink(destination: Step5()) {
//                                Image("image 5")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .imageCustomMidifier()
//                            }
//                            Text("title_black_stone_screen", bundle: settings.bundle)
//                                .titleTextMidifier()
//                        }
//
//                        VStack {
//                            Divider()
//                            NavigationLink(destination: Step6()) {
//                                Image("image 6")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .imageCustomMidifier()
//                            }
//                            Text("title_safa_and_marva_screen", bundle: settings.bundle)
//                                .titleTextMidifier()
//                        }
//
//                        VStack {
//                            Divider()
//                            NavigationLink(destination: Step7()) {
//                                Image("image 7")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .imageCustomMidifier()
//                            }
//                            Text("title_shave_head_screen", bundle: settings.bundle)
//                                .titleTextMidifier()
//                        }
//
//                        VStack {
//                            Divider()
//                            NavigationLink(destination: PDFViewWrapper()) {
//                                Image("image 9")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .imageCustomMidifier()
//                            }
//                            Text("title_link_book_screen", bundle: settings.bundle)
//                                .titleTextMidifier()
//                            Divider()
//                        }
//                    }
//                    Text("")
//                        .navigationBarTitle("UMRA", displayMode: .inline)
//                        .navigationBarItems(trailing:
//                                                NavigationLink(destination: SettingsView()) {
//                            Image(systemName: "gearshape")
//                                .imageScale(.large)
//                                .foregroundColor(.blue)
//                        }
//                        )
//                    LanguageView(settings: settings)
//                        .hidden()
//                }
//            }
//        }       .accentColor(Color.green)
//    }
//}



























