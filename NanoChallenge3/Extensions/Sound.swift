//
//  Sound.swift
//  NanoChallenge3-tvOS
//
//  Created by Muhammad Athif on 22/07/23.
//
import UIKit
import AVFoundation

extension AVAudioPlayer {
    static func setupAudioPlayer(resourceName: String, ofType fileType: String, shouldLoop: Bool, volume: Float) -> AVAudioPlayer? {
        if let audioFilePath = Bundle.main.path(forResource: resourceName, ofType: fileType) {
            let audioFileURL = URL(fileURLWithPath: audioFilePath)
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
                audioPlayer.prepareToPlay()
                audioPlayer.numberOfLoops = shouldLoop ? -1 : 0
                audioPlayer.volume = volume
                return audioPlayer
            } catch {
                print("Error loading audio file: \(error)")
                return nil
            }
        }
        return nil
    }
}
