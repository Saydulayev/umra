//
//  ShimmeringText.swift
//  umra
//
//  Created by Saydulayev on 03.12.24.
//

import SwiftUI

struct ShimmeringText: View {
    @State private var shimmerOffset: CGFloat = -2.0

    var body: some View {
        Text("WELCOME TO THE UMRA GUIDE")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .overlay(
                GeometryReader { geometry in
                    ZStack {
                        let gradient = LinearGradient(
                            gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.6), Color.clear]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        Rectangle()
                            .fill(gradient)
                            .rotationEffect(.degrees(30))
                            .offset(x: shimmerOffset * geometry.size.width, y: 0)
                            .frame(width: geometry.size.width * 1.5, height: geometry.size.height * 2)
                    }
                }
                .mask(Text("WELCOME TO THE UMRA GUIDE")
                        .font(.largeTitle)
                        .fontWeight(.bold))
                        .multilineTextAlignment(.center)
            )
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                ) {
                    shimmerOffset = 2.0
                }
            }
    }
}


#Preview {
    ShimmeringText()
}
