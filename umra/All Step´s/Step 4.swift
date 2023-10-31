//
//  Step 4.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step4: View {
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
                    Text("Drinking Zamzam water.", bundle: settings.bundle)
                    .font(.custom("Lato-Black", size: 26))
                    Group {
                        
                        Text("Zamzam text", bundle: settings.bundle)
                        
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
