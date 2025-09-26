//
//  ShimmeringText.swift
//  umra
//
//  Created by Saydulayev on 03.12.24.
//

import SwiftUI

struct ShimmeringText: View {
    // Контент и параметры
    var text: String = "WELCOME TO THE UMRA GUIDE"
    var fontSize: CGFloat = 28
    var cornerRadius: CGFloat = 20
    var material: Material = .ultraThinMaterial

    // Параметры блика
    var shimmerDuration: TimeInterval = 2.8
    var shimmerAngle: Double = 18
    var shimmerWidthFraction: CGFloat = 0.48

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }

    var body: some View {
        TimelineView(.animation) { context in
            GeometryReader { geo in
                // Адаптируем контент под доступную высоту/ширину карточки
                let width = geo.size.width
                let height = geo.size.height

                // Динамический размер шрифта и высота изображения
                let dynamicFont = min(max(height * 0.085, 18), 36)
                let imageHeight = max(height * 0.55, 100)

                // Непрерывная фаза 0...1, синхронизированная с частотой анимации
                let t = context.date.timeIntervalSinceReferenceDate
                let phase = CGFloat((t.truncatingRemainder(dividingBy: shimmerDuration)) / shimmerDuration)

                VStack(spacing: height * 0.02) {
                    Text(text)
                        .font(.system(size: dynamicFont, weight: .semibold, design: .rounded))
                        .kerning(0.5)
                        .foregroundStyle(.black.opacity(0.92))
                        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.7)
                        .lineLimit(2)
                        .padding(.horizontal, 24)
                        .padding(.top, 16)

                    Image("WelcomeImage")
                        .resizable()
                        .scaledToFit()
                        .frame(height: imageHeight)
                        .padding(14)
                }
                .frame(width: width, height: height)
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
                .clipShape(shape) // базовый контент подрезаем
                .overlay(
                    // Двигающийся блик по поверхности стекла (эффект “жидкости”)
                    ZStack {
                        // Параметры блика
                        let stripeWidth = max(width * shimmerWidthFraction, 36)
                        // Большой запас, чтобы момент «сброса» фазы был полностью вне видимой области
                        let margin = max(width, height) * 1.2
                        let startX = -margin
                        let endX = width + margin
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
                            .rotationEffect(.degrees(shimmerAngle))
                            .offset(x: currentX)
                            .allowsHitTesting(false)
                    }
                )
                .clipShape(shape) // ВАЖНО: подрезаем слой блика
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

        // Фиксируем одинаковую рамку для наглядности
        ShimmeringText()
            .frame(width: 360, height: 280)
            .padding()
    }
}
