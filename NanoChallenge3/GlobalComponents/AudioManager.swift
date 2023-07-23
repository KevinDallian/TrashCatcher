//
//  AudioManager.swift
//  NanoChallenge3-tvOS
//
//  Created by Kevin Dallian on 23/07/23.
//

import Foundation
import AVFoundation

class AudioManager {
    var isMuted = false
    private var audioPlayerBackground : AVAudioPlayer!
    private var soundtrackPlayer : AVAudioPlayer!
    
    static var shared : AudioManager = AudioManager()
    
    private init(){
        self.audioPlayerBackground = AVAudioPlayer()
    }
    
    func setupAudio(resourceName:String, audioType: AudioType, ofType:String, shouldLoop:Bool, volume:Float){
        if audioType == .background{
            audioPlayerBackground = AVAudioPlayer.setupAudioPlayer(resourceName: resourceName, ofType: ofType, shouldLoop: shouldLoop, volume: volume)
        }else if audioType == .soundtrack{
            soundtrackPlayer = AVAudioPlayer.setupAudioPlayer(resourceName: resourceName, ofType: ofType, shouldLoop: false, volume: volume)
        }
    }
    
    func playSound(audioType: AudioType){
        if audioType == .background {
            audioPlayerBackground.play()
        }else if audioType == .soundtrack{
            soundtrackPlayer.play()
        }
    }
    
    func stopBackground(){
        audioPlayerBackground.stop()
    }
    
    func pauseBackground(){
        audioPlayerBackground.pause()
    }
}

enum AudioType{
    case background
    case soundtrack
}

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

