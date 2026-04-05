//
//  ShimmeringText.swift
//  umra
//
//  Created by Saydulayev on 03.12.24.
//

import SwiftUI

struct ShimmeringText: View {
    @State private var isAnimating = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var text: String = "UMRA GUIDE"
    var foregroundColor: Color = Color(red: 0.420, green: 0.447, blue: 0.502)

    // Единый источник правды для шрифта — исключает расхождение между
    // отображаемым текстом и маской шиммера.
    private var baseText: Text {
        Text(text)
            .font(.largeTitle)
            .bold()
    }

    var body: some View {
        baseText
            .foregroundStyle(foregroundColor)
            .multilineTextAlignment(.center)
            .overlay(
                // GeometryReader используется осознанно для размера градиента шиммера относительно текста.
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
                .mask(baseText)
            )
            .onAppear {
                guard !reduceMotion else { return }
                // DispatchQueue.main.async выводит анимацию за пределы текущего
                // animation context родительского вью, иначе spring-транзакция
                // из LanguageSelectionView.onAppear перекрывает repeatForever.
                DispatchQueue.main.async {
                    withAnimation(
                        Animation.linear(duration: AppAnimation.shimmerDuration)
                            .repeatForever(autoreverses: false)
                    ) {
                        isAnimating = true
                    }
                }
            }
    }

    private var shimmerWidth: CGFloat { 2.0 }
}

#Preview {
    ShimmeringText()
}
