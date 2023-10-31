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
    @State var audioPlayer: AVAudioPlayer!
    @State var isPlaying = false
    @State var currentTime: TimeInterval = 0.0
    @State var duration: TimeInterval = 0.0
    @State var isRepeating = false // Added state variable for auto-repeat
    let fileName: String
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                            if let player = self.audioPlayer {
                                if player.isPlaying {
                                    player.pause()
                                } else {
                                    AudioManager.shared.play(audioPlayer: player)
                                }
                                self.isPlaying = !self.isPlaying
                            }
                }) {
                    Image(systemName: self.isPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                        .padding(20)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.green, .gray]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
//                        .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 10)
                } .padding()
                Button(action: {
                    self.isRepeating.toggle()
                    self.audioPlayer.numberOfLoops = self.isRepeating ? -1 : 0
                }) {
                    Image(systemName: self.isRepeating ? "repeat" : "repeat")
                        .foregroundColor(self.isRepeating ? .green : .white)
                        .font(.system(size: 27))
                        .padding(20)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.red, .gray]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
//                        .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 10)
                } .padding()
                
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
                    self.audioPlayer.currentTime = self.currentTime
                }
            ),
                   in: 0...duration,
                   onEditingChanged: { _ in }
            )
            .accentColor(.green)
            
        }
        .padding()
        .onAppear {
            let sound = Bundle.main.path(forResource: fileName, ofType: "mp3")
            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            self.audioPlayer!.prepareToPlay()
            self.duration = self.audioPlayer!.duration
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print(error)
            }
        }

        
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            self.currentTime = self.audioPlayer.currentTime
            if !self.audioPlayer.isPlaying {
                self.isPlaying = false
            }
        }
    }
    

    
    func formatTime(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}



struct Player_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(fileName: "")
    }
}
