//
//  ShimmeringText.swift
//  umra
//
//  Created by Saydulayev on 03.12.24.
//

import SwiftUI

struct ShimmeringText: View {
    @State private var shimmerOffset: CGFloat = -2.0
    @State private var isAnimating = false
    
    // Текст приветствия и размер шрифта
    var text: String = "WELCOME TO THE UMRA GUIDE"
    var fontSize: CGFloat = 32
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .overlay(
                GeometryReader { geometry in
                    ZStack {
                        let gradient = LinearGradient(
                            gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.6), Color.clear]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        Rectangle()
                            .fill(gradient)
                            .rotationEffect(.degrees(30))
                            .offset(x: isAnimating ? shimmerWidth * geometry.size.width : -shimmerWidth * geometry.size.width)
                            .frame(width: geometry.size.width * 1.5, height: geometry.size.height * 2)
                    }
                }
                .mask(Text(text)
                        .font(.largeTitle)
                        .fontWeight(.bold))
                        .multilineTextAlignment(.center)
            )
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 3.0)
                        .repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
    }
    
    // Ширина эффекта мерцания для плавной анимации
    private var shimmerWidth: CGFloat {
        return 2.0
    }
}

#Preview {
    ShimmeringText()
}
