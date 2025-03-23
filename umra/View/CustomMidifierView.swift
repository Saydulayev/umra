//
//  CustomMidifier.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

//MARK: ImageCustomMidifier
extension Image {
    func styledImageWithIndex(index: Int, stepsCount: Int) -> some View {
        ZStack(alignment: .topTrailing) {
            self
                .resizable()
                .scaledToFit()
                .padding(.bottom)
                .clipShape(Circle())
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    ZStack {
                        Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                        
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.white)
                            .blur(radius: 4)
                            .offset(x: -8, y: -8)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8956587315, green: 0.9328896403, blue: 1, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .padding(2)
                        
                    })
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20)
                .padding()

            Text("\(index + 1)")
                .font(.caption)
                .fontWeight(.bold)
                .padding(8)
                .background(.white)
                .clipShape(Circle())
                .offset(x: -25, y: 20)
                .opacity(index == stepsCount - 1 ? 0 : 1) 
        }
    }
    
    func styledImage() -> some View {
        self
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .frame(width: 70, height: 70)
            .padding(8)
            .background(
                ZStack {
                    Color(red: 0.76, green: 0.82, blue: 0.93)
                    
                    Circle()
                        .foregroundColor(.white)
                        .blur(radius: 3)
                        .offset(x: -4, y: -4)
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.90, green: 0.93, blue: 1.0),
                                    Color.white
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .padding(2)
                }
            )
            .clipShape(Circle())
            .shadow(color: Color(red: 0.76, green: 0.82, blue: 0.93, opacity: 0.5), radius: 10, x: 5, y: 5)
    }
}






//MARK: CustomTextforSteps
struct StepTextModifier: ViewModifier {
    
    private var dynamicFontSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 58 : 38
    }
    
    private var customPadding: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 32 : 16
    }
    
    func body(content: Content) -> some View {
        content
            .padding(customPadding)
            .font(.custom("Amiri Quran", size: dynamicFontSize))
            .lineSpacing(15)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    Color(#colorLiteral(red: 0.6, green: 0.8, blue: 0.9, alpha: 1))
                    
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
            .padding()
    }
}

extension View {
    func customTextforArabic() -> some View {
        self.modifier(StepTextModifier())
    }
}





extension View {
    func customTextStyle() -> some View {
        self
            .font(.system(size: 18, weight: .medium, design: .default))
            .foregroundColor(.black)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                    
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8980392157, green: 0.933333333, blue: 1, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomLeading))
                        .padding(2)
                })
            .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.vertical, 10)
    }
}
