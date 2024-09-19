//
//  CustomMidifier.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

//MARK: ImageCustomMidifier
extension Image {
    func styledImageWithIndex(index: Int) -> some View {
        ZStack(alignment: .topTrailing) {
            self
                .resizable()
                .aspectRatio(contentMode: .fit)
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
            
            // Номер в правом верхнем углу
            Text("\(index + 1)")
                .font(.caption)
                .fontWeight(.bold)
                .padding(8)
                .background(Color.white.opacity(0.7))
                .clipShape(Circle())
                .offset(x: -25, y: 20)
        }
    }
    
    func styledImage() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
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
            .padding(30)
    }
}





//MARK: CustomTextforSteps
struct StepTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.custom("Amiri Quran", size: 38))
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
