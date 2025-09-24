//
//  PlayerView.swift
//  umra
//
//  Created by Akhmed on 06.04.23.
//

import AVKit
import SwiftUI
import UIKit

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
                Slider(value: Binding(
                    get: { self.currentTime },
                    set: { newValue in
                        self.currentTime = newValue
                        self.audioPlayer?.currentTime = self.currentTime
                    }
                ),
                       in: 0...max(duration, 0.001),
                       onEditingChanged: { _ in }
                )
                .tint(.green)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                Group {
                    if #available(iOS 15.0, *) {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(.ultraThinMaterial)
                    } else {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white.opacity(0.25))
                    }
                }
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
                .foregroundStyle(isActive ? Color.green : Color.primary.opacity(0.85))
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
                .foregroundColor(isActive ? .green : .primary.opacity(0.85))
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
        Group {
            if #available(iOS 15.0, *) {
                Circle().fill(.ultraThinMaterial)
            } else {
                Circle().fill(Color.white.opacity(0.28))
            }
        }
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
