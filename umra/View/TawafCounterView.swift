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

    private var progress: CGFloat {
        min(CGFloat(counter) / CGFloat(RitualCounterKind.targetCount), 1)
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

    private var titleFontSize: CGFloat {
        isIPad ? 28 : 22
    }

    private var statusFontSize: CGFloat {
        isIPad ? 17 : 14
    }

    private var buttonFontSize: CGFloat {
        isIPad ? 18 : 16
    }

    private var progressRingSize: CGFloat {
        isIPad ? 168 : 136
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
        statusColor.opacity(theme == .dark ? 0.20 : 0.12)
    }

    private var cardBorderColor: Color {
        statusColor.opacity(theme == .dark ? 0.34 : 0.18)
    }

    private var cardShadowColor: Color {
        isCompleted ? theme.secondaryColor.opacity(0.14) : theme.cardShadowColor
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
                        .animation(.spring(response: 0.38, dampingFraction: 0.76), value: showCompletionHighlight)
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

                ViewThatFits(in: .horizontal) {
                    HStack(alignment: .center, spacing: isIPad ? 22 : 18) {
                        progressRing
                        progressDetails(centered: false)
                    }

                    VStack(spacing: isIPad ? 20 : 16) {
                        progressRing
                        progressDetails(centered: true)
                    }
                }

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
            .background(cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: cardCornerRadius, style: .continuous)
                    .stroke(cardBorderColor, lineWidth: 1)
            )
            .shadow(color: cardShadowColor, radius: isIPad ? 18 : 14, x: 0, y: isIPad ? 10 : 6)
            .padding(.vertical, isIPad ? 18 : 14)
            .animation(.spring(response: 0.35, dampingFraction: 0.82), value: counter)
            .onAppear {
                showCompletionHighlight = isCompleted
            }
            .onChange(of: counter) { oldValue, newValue in
                handleCounterChange(from: oldValue, to: newValue)
            }
            .accessibilityElement(children: .contain)

            LanguageView()
                .hidden()
        }
    }

    @ViewBuilder
    private func progressDetails(centered: Bool) -> some View {
        VStack(alignment: centered ? .center : .leading, spacing: isIPad ? 16 : 12) {
            localizedText(kind.progressLabelKey)
                .font(.system(size: isIPad ? 16 : 14, weight: .medium))
                .foregroundStyle(theme.textColor.opacity(0.72))
                .multilineTextAlignment(centered ? .center : .leading)

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

            HStack(spacing: 10) {
                Text("\(counter)")
                    .font(.system(size: isIPad ? 30 : 24, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(statusColor)
                    .contentTransition(.numericText(value: Double(counter)))

                Text("/ \(RitualCounterKind.targetCount)")
                    .font(.system(size: isIPad ? 18 : 15, weight: .medium, design: .rounded))
                    .foregroundStyle(theme.textColor.opacity(0.58))
                    .monospacedDigit()
            }
        }
        .frame(maxWidth: .infinity, alignment: centered ? .center : .leading)
    }

    private var progressRing: some View {
        ZStack {
            Circle()
                .fill(theme.primaryColor.opacity(theme == .dark ? 0.12 : 0.08))
                .frame(width: progressRingSize, height: progressRingSize)
                .blur(radius: isIPad ? 18 : 14)

            Circle()
                .stroke(theme.primaryColor.opacity(0.12), lineWidth: isIPad ? 13 : 11)

            Circle()
                .trim(from: 0, to: max(progress, 0.001))
                .stroke(
                    accentGradient,
                    style: StrokeStyle(lineWidth: isIPad ? 13 : 11, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            Circle()
                .fill(theme.cardColor)
                .padding(isIPad ? 18 : 14)

            VStack(spacing: 4) {
                Text("\(counter)")
                    .font(.system(size: isIPad ? 38 : 32, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(theme.textColor)
                    .contentTransition(.numericText(value: Double(counter)))
                Text("/ \(RitualCounterKind.targetCount)")
                    .font(.system(size: isIPad ? 16 : 14, weight: .medium, design: .rounded))
                    .foregroundStyle(theme.textColor.opacity(0.55))
                    .monospacedDigit()
            }
        }
        .frame(width: progressRingSize, height: progressRingSize)
        .scaleEffect(showCompletionHighlight ? 1.03 : 1.0)
    }

    private var cardBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cardCornerRadius, style: .continuous)
                .fill(theme.cardColor)

            Circle()
                .fill(theme.primaryColor.opacity(theme == .dark ? 0.16 : 0.08))
                .frame(width: isIPad ? 220 : 170, height: isIPad ? 220 : 170)
                .blur(radius: isIPad ? 28 : 20)
                .offset(x: isIPad ? 90 : 68, y: isIPad ? -80 : -60)

            Circle()
                .fill(theme.secondaryColor.opacity(theme == .dark ? 0.12 : 0.07))
                .frame(width: isIPad ? 180 : 130, height: isIPad ? 180 : 130)
                .blur(radius: isIPad ? 30 : 22)
                .offset(x: isIPad ? -80 : -56, y: isIPad ? 90 : 72)
        }
        .clipShape(RoundedRectangle(cornerRadius: cardCornerRadius, style: .continuous))
    }

    private func localizedText(_ key: String) -> Text {
        Text(LocalizedStringKey(key), bundle: localizationManager.bundle)
    }

    private func incrementCounter() {
        guard counter < RitualCounterKind.targetCount else { return }
        withAnimation(.spring(response: 0.30, dampingFraction: 0.78)) {
            counter += 1
        }
    }

    private func resetCounter() {
        guard counter > 0 else { return }
        withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
            counter = 0
        }
    }

    private func handleCounterChange(from oldValue: Int, to newValue: Int) {
        if newValue >= RitualCounterKind.targetCount && oldValue < RitualCounterKind.targetCount {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            withAnimation(.spring(response: 0.4, dampingFraction: 0.74)) {
                showCompletionHighlight = true
            }
            return
        }

        if newValue == 0 {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        } else {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }

        if newValue < RitualCounterKind.targetCount {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.82)) {
                showCompletionHighlight = false
            }
        }
    }
}
