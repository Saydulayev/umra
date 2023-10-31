//
//  Step 7.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step7: View {
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
                    Text("Shaving the head string", bundle: settings.bundle)
                    .font(.custom("Lato-Black", size: 26))
                    Group {
                        
                        Text("Men shorten or shave their hair.", bundle: settings.bundle)
                        Text("Du'a at the end.", bundle: settings.bundle)
                        
                        Text("""
    
     ⵈ━══════╗◊╔══════━ⵈ
    """)
                        
                        
                    }
                    .font(.system(size: 20, weight: .light, design: .serif))
                    .italic()
                }
                .foregroundColor(colorManager.textColor)
                .padding(10)
            LanguageView()
                .hidden()
            }
        } 
    }
}
