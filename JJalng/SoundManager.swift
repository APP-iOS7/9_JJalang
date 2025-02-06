//
//  SoundManager.swift
//  JJalng
//
//  Created by Saebyeok Jang on 2/6/25.
//

import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    private var audioPlayer: AVAudioPlayer?

    func playSound(sound: String, type: String = "mp3") {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Error: Could not play sound file \(sound).\(type)")
            }
        } else {
            print("Error: Sound file \(sound).\(type) not found")
        }
    }
}
