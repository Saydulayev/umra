//
//  PlayerView.swift
//  umra
//
//  Created by Akhmed on 06.04.23.
//

import ActivityKit
import AVKit
import SwiftUI


struct PlayerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var trackName: String
        var progress: Double
    }

    var trackTitle: String
}

class AudioManager {
    static let shared = AudioManager()
    private var audioPlayers: [AVAudioPlayer] = []

    func play(audioPlayer: AVAudioPlayer) {
        stopAll()
        audioPlayers.append(audioPlayer)
        audioPlayer.enableRate = true // Enable rate change
        audioPlayer.play()
    }

    func stopAll() {
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
    @State private var playbackRate: Float = 1.0 // Track playback speed
    let fileName: String
    
    @StateObject private var coordinator = Coordinator()
    
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
                        } else {
                            AudioManager.shared.play(audioPlayer: player)
                        }
                        self.isPlaying.toggle()
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
    
    // Function for control button with an icon
    func controlButton(imageName: String, isActive: Bool, backgroundColors: [Color], action: @escaping () -> Void) -> some View {
        Button(action: action) {
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
                    .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20)
                )
        }
        .padding()
    }

    // Function for control button that displays text instead of an icon
    func controlButtonWithText(text: String, isActive: Bool, backgroundColors: [Color], action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
            // Добавляем вибрацию при нажатии кнопки
            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
            impactFeedbackgenerator.impactOccurred()
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
                    .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20)
                )
        }
        .padding()
    }
    
    func cyclePlaybackRate() {
        if let player = audioPlayer {
            switch playbackRate {
            case 1.0:
                playbackRate = 1.5
            case 1.5:
                playbackRate = 2.0
            default:
                playbackRate = 1.0
            }
            player.rate = playbackRate
            if player.isPlaying {
                player.play() // Restart to apply rate
            }
        }
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
                self.audioPlayer?.enableRate = true // Enable rate change
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
