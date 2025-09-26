//
//  PlayerView.swift
//  umra
//
//  Created by Akhmed on 06.04.23.
//

import AVKit
import SwiftUI
import UIKit

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

// Кастомный UISlider для контроля цветов дорожки + «стеклянный» ползунок
private struct CustomSlider: UIViewRepresentable {
    @Binding var value: Double
    var range: ClosedRange<Double>
    var minimumTrackTintColor: UIColor = .systemGreen
    var maximumTrackTintColor: UIColor = UIColor.black.withAlphaComponent(0.25)
    var onEditingChanged: ((Bool) -> Void)? = nil

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.minimumValue = Float(range.lowerBound)
        slider.maximumValue = Float(range.upperBound)
        slider.value = Float(value)
        slider.minimumTrackTintColor = minimumTrackTintColor
        slider.maximumTrackTintColor = maximumTrackTintColor

        // «Стеклянный» ползунок (thumb)
        let diameter: CGFloat = 26
        slider.setThumbImage(makeGlassThumbImage(diameter: diameter, strokeWidth: 1.0), for: .normal)
        slider.setThumbImage(makeGlassThumbImage(diameter: diameter, strokeWidth: 2.0), for: .highlighted)

        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:for:)), for: .valueChanged)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.touchDown), for: .touchDown)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.touchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])

        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.minimumValue = Float(range.lowerBound)
        uiView.maximumValue = Float(range.upperBound)

        // Обновляем значение без лишних событий
        if abs(Double(uiView.value) - value) > 0.0001 {
            uiView.setValue(Float(value), animated: false)
        }

        uiView.minimumTrackTintColor = minimumTrackTintColor
        uiView.maximumTrackTintColor = maximumTrackTintColor

        // На случай смены trait'ов/темы — переустановим изображения ползунка
        let diameter: CGFloat = 26
        uiView.setThumbImage(makeGlassThumbImage(diameter: diameter, strokeWidth: 1.0), for: .normal)
        uiView.setThumbImage(makeGlassThumbImage(diameter: diameter, strokeWidth: 2.0), for: .highlighted)
    }

    // Рисуем «стеклянный» круглый ползунок
    private func makeGlassThumbImage(diameter: CGFloat, strokeWidth: CGFloat) -> UIImage {
        let size = CGSize(width: diameter, height: diameter)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            let rect = CGRect(origin: .zero, size: size)
            let circleRect = rect.insetBy(dx: strokeWidth / 2, dy: strokeWidth / 2)
            let cg = ctx.cgContext

            // Клип по кругу
            cg.saveGState()
            cg.addEllipse(in: circleRect)
            cg.clip()

            // Полупрозрачная «стеклянная» заливка
            cg.setFillColor(UIColor.white.withAlphaComponent(0.22).cgColor)
            cg.fill(circleRect)

            // Мягкая радиальная подсветка сверху-слева
            let colors = [UIColor.white.withAlphaComponent(0.35).cgColor,
                          UIColor.white.withAlphaComponent(0.0).cgColor] as CFArray
            let locations: [CGFloat] = [0.0, 1.0]
            if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: locations) {
                let center = CGPoint(x: circleRect.minX + circleRect.width * 0.35,
                                     y: circleRect.minY + circleRect.height * 0.35)
                cg.drawRadialGradient(gradient,
                                      startCenter: center, startRadius: 0,
                                      endCenter: center, endRadius: circleRect.width * 0.6,
                                      options: .drawsBeforeStartLocation)
            }
            cg.restoreGState()

            // Светлая обводка
            let path = UIBezierPath(ovalIn: circleRect)
            UIColor.white.withAlphaComponent(0.7).setStroke()
            path.lineWidth = strokeWidth
            path.stroke()
        }
    }

    class Coordinator: NSObject {
        var parent: CustomSlider
        init(_ parent: CustomSlider) { self.parent = parent }

        @objc func valueChanged(_ sender: UISlider, for event: UIEvent) {
            parent.value = Double(sender.value)
        }

        @objc func touchDown() {
            parent.onEditingChanged?(true)
        }

        @objc func touchUp() {
            parent.onEditingChanged?(false)
        }
    }
}

class AudioManager {
    static let shared = AudioManager()
    private var audioPlayers: [AVAudioPlayer] = []

    func play(audioPlayer: AVAudioPlayer) {
        if let currentPlayer = audioPlayers.first, currentPlayer != audioPlayer {
            stopAll()
        }
        if !audioPlayers.contains(audioPlayer) {
            audioPlayers.append(audioPlayer)
        }
        audioPlayer.enableRate = true
        audioPlayer.play()
    }

    func stopAll() {
        for player in audioPlayers {
            if player.isPlaying {
                player.stop()
                player.currentTime = 0
            }
        }
        audioPlayers.removeAll()
    }

    func deactivateAudioSession() {
        let anyPlayerIsPlaying = audioPlayers.contains { $0.isPlaying }
        if anyPlayerIsPlaying {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error deactivating audio session: \(error)")
        }
    }
}

