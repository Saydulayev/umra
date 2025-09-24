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
    colors: [Color.white.opacity(0.65), Color.white.opacity(0.15)],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)

@ViewBuilder
private func glassRoundedBackground(cornerRadius: CGFloat) -> some View {
    // Мягкая затемнённая подложка под «листом» для усиления эффекта стекла
    ZStack {
        RoundedRectangle(cornerRadius: cornerRadius + 2, style: .continuous)
            .fill(Color.black.opacity(0.10))
            .blur(radius: 12)
            .offset(y: 2)
            .compositingGroup()
        if #available(iOS 15.0, *) {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
        } else {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color.white.opacity(0.25))
        }
    }
}

private func glassRoundedStroke(cornerRadius: CGFloat, lineWidth: CGFloat = 1) -> some View {
    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        .strokeBorder(glassStrokeGradient, lineWidth: lineWidth)
}

private func glassRoundedHighlight(cornerRadius: CGFloat) -> some View {
    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        .fill(
            LinearGradient(
                colors: [Color.white.opacity(0.35), .clear],
                startPoint: .topLeading,
                endPoint: .center
            )
        )
        .blur(radius: 12)
        .allowsHitTesting(false)
}

@ViewBuilder
private func glassCircleBackground() -> some View {
    // Мягкая затемнённая подложка под круглым «листом»
    ZStack {
        Circle()
            .fill(Color.black.opacity(0.12))
            .blur(radius: 10)
            .offset(y: 2)
            .compositingGroup()
        if #available(iOS 15.0, *) {
            Circle().fill(.ultraThinMaterial)
        } else {
            Circle().fill(Color.white.opacity(0.28))
        }
    }
}

private func glassCircleStroke(lineWidth: CGFloat = 1) -> some View {
    Circle()
        .strokeBorder(glassStrokeGradient, lineWidth: lineWidth)
}

private var glassShadow: some View {
    EmptyView()
        .shadow(color: Color.black.opacity(0.10), radius: 18, x: 0, y: 10)
        .shadow(color: Color.white.opacity(0.12), radius: 1, x: 0, y: 1)
}

// MARK: ImageCustomMidifier
extension Image {
    func styledImageWithIndex(index: Int, stepsCount: Int) -> some View {
        // Карточка изображения со стеклянным фоном
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
            // Номер шага фиксирован в правом верхнем углу карточки
            .overlay(alignment: .topTrailing) {
                if index != stepsCount - 1 {
                    Text("\(index + 1)")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.primary)
                        .padding(8)
                        .background(glassCircleBackground())
                        .overlay(glassCircleStroke())
                        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                        .padding(10) // отступ от правого и верхнего края карточки
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

// MARK: - Общий модификатор теней для стекла
private struct GlassShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.10), radius: 18, x: 0, y: 10)
            .shadow(color: Color.white.opacity(0.12), radius: 1, x: 0, y: 1)
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
                glassRoundedBackground(cornerRadius: 10)
            )
            .overlay(
                glassRoundedStroke(cornerRadius: 10)
            )
            .overlay(
                glassRoundedHighlight(cornerRadius: 10)
            )
            .modifier(GlassShadowModifier())
            .padding(.vertical, 10)
    }
}
