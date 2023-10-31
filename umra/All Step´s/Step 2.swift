//
//  Step 2.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step2: View {
    @EnvironmentObject var settings: UserSettings
    @StateObject var colorManager = ColorManager()


    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(colorManager.backgroundColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
        ScrollView {
                VStack {
                        Text("Kaaba text1", bundle: settings.bundle)
                        .font(.custom("Lato-Black", size: 26))
                        Group {
                            
                            
                            Text("Kaaba text2", bundle: settings.bundle)
                            
                            
                            Text("الله أكبر‎")
                                .customTextforSteps()
                            
                            PlayerView(fileName: "6")
                                .padding()
                            
                            Text("Kaaba text3", bundle: settings.bundle)
                            
                            Text("""
        رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ
        """)
                            .customTextforSteps()
                            
                            PlayerView(fileName: "7")
                                .padding()
                            
                            Text("Kaaba text4", bundle: settings.bundle)
                            

                            
                            
                        }
                        .font(.system(size: 20, weight: .light, design: .serif))
                        .italic()
                    } 
                .foregroundColor(colorManager.textColor)
                .padding(.horizontal, 10)
            LanguageView()
                .hidden()
                }
            }
        }
    }