struct PlayerView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var currentTime: TimeInterval = 0.0
    @State private var duration: TimeInterval = 0.0
    @State private var isRepeating = false
    @State private var playbackRate: Float = 1.0
    let fileName: String

    @StateObject private var coordinator = Coordinator()

    var body: some View {
        VStack(spacing: 16) {
            // Панель с кнопками
            HStack(spacing: 0) {
                Spacer()
                controlButton(imageName: "repeat",
                              isActive: self.isRepeating) {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        self.isRepeating.toggle()
                        self.audioPlayer?.numberOfLoops = self.isRepeating ? -1 : 0
                    }
                }

                controlButton(imageName: self.isPlaying ? "pause.fill" : "play.fill",
                              isActive: self.isPlaying) {
                    if let player = self.audioPlayer {
                        if player.isPlaying {
                            player.pause()
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                self.isPlaying = false
                            }
                        } else {
                            AudioManager.shared.play(audioPlayer: player)
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                self.isPlaying = true
                            }
                        }
                    }
                }

                controlButtonWithText(text: "\(playbackRate)x",
                                      isActive: playbackRate > 1.0) {
                    cyclePlaybackRate()
                }
                Spacer()
            }
            .padding(.bottom, 6)

            // Стеклянный контейнер под слайдером
            VStack {
                CustomSlider(
                    value: Binding(
                        get: { self.currentTime },
                        set: { newValue in
                            self.currentTime = newValue
                            self.audioPlayer?.currentTime = self.currentTime
                        }
                    ),
                    range: 0...max(duration, 0.001),
                    minimumTrackTintColor: .systemGreen,
                    maximumTrackTintColor: UIColor.black.withAlphaComponent(0.25)
                )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                // Всегда светлый "жидкий стеклянный" фон
                LightBlurView()
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(
                        LinearGradient(colors: [
                            Color.white.opacity(0.65),
                            Color.white.opacity(0.15)
                        ], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(0.10), radius: 18, x: 0, y: 10)
            .shadow(color: Color.white.opacity(0.12), radius: 1, x: 0, y: 1)
        }
        .padding()
        .onAppear {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Failed to activate audio session: \(error)")
            }
            coordinator.onFinishPlaying = {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    self.isPlaying = false
                }
            }
            setupAudioPlayer()
        }
        .onReceive(Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()) { _ in
            updateProgress()
        }
        .onDisappear {
            stopAudioPlayer()
            AudioManager.shared.deactivateAudioSession()
        }
    }

    // MARK: - Glass Buttons

    func controlButton(imageName: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }) {
            Image(systemName: imageName)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(isActive ? Color.green : Color.black.opacity(0.85))
                .font(.system(size: 22, weight: .semibold))
                .frame(width: 72, height: 72)
                .background(glassCircleBackground)
                .overlay(glassCircleStroke(isActive: isActive))
                .overlay(glassHighlight)
        }
        .buttonStyle(.plain)
        .contentShape(Circle())
        .shadow(color: Color.black.opacity(0.10), radius: 18, x: 0, y: 10)
        .shadow(color: Color.white.opacity(0.12), radius: 1, x: 0, y: 1)
        .padding()
    }

    func controlButtonWithText(text: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
            let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            impactFeedbackGenerator.impactOccurred()
        }) {
            Text(text)
                .foregroundColor(isActive ? .green : .black.opacity(0.85))
                .font(.system(size: 18, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(width: 72, height: 72)
                .background(glassCircleBackground)
                .overlay(glassCircleStroke(isActive: isActive))
                .overlay(glassHighlight)
        }
        .buttonStyle(.plain)
        .contentShape(Circle())
        .shadow(color: Color.black.opacity(0.10), radius: 18, x: 0, y: 10)
        .shadow(color: Color.white.opacity(0.12), radius: 1, x: 0, y: 1)
        .padding()
    }

    @ViewBuilder
    private var glassCircleBackground: some View {
        // Всегда светлое "жидкое стекло" под кнопками
        LightBlurView()
            .clipShape(Circle())
    }

    private func glassCircleStroke(isActive: Bool) -> some View {
        Circle()
            .strokeBorder(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.75),
                        Color.white.opacity(0.15)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: isActive ? 2 : 1
            )
    }

    private var glassHighlight: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [Color.white.opacity(0.28), .clear],
                    center: .topLeading,
                    startRadius: 0,
                    endRadius: 80
                )
            )
            .blur(radius: 10)
            .allowsHitTesting(false)
    }

    // MARK: - Playback

    func cyclePlaybackRate() {
        guard let player = audioPlayer else { return }

        switch playbackRate {
        case 1.0:
            playbackRate = 1.5
        case 1.5:
            playbackRate = 2.0
        default:
            playbackRate = 1.0
        }

        player.rate = playbackRate

        if !player.isPlaying {
            player.play()
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                isPlaying = true
            }
        }
    }

    func setupAudioPlayer() {
        if let soundPath = Bundle.main.path(forResource: fileName, ofType: "mp3") {
            do {
                let player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath))
                self.audioPlayer = player
                self.audioPlayer?.delegate = coordinator
                self.audioPlayer?.prepareToPlay()
                self.audioPlayer?.enableRate = true
                self.duration = player.duration
            } catch {
                print("Error initializing audio player: \(error)")
            }
        } else {
            print("Audio file not found")
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to activate audio session: \(error)")
        }
    }

    func updateProgress() {
        guard let player = audioPlayer else { return }
        self.currentTime = player.currentTime
        if !player.isPlaying {
            self.isPlaying = false
        }
    }

    func stopAudioPlayer() {
        guard let player = audioPlayer else { return }
        if player.isPlaying {
            player.stop()
            player.currentTime = 0
        }
        isPlaying = false
        AudioManager.shared.deactivateAudioSession()
    }

    class Coordinator: NSObject, AVAudioPlayerDelegate, ObservableObject {
        var onFinishPlaying: (() -> Void)?

        func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            DispatchQueue.main.async {
                self.onFinishPlaying?()
            }
        }
    }
}

struct Player_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(fileName: "1")
            .preferredColorScheme(.dark)
            .padding()
            .background(
                LinearGradient(colors: [Color.blue.opacity(0.25), Color.indigo.opacity(0.25)], startPoint: .top, endPoint: .bottom)
            )
    }
}
