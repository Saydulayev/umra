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
        ZStack {
            VStack {
                HStack {
                    Text("circle_string", bundle: settings.bundle)
                        .font(.largeTitle.bold())
                    Text("\(counter)")
                        .font(.largeTitle.bold())
                }
                
                if counter == 7 {
                    Text("Sa´y finished_string", bundle: settings.bundle)
                        .foregroundColor(.green)
                        .font(.title.bold())
                }
                
                HStack(spacing: 20) {
                    Button(action: {
                        incrementCounter()
                    }) {
                        Text("add_string", bundle: settings.bundle)
                            .padding()
                            .lineSpacing(15)
                            .multilineTextAlignment(.center) 
                            .frame(width: 170, height: 50)
                            .background(
                                ZStack {
                                    Color(#colorLiteral(red: 0.7608050108, green: 0.9, blue: 0.8, alpha: 1))
                                    
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(.white)
                                        .blur(radius: 4)
                                        .offset(x: -8, y: -8)
                                    
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8980392157, green: 0.933333333, blue: 1, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .padding(2)
                                    
                                })
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20)
                    }
                    
                    Button(action: {
                        decrementCounter()
                    }) {
                        Text("reset_string", bundle: settings.bundle)
                            .padding()
                            .multilineTextAlignment(.center)
                            .frame(width: 170, height: 50)
                            .background(
                                ZStack {
                                    Color(#colorLiteral(red: 0.9, green: 0.8, blue: 0.8, alpha: 1))
                                    
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(.white)
                                        .blur(radius: 4)
                                        .offset(x: -8, y: -8)
                                    
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8980392157, green: 0.933333333, blue: 1, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .padding(2)
                                    
                                })
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20)

                    }
                }
            }
            .padding(.vertical)
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
