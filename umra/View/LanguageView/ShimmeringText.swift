//
//  ShimmeringText.swift
//  umra
//
//  Created by Saydulayev on 03.12.24.
//

import SwiftUI

struct ShimmeringText: View {
    @State private var isAnimating = false
    @State private var phase: CGFloat = 0 // 0...1 непрерывная фаза

    // Контент и параметры
    var text: String = "WELCOME TO THE UMRA GUIDE"
    var fontSize: CGFloat = 28
    var cornerRadius: CGFloat = 24
    var material: Material = .ultraThinMaterial

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }

    var body: some View {
        // Текст внутри стеклянного контейнера
        Text(text)
            .font(.system(size: fontSize, weight: .semibold, design: .rounded))
            .kerning(0.5)
            .foregroundStyle(.black.opacity(0.92))
            .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                // Само "жидкое стекло": размытие + легкая цветная подложка
                shape
                    .fill(material)
                    .overlay(
                        // Едва заметный оттенок для глубины
                        shape
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.06),
                                        Color.cyan.opacity(0.08)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
            )
            .clipShape(shape) // гарантируем, что базовый контент не выходит за форму
            .overlay(
                // Двигающийся блик по поверхности стекла (эффект “жидкости”)
                GeometryReader { geo in
                    let width = geo.size.width
                    let height = geo.size.height

                    // Параметры блика
                    let stripeWidth = max(width * 0.48, 36) // ширина блика
                    // Дадим больше запасов, чтобы скачок был полностью вне экрана
                    let overshoot: CGFloat = stripeWidth * 1.4
                    let startX = -overshoot                // старт далеко за левой гранью
                    let endX = width + overshoot           // финиш далеко за правой гранью

                    // Интерполяция по фазе 0...1
                    let currentX = startX + (endX - startX) * phase

                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.00),
                                    Color.white.opacity(0.45),
                                    Color.white.opacity(0.00)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        // Чуть выше, чтобы при наклоне не торчали углы
                        .frame(width: stripeWidth, height: height * 1.8)
                        .rotationEffect(.degrees(18))
                        .offset(x: currentX)
                        .allowsHitTesting(false)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                // Маска на весь слой блика с небольшим inset, чтобы не залезать под обводку
                .mask(
                    shape.inset(by: 1)
                )
            )
            // Светящаяся окантовка — наверху, чтобы всегда оставалась видимой
            .overlay(
                shape
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.70),
                                Color.white.opacity(0.15)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            // Объемная тень под стеклом
            .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 18)
            .onAppear {
                isAnimating = true
                phase = 0
                // Плавная бесконечная анимация фазы 0 -> 1
                withAnimation(
                    .linear(duration: 2.8)
                        .delay(0.3)
                        .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
}

#Preview {
    ZStack {
        // Фоновый градиент для демонстрации стекла
        LinearGradient(
            colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.5)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        ShimmeringText()
            .padding()
    }
}
