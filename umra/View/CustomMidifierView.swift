//
//  CustomMidifier.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI
import UIKit

// Общие стеклянные утилиты
private let glassStrokeGradient = LinearGradient(
    colors: [Color.white.opacity(0.75), Color.white.opacity(0.20)],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)

// Всегда "светлый" блюр, независимо от темы устройства
private struct LightBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let effect: UIBlurEffect
        if #available(iOS 13.0, *) {
            effect = UIBlurEffect(style: .systemThinMaterialLight)
        } else {
            effect = UIBlurEffect(style: .light)
        }
        return UIVisualEffectView(effect: effect)
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) { }
}

// MARK: - Прозрачное стекло (Rounded)

// Лёгкий «прозрачный стеклянный» фон без затемнения
@ViewBuilder
private func glassRoundedBackground(cornerRadius: CGFloat) -> some View {
    LightBlurView()
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
}

// Белая обводка с лёгким градиентом
private func glassRoundedStroke(cornerRadius: CGFloat, lineWidth: CGFloat = 1) -> some View {
    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        .strokeBorder(glassStrokeGradient, lineWidth: lineWidth)
}

// Нежный блик сверху-слева
private func glassRoundedHighlight(cornerRadius: CGFloat) -> some View {
    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        .fill(
            LinearGradient(
                colors: [Color.white.opacity(0.28), .clear],
                startPoint: .topLeading,
                endPoint: .center
            )
        )
        .blur(radius: 10)
        .allowsHitTesting(false)
}

// MARK: - Прозрачное стекло (Circle)

@ViewBuilder
private func glassCircleBackground() -> some View {
    LightBlurView()
        .clipShape(Circle())
}

private func glassCircleStroke(lineWidth: CGFloat = 1) -> some View {
    Circle()
        .strokeBorder(glassStrokeGradient, lineWidth: lineWidth)
}

private func glassCircleHighlight() -> some View {
    Circle()
        .fill(
            RadialGradient(
                colors: [Color.white.opacity(0.28), .clear],
                center: .topLeading,
                startRadius: 0,
                endRadius: 80
            )
        )
        .blur(radius: 8)
        .allowsHitTesting(false)
}

// MARK: - Общая тень для стекла
private struct GlassShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.10), radius: 18, x: 0, y: 10)
            .shadow(color: Color.white.opacity(0.12), radius: 1, x: 0, y: 1)
    }
}

// MARK: ImageCustomMidifier
extension Image {
    func styledImageWithIndex(index: Int, stepsCount: Int) -> some View {
        // Карточка изображения с прозрачным стеклянным фоном
        self
            .resizable()
            .scaledToFit()
            .padding(.bottom)
            .clipShape(Circle())
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                glassRoundedBackground(cornerRadius: 20)
            )
            .overlay(
                glassRoundedStroke(cornerRadius: 20)
            )
            .overlay(
                glassRoundedHighlight(cornerRadius: 20)
            )
            .modifier(GlassShadowModifier())
            // Номер шага в правом верхнем углу карточки
            .overlay(alignment: .topTrailing) {
                if index != stepsCount - 1 {
                    Text("\(index + 1)")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.black)
                        .padding(8)
                        .background(glassCircleBackground())
                        .overlay(glassCircleStroke())
                        .overlay(glassCircleHighlight())
                        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                        .padding(10)
                }
            }
            .padding(.horizontal)
            .padding(.top, 4)
    }
    
    func styledImage() -> some View {
        self
            .resizable()
            .scaledToFit()
            .padding(.bottom, 10)
            .clipShape(Circle())
            .frame(width: 90, height: 90)
            .padding(4)
            .background(
                glassRoundedBackground(cornerRadius: 20)
            )
            .overlay(
                glassRoundedStroke(cornerRadius: 20)
            )
            .overlay(
                glassRoundedHighlight(cornerRadius: 20)
            )
            .modifier(GlassShadowModifier())
    }
}

// MARK: CustomTextforSteps
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
                glassRoundedBackground(cornerRadius: 20)
            )
            .overlay(
                glassRoundedStroke(cornerRadius: 20)
            )
            .overlay(
                glassRoundedHighlight(cornerRadius: 20)
            )
            .modifier(GlassShadowModifier())
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
            .foregroundColor(.primary)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                glassRoundedBackground(cornerRadius: 20)
            )
            .overlay(
                glassRoundedStroke(cornerRadius: 20)
            )
            .overlay(
                glassRoundedHighlight(cornerRadius: 20)
            )
            .modifier(GlassShadowModifier())
            .padding(.vertical, 10)
    }
}
