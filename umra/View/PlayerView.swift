//
//  PlayerView.swift
//  umra
//
//  Created by Akhmed on 06.04.23.
//

import SwiftUI
import AVKit


class AudioManager {
    static let shared = AudioManager()
    private var audioPlayers: [AVAudioPlayer] = []

    func play(audioPlayer: AVAudioPlayer) {
        // Stop all currently playing audio players
        stopAll()

        // Add the new audio player to the list and start playing
        audioPlayers.append(audioPlayer)
        audioPlayer.play()
    }

    func stopAll() {
        // Stop all currently playing audio players and remove them from the list
        for player in audioPlayers {
            player.stop()
        }
        audioPlayers.removeAll()
    }
}



struct PlayerView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var currentTime: TimeInterval = 0.0
    @State private var duration: TimeInterval = 0.0
    @State private var isRepeating = false
    let fileName: String
    
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                controlButton(imageName: self.isPlaying ? "pause.fill" : "play.fill",
                              isActive: self.isPlaying,
                              backgroundColors: [.green, .gray]) {
                    if let player = self.audioPlayer {
                        if player.isPlaying {
                            player.pause()
                        } else {
                            AudioManager.shared.play(audioPlayer: player)
                        }
                        self.isPlaying.toggle()
                    }
                }
                
                controlButton(imageName: "repeat",
                              isActive: self.isRepeating,
                              backgroundColors: [.red, .gray]) {
                    self.isRepeating.toggle()
                    self.audioPlayer?.numberOfLoops = self.isRepeating ? -1 : 0
                }
                
                Spacer()
            }
            .padding(.bottom, 10)
            
            Text(formatTime(time: currentTime))
                .foregroundColor(.gray)
                .font(.system(size: 20))
            
            Slider(value: Binding(
                get: { self.currentTime },
                set: { newValue in
                    self.currentTime = newValue
                    self.audioPlayer?.currentTime = self.currentTime
                }
            ),
                   in: 0...duration,
                   onEditingChanged: { _ in }
            )
            .accentColor(.green)
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
    }
    
    func controlButton(imageName: String, isActive: Bool, backgroundColors: [Color], action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: imageName)
                .foregroundColor(isActive ? .green : .black.opacity(0.8))
                .font(.system(size: 16, weight: .bold))
                .padding(.all, 25)
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
                    .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20))

        }
        .padding()
    }
    
    func formatTime(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func setupAudioPlayer() {
        if let soundPath = Bundle.main.path(forResource: fileName, ofType: "mp3") {
            do {
                let player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath))
                self.audioPlayer = player
                self.audioPlayer?.delegate = coordinator
                self.audioPlayer?.prepareToPlay()
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
    }
}
