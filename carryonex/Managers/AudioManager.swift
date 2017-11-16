//
//  AudioManager.swift
//  carryonex
//
//  Created by Xin Zou on 11/15/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import AVFoundation

enum SoundEffect: String {
    case success = "success"
    case failed  = "failed"
}

class AudioManager {
    
    static let shared = AudioManager()
    
    private var player = AVAudioPlayer()
    
    private init(){
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print("get error when init AVAudioSession.shared.setCategory, err = \(error)")
        }
    }
    
    
    
    func playSond(named n: SoundEffect) {
        guard let audioPath = Bundle.main.path(forResource: n.rawValue, ofType: "mp3") else { return }
        do{
            player = try AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath) as URL)
            player.prepareToPlay() // load .mp3 into buffer
            player.play()
            
        } catch let error {
            player = AVAudioPlayer() // reset default player
            print("AudioManager get error when init player: err = \(error)")
        }
    }
    
    func stop(){
        player.stop()
    }
    
}
