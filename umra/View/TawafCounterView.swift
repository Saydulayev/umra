//
//  TawafCounterView.swift
//  umra
//
//  Created for Tawaf circuit counter (7 rounds around the Kaaba).
//

import SwiftUI
import UIKit

struct TawafCounterView: View {
    var body: some View {
        RitualCounterCard(kind: .tawaf)
    }
}

enum RitualCounterKind {
    static let targetCount = 7

    case tawaf
    case sai

    var titleKey: String {
        switch self {
        case .tawaf:
            return "title_round_kaaba_screen"
        case .sai:
            return "title_safa_and_marva_screen"
        }
    }

    var progressLabelKey: String {
        switch self {
        case .tawaf:
            return "tawaf_circle_label"
        case .sai:
            return "circle_string"
        }
    }

    var completionKey: String {
        switch self {
        case .tawaf:
            return "tawaf_finished"
        case .sai:
            return "Sa´y finished_string"
        }
    }

    var storageKey: String {
        switch self {
        case .tawaf:
            return UserDefaultsKey.tawafCircuitCount
        case .sai:
            return UserDefaultsKey.saiRoundCount
        }
    }

    var iconName: String {
        switch self {
        case .tawaf:
            return "arrow.clockwise.circle.fill"
        case .sai:
            return "figure.walk.circle.fill"
        }
    }
}

