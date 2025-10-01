//
//  PlayerView.swift
//  umra
//
//  Created by Akhmed on 06.04.23.
//

import AVFoundation
import SwiftUI
import UIKit

class AudioManager {
    static let shared = AudioManager()
    private var audioPlayers: [AVAudioPlayer] = []

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
        audioPlayers.removeAll { $0 === audioPlayer }
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
    @Environment(\.colorScheme) private var colorScheme

    // Адаптивный цвет тени под тему
    private func adaptiveShadowColor(intensity: Double = 0.5) -> Color {
        let clamped = min(max(intensity, 0.0), 1.0)
        if colorScheme == .dark {
            return Color.black.opacity(clamped * 0.55)
        } else {
            return Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)).opacity(clamped)
        }
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
                            AudioManager.shared.play(audioPlayer: player)
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
        }
        .onReceive(Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()) { _ in
            updateProgress()
        }
        .onDisappear {
            stopAudioPlayer()
        }
    }

    func controlButton(imageName: String, isActive: Bool, backgroundColors: [Color], action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }) {
            Image(systemName: imageName)
                .foregroundColor(isActive ? .green : .black.opacity(0.8))
                .font(.system(size: 16, weight: .bold))
                .frame(width: 70, height: 70)
                .background(
                    ZStack {
                        Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))

                        Circle()
                            .foregroundColor(.white)
                            .blur(radius: 4)
                            .offset(x: -8, y: -8)

                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8980392157, green: 0.933333333, blue: 1, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
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
                .foregroundColor(isActive ? .green : .black.opacity(0.8))
                .font(.system(size: 16, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(width: 70, height: 70)
                .background(
                    ZStack {
                        Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))

                        Circle()
                            .foregroundColor(.white)
                            .blur(radius: 4)
                            .offset(x: -8, y: -8)

                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8980392157, green: 0.933333333, blue: 1, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .padding(2)
                    }
                    .clipShape(Circle())
                    .compositingGroup()
                    .shadow(color: adaptiveShadowColor(intensity: 0.5), radius: 20, x: 20, y: 20)
                )
        }
        .padding()
    }

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
        AudioManager.shared.remove(player)
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

struct ThemedSlider: UIViewRepresentable {
    @Binding var value: Double
    var range: ClosedRange<Double>
    var onEditingChanged: (Bool) -> Void = { _ in }

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.isContinuous = true
        slider.minimumValue = Float(range.lowerBound)
        slider.maximumValue = Float(range.upperBound)
        slider.value = Float(value)

        // Цвета трека
        slider.minimumTrackTintColor = .systemGreen
        slider.maximumTrackTintColor = .systemGray

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

        // Цвета не зависят от темы
        uiView.minimumTrackTintColor = .systemGreen
        uiView.maximumTrackTintColor = .systemGray
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

struct Player_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(fileName: "1")
    }
}
