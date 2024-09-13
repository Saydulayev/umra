//
//  CounterTapView.swift
//  umra
//
//  Created by Akhmed on 02.09.23.
//

import SwiftUI

struct CounterTapView: View {
    @EnvironmentObject var settings: UserSettings
    @AppStorage("add_string") private var counter = 0
    
    var body: some View {
        VStack {
            HStack {
                Text("circle_string", bundle: settings.bundle)
                    .font(.largeTitle.bold())
                Text("\(counter)")
                    .font(.largeTitle.bold())
            }
            
            if counter == 7 {
                Text("Sa´y finished_string", bundle: settings.bundle)
                    .foregroundColor(.black)
                    .font(.title.bold())
                    .padding()
            }
            
            HStack(spacing: 20) {
                Button(action: {
                    incrementCounter()
                }) {
                    Text("add_string", bundle: settings.bundle)
                        .foregroundColor(.black)
                        .font(.system(size: 25))
                        .padding(20)
                        .background(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: Color.black.opacity(0.35), radius: 8, x: 8, y: 8)
                        .padding(.horizontal, 10)

                }
                
                Button(action: {
                    decrementCounter()
                }) {
                    Text("reset_string", bundle: settings.bundle)
                        .foregroundColor(.black)
                        .font(.system(size: 25))
                        .padding(20)
                        .background(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: Color.black.opacity(0.35), radius: 8, x: 8, y: 8)
                        .padding(.horizontal, 10)

                }
            }
            LanguageView()
                .hidden()
        }
    }
    
    
    func incrementCounter() {
        if counter < 7 {
            counter += 1
        }
    }
    
    func decrementCounter() {
        if counter > 0 {
            counter = 0
        }
    }
}


//struct CounterTapView_Previews: PreviewProvider {
//    static var previews: some View {
//        CounterTapView()
//    }
//}
