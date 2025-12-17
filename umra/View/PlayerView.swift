//
//  PlayerView.swift
//  umra
//
//  Created by Akhmed on 06.04.23.
//

import AVFoundation
import OSLog
import SwiftUI
import UIKit

// MARK: - Audio Error

enum AudioError: LocalizedError {
    case initializationFailed(Error)
    case fileNotFound(String)
    case sessionActivationFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .initializationFailed(let error):
            return "Failed to initialize audio player: \(error.localizedDescription)"
        case .fileNotFound(let fileName):
            return "Audio file not found: \(fileName)"
        case .sessionActivationFailed(let error):
            return "Failed to activate audio session: \(error.localizedDescription)"
        }
    }
}

// MARK: - Audio Management

@MainActor
@Observable
class AudioManager {
    private var audioPlayers: [AVAudioPlayer] = []
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.umra.app", category: "AudioManager")

    func play(audioPlayer: AVAudioPlayer) {
        if let currentPlayer = audioPlayers.first, currentPlayer !== audioPlayer {
            stopAll()
        }
        if !audioPlayers.contains(where: { $0 === audioPlayer }) {
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

    func remove(_ audioPlayer: AVAudioPlayer) {
        if let index = audioPlayers.firstIndex(where: { $0 === audioPlayer }) {
            audioPlayers.remove(at: index)
        }
    }

    func deactivateAudioSession() {
        let anyPlayerIsPlaying = audioPlayers.contains { $0.isPlaying }
        if anyPlayerIsPlaying {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
            audioPlayers.removeAll()
        } catch {
            logger.error("Error deactivating audio session: \(error.localizedDescription, privacy: .public)")
        }
    }
}

// MARK: - Player View

struct PlayerView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var currentTime: TimeInterval = 0.0
    @State private var duration: TimeInterval = 0.0
    @State private var isRepeating = false
    @State private var playbackRate: Float = 1.0
    @State private var progressTask: Task<Void, Never>?
    let fileName: String

    @State private var coordinator = Coordinator()
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(AudioManager.self) private var audioManager
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.umra.app", category: "PlayerView")

    // MARK: - UI Helpers
    
    // Цвет тени - всегда как в темной теме, независимо от системной темы
    private func adaptiveShadowColor(intensity: Double = 0.5) -> Color {
        let clamped = min(max(intensity, 0.0), 1.0)
        // Всегда используем прозрачность как в темной теме (0.55)
        return Color.black.opacity(clamped * 0.55)
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                controlButton(imageName: "repeat",
                              isActive: self.isRepeating,
                              backgroundColors: [.red, .gray]) {
                    self.isRepeating.toggle()
                    self.audioPlayer?.numberOfLoops = self.isRepeating ? -1 : 0
                }

                controlButton(imageName: self.isPlaying ? "pause.fill" : "play.fill",
                              isActive: self.isPlaying,
                              backgroundColors: [.green, .gray]) {
                    if let player = self.audioPlayer {
                        if player.isPlaying {
                            player.pause()
                            self.isPlaying = false
                        } else {
                            // Гарантируем старт на выбранной скорости
                            player.enableRate = true
                            player.rate = playbackRate
                            audioManager.play(audioPlayer: player)
                            self.isPlaying = true
                        }
                    }
                }

                controlButtonWithText(text: "\(playbackRate)x",
                                      isActive: playbackRate > 1.0,
                                      backgroundColors: [.blue, .gray]) {
                    cyclePlaybackRate()
                }

                Spacer()
            }
            .padding(.bottom, 10)

            ThemedSlider(
                value: Binding(
                    get: { self.currentTime },
                    set: { newValue in
                        self.currentTime = newValue
                        self.audioPlayer?.currentTime = self.currentTime
                    }
                ),
                range: 0...duration,
                onEditingChanged: { _ in }
            )
        }
        .padding()
        .onAppear {
            coordinator.onFinishPlaying = {
                self.isPlaying = false
            }
            setupAudioPlayer()
            startProgressTimer()
        }
        .onDisappear {
            progressTask?.cancel()
            progressTask = nil
            stopAudioPlayer()
        }
    }

    // MARK: - UI Components
    
    func controlButton(imageName: String, isActive: Bool, backgroundColors: [Color], action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }) {
            Image(systemName: imageName)
                .foregroundColor(isActive ? themeManager.selectedTheme.activeButtonColor : themeManager.selectedTheme.textColor)
                .font(.system(size: 16, weight: .bold))
                .frame(width: 70, height: 70)
                .background(
                    ZStack {
                        themeManager.selectedTheme.primaryColor.opacity(0.2)

                        Circle()
                            .foregroundColor(.white)
                            .blur(radius: 4)
                            .offset(x: -8, y: -8)

                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [themeManager.selectedTheme.gradientTopColor, themeManager.selectedTheme.gradientBottomColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .padding(2)
                    }
                    .clipShape(Circle())
                    .compositingGroup()
                    .shadow(color: adaptiveShadowColor(intensity: 0.5), radius: 20, x: 20, y: 20)
                )
        }
        .padding()
    }

    func controlButtonWithText(text: String, isActive: Bool, backgroundColors: [Color], action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
            let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            impactFeedbackGenerator.impactOccurred()
        }) {
            Text(text)
                .foregroundColor(isActive ? themeManager.selectedTheme.activeButtonColor : themeManager.selectedTheme.textColor)
                .font(.system(size: 16, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(width: 70, height: 70)
                .background(
                    ZStack {
                        themeManager.selectedTheme.primaryColor.opacity(0.2)

                        Circle()
                            .foregroundColor(.white)
                            .blur(radius: 4)
                            .offset(x: -8, y: -8)

                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [themeManager.selectedTheme.gradientTopColor, themeManager.selectedTheme.gradientBottomColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .padding(2)
                    }
                    .clipShape(Circle())
                    .compositingGroup()
                    .shadow(color: adaptiveShadowColor(intensity: 0.5), radius: 20, x: 20, y: 20)
                )
        }
        .padding()
    }

    // MARK: - Audio Management
    
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

        player.enableRate = true
        player.rate = playbackRate

        if !player.isPlaying {
            player.play()
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
                let audioError = AudioError.initializationFailed(error)
                logger.error("\(audioError.errorDescription ?? "Unknown error", privacy: .public)")
            }
        } else {
            let audioError = AudioError.fileNotFound(fileName)
            logger.error("\(audioError.errorDescription ?? "Unknown error", privacy: .public)")
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            let audioError = AudioError.sessionActivationFailed(error)
            logger.error("\(audioError.errorDescription ?? "Unknown error", privacy: .public)")
        }
    }

    func startProgressTimer() {
        progressTask = Task { @MainActor in
            while !Task.isCancelled {
                updateProgress()
                do {
                    try await Task.sleep(for: .milliseconds(20))
                } catch {
                    break
                }
            }
        }
    }
    
    @MainActor
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
        audioManager.remove(player)
        audioManager.deactivateAudioSession()
    }

    // MARK: - Coordinator Pattern
    
    class Coordinator: NSObject, AVAudioPlayerDelegate {
        var onFinishPlaying: (() -> Void)?

        nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            Task { @MainActor in
                onFinishPlaying?()
            }
        }
    }
}

