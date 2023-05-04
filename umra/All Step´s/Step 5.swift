//
//  Step 5.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step5: View {
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.98108989, green: 0.9316333532, blue: 0.8719255924, alpha: 1))
                .edgesIgnoringSafeArea(.bottom)
        ScrollView {
                VStack {
                    Text("""
                         
                        Возврат к Черному камню
                        """)
                    .font(.custom("Lato-Black", size: 26))
                    .foregroundColor(.black)
                    Group {
                        
                        Text("""
    
        Возвратитесь к Чёрному камню,
        произносите такбир и
        прикаснитесь к нему так же,
        как было разъяснено ранее.
        Или укажите на него
        рукой и произнесите такбир.
        Аллах Велик.
    """)
                        Spacer()
                        
                        Text("""
    
    Аллаhу Акбар.
    
    """)
                        Text("الله أكبر‎")
                            .customTextforSteps()
                        
                        PlayerView(fileName: "6")
                            .padding()
                    
                    }
                    .font(.system(size: 20, weight: .light, design: .serif))
                    .italic()
                    .foregroundColor(.black)
                } .padding(.horizontal, 10)
            }
        } 
    }
}