struct RitualCounterCard: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @AppStorage private var counter: Int
    @State private var showCompletionHighlight = false

    private let kind: RitualCounterKind

    init(kind: RitualCounterKind) {
        self.kind = kind
        _counter = AppStorage(wrappedValue: 0, kind.storageKey)
    }

    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    private var theme: AppTheme {
        themeManager.selectedTheme
    }

    private var isCompleted: Bool {
        counter >= RitualCounterKind.targetCount
    }

    private var cardCornerRadius: CGFloat {
        isIPad ? 30 : 24
    }

    private var horizontalPadding: CGFloat {
        isIPad ? 28 : 22
    }

    private var verticalPadding: CGFloat {
        isIPad ? 26 : 20
    }

    private var outerHorizontalPadding: CGFloat {
        isIPad ? 20 : 16
    }

    private var titleFontSize: CGFloat {
        isIPad ? 28 : 22
    }

    private var statusFontSize: CGFloat {
        isIPad ? 17 : 14
    }

    private var buttonFontSize: CGFloat {
        isIPad ? 18 : 16
    }

    private var stepIndicatorSize: CGFloat {
        isIPad ? 34 : 28
    }

    private var buttonHeight: CGFloat {
        isIPad ? 60 : 54
    }

    private var statusColor: Color {
        isCompleted ? theme.secondaryColor : theme.primaryColor
    }

    private var statusBackground: Color {
        statusColor.opacity(theme.isDarkAppearance ? 0.20 : 0.12)
    }

    private var counterCardShadowRadius: CGFloat {
        theme.usesTintedArabicCards ? (isIPad ? 18 : 14) : 18
    }

    private var counterCardShadowYOffset: CGFloat {
        theme.usesTintedArabicCards ? (isIPad ? 10 : 6) : 8
    }

    private var accentGradient: LinearGradient {
        LinearGradient(
            colors: [
                theme.primaryColor,
                isCompleted ? theme.secondaryColor : theme.primaryColor.opacity(0.85)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        ZStack {
            VStack(spacing: isIPad ? 22 : 18) {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 10) {
                        localizedText(kind.titleKey)
                            .font(.custom("Lato-Black", size: titleFontSize))
                            .foregroundStyle(theme.textColor)

                        HStack(spacing: 8) {
                            Image(systemName: isCompleted ? "checkmark.circle.fill" : kind.iconName)
                                .font(.system(size: isIPad ? 16 : 14, weight: .semibold))
                            localizedText(isCompleted ? kind.completionKey : kind.progressLabelKey)
                                .font(.system(size: statusFontSize, weight: .semibold))
                                .lineLimit(2)
                        }
                        .foregroundStyle(statusColor)
                        .padding(.horizontal, isIPad ? 14 : 12)
                        .padding(.vertical, isIPad ? 10 : 8)
                        .background(
                            Capsule(style: .continuous)
                                .fill(statusBackground)
                        )
                        .scaleEffect(showCompletionHighlight ? 1.0 : 0.97)
                        .animation(AppAnimation.completionHighlight, value: showCompletionHighlight)
                    }

                    Spacer(minLength: 12)

                    Text("\(counter)/\(RitualCounterKind.targetCount)")
                        .font(.system(size: isIPad ? 22 : 18, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(statusColor)
                        .padding(.horizontal, isIPad ? 14 : 12)
                        .padding(.vertical, isIPad ? 12 : 10)
                        .background(
                            Capsule(style: .continuous)
                                .fill(statusBackground.opacity(0.9))
                        )
                }

                progressDetails

                HStack(spacing: isIPad ? 14 : 10) {
                    Button(action: incrementCounter) {
                        HStack(spacing: 10) {
                            Image(systemName: isCompleted ? "checkmark.circle.fill" : "plus.circle.fill")
                                .font(.system(size: isIPad ? 18 : 16, weight: .semibold))
                            Text("add_string", bundle: localizationManager.bundle)
                                .font(.system(size: buttonFontSize, weight: .semibold))
                                .lineLimit(1)
                        }
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: buttonHeight)
                        .background(
                            Capsule(style: .continuous)
                                .fill(accentGradient.opacity(isCompleted ? 0.5 : 1.0))
                        )
                        .shadow(
                            color: theme.primaryColor.opacity(isCompleted ? 0.0 : 0.24),
                            radius: isIPad ? 14 : 10,
                            x: 0,
                            y: isIPad ? 10 : 6
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(isCompleted)

                    Button(action: resetCounter) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: isIPad ? 16 : 15, weight: .semibold))
                            Text("reset_string", bundle: localizationManager.bundle)
                                .font(.system(size: buttonFontSize, weight: .semibold))
                                .lineLimit(1)
                        }
                        .foregroundStyle(theme.textColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: buttonHeight)
                        .standardCardFrame(
                            theme: theme,
                            cornerRadius: buttonHeight / 2,
                            borderWidth: 1,
                            borderColor: theme.cardBorderColor.opacity(counter == 0 ? 0.7 : 1.0),
                            shadowRadius: isIPad ? 12 : 10,
                            shadowYOffset: isIPad ? 6 : 4
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(counter == 0)
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .standardCardFrame(
                theme: theme,
                cornerRadius: cardCornerRadius,
                borderWidth: 1,
                shadowRadius: counterCardShadowRadius,
                shadowYOffset: counterCardShadowYOffset
            )
            .padding(.horizontal, outerHorizontalPadding)
            .padding(.vertical, isIPad ? 18 : 14)
            .animation(AppAnimation.counterCard, value: counter)
            .onAppear {
                showCompletionHighlight = isCompleted
            }
            .onChange(of: counter) { oldValue, newValue in
                handleCounterChange(from: oldValue, to: newValue)
            }
            .accessibilityElement(children: .contain)
        }
        .sensoryFeedback(.success, trigger: counter) { old, new in
            new >= RitualCounterKind.targetCount && old < RitualCounterKind.targetCount
        }
        .sensoryFeedback(.impact(flexibility: .rigid), trigger: counter) { _, new in
            new == 0
        }
        .sensoryFeedback(.impact(weight: .light), trigger: counter) { old, new in
            new > 0 && new < RitualCounterKind.targetCount && new > old
        }
    }

    private var progressDetails: some View {
        VStack(spacing: isIPad ? 14 : 10) {
            HStack(spacing: isIPad ? 8 : 6) {
                ForEach(1...RitualCounterKind.targetCount, id: \.self) { step in
                    ZStack {
                        Circle()
                            .fill(step <= counter ? AnyShapeStyle(accentGradient) : AnyShapeStyle(theme.cardColor))

                        Circle()
                            .stroke(
                                step <= counter ? theme.primaryColor.opacity(0.0) : theme.cardBorderColor,
                                lineWidth: 1
                            )

                        Text("\(step)")
                            .font(.system(size: isIPad ? 13 : 11, weight: .bold, design: .rounded))
                            .foregroundStyle(step <= counter ? Color.white : theme.textColor.opacity(0.66))
                    }
                    .frame(width: stepIndicatorSize, height: stepIndicatorSize)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func localizedText(_ key: String) -> Text {
        Text(LocalizedStringKey(key), bundle: localizationManager.bundle)
    }

    private func incrementCounter() {
        guard counter < RitualCounterKind.targetCount else { return }
        withAnimation(AppAnimation.counterIncrement) {
            counter += 1
        }
    }

    private func resetCounter() {
        guard counter > 0 else { return }
        withAnimation(AppAnimation.counterDecrement) {
            counter = 0
        }
    }

    private func handleCounterChange(from oldValue: Int, to newValue: Int) {
        if newValue >= RitualCounterKind.targetCount && oldValue < RitualCounterKind.targetCount {
            withAnimation(AppAnimation.completionShow) {
                showCompletionHighlight = true
            }
            return
        }

        if newValue < RitualCounterKind.targetCount {
            withAnimation(AppAnimation.completionHide) {
                showCompletionHighlight = false
            }
        }
    }
}
