// File: Services/SoundManager.swift
import AVFoundation
import Foundation

final class SoundManager {
    static let shared = SoundManager()
    
    private var player: AVAudioPlayer?
    
    private init() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }
    }
    
    func play(_ name: String, volume: Float = 0.3) {
        // Try to find the resource in a few bundles (Playgrounds can be weird)
        let bundlesToTry: [Bundle] = [
            .main,
            Bundle(for: SoundManager.self)
        ]
        
        let url: URL? = bundlesToTry.compactMap { bundle in
            bundle.url(forResource: name, withExtension: "mp3")
        }.first
        
        guard let url else {
            print("❌ Sound not found in any bundle: \(name).mp3")
            return
        }
        
        print("✅ Playing sound:", url.lastPathComponent)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = volume
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("❌ AVAudioPlayer error:", error)
        }
    }
}
