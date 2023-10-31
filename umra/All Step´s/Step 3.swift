//
//  Step 3.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step3: View {
    @EnvironmentObject var settings: UserSettings
    @StateObject var colorManager = ColorManager()


    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .fill(colorManager.backgroundColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.bottom)
        ScrollView {
                VStack {
                    Text("Prayer after Tawaf of Kaaba.", bundle: settings.bundle)
                    .font(.custom("Lato-Black", size: 26))
                    Group {
                        
                        Text("Having completed seven circuits around the Kaaba", bundle: settings.bundle)
                        
                        Text("""
                        وَاتَّخِذُوا مِن مَّقَامِ إِبْرَاهِيمَ مُصَلًّ
                        """)
                        .customTextforSteps()
                        
                        PlayerView(fileName: "13")
                            .padding()
                        
                    }
                    .font(.system(size: 20, weight: .light, design: .serif))
                    .italic()
                    
                    Group {
                        Text("Place of standing of Ibrahim", bundle: settings.bundle)
    
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
