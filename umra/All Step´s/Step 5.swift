//
//  Step 5.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step5: View {
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
                    Text("Return to the Black Stone.", bundle: settings.bundle)
                    .font(.custom("Lato-Black", size: 26))
                    Group {
                        
                        Text("Return to the Black Stone, recite the Takbir.", bundle: settings.bundle)
                        Spacer()
                        
                        Text("Allah is great.", bundle: settings.bundle)
                        Text("الله أكبر‎")
                            .customTextforSteps()
                        
                        PlayerView(fileName: "6")
                            .padding()
                    
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

