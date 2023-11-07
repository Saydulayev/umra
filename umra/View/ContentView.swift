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
                    .imageCustomMidifier()
            }
            Text(titleKey, bundle: settings.bundle)
                .titleTextMidifier()
        }
    }
}


//Optimized old code. The code has become shorter and simpler.
struct ContentView: View {
    
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var colorManager: ColorManager
    @EnvironmentObject var fontManager: FontManager

    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.bottom)
                ScrollView {
                    VStack {
                        StepView(imageName: "image 1", destinationView: AnyView(Step1()), titleKey: "title_ihram_screen")
                        StepView(imageName: "image 2", destinationView: AnyView(Step2()), titleKey: "title_round_kaaba_screen")
                        StepView(imageName: "image 3", destinationView: AnyView(Step3()), titleKey: "title_place_ibrohim_stand_screen")
                        StepView(imageName: "image 4", destinationView: AnyView(Step4()), titleKey: "title_water_zamzam_screen")
                        StepView(imageName: "image 5", destinationView: AnyView(Step5()), titleKey: "title_black_stone_screen")
                        StepView(imageName: "image 6", destinationView: AnyView(Step6()), titleKey: "title_safa_and_marva_screen")
                        StepView(imageName: "image 7", destinationView: AnyView(Step7()), titleKey: "title_shave_head_screen")
                        StepView(imageName: "image 9", destinationView: AnyView(PDFViewWrapper()), titleKey: "title_link_book_screen")
                    }
                    .navigationBarTitle("UMRA", displayMode: .inline)
                    .navigationBarItems(trailing:
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }
                    )
                    LanguageView().hidden()
                }
            }
        }
        .accentColor(Color.green)
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



