// MARK: - Themed Slider

struct ThemedSlider: UIViewRepresentable {
    @Binding var value: Double
    var range: ClosedRange<Double>
    var onEditingChanged: (Bool) -> Void = { _ in }
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.isContinuous = true
        slider.minimumValue = Float(range.lowerBound)
        slider.maximumValue = Float(range.upperBound)
        slider.value = Float(value)

        // Цвета трека
        slider.minimumTrackTintColor = UIColor(themeManager.selectedTheme.primaryColor)
        slider.maximumTrackTintColor = UIColor(themeManager.selectedTheme.primaryColor.opacity(0.3))

        // События
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:for:)), for: .valueChanged)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.touchDown(_:)), for: .touchDown)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.touchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])

        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.minimumValue = Float(range.lowerBound)
        uiView.maximumValue = Float(range.upperBound)

        if uiView.value != Float(value) {
            uiView.value = Float(value)
        }

        // Цвета зависят от темы
        uiView.minimumTrackTintColor = UIColor(themeManager.selectedTheme.primaryColor)
        uiView.maximumTrackTintColor = UIColor(themeManager.selectedTheme.primaryColor.opacity(0.3))
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: ThemedSlider

        init(_ parent: ThemedSlider) {
            self.parent = parent
        }

        @objc func valueChanged(_ sender: UISlider, for event: UIEvent) {
            parent.value = Double(sender.value)
            parent.onEditingChanged(sender.isTracking)
        }

        @objc func touchDown(_ sender: UISlider) {
            parent.onEditingChanged(true)
        }

        @objc func touchUp(_ sender: UISlider) {
            parent.onEditingChanged(false)
        }
    }
}

#Preview {
    PlayerView(fileName: "1")
}
