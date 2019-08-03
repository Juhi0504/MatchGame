//
//  SoundManager.swift
//  MatchGame
//
//  Created by Juhi A on 8/2/19.
//  Copyright © 2019 Juhi A. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var audioPlayer:AVAudioPlayer?
    
    enum Sound{
        case flip
        case shuffle
        case match
        case noMatch
    }
    
    func Play(_ soundEffect:Sound)
    {
        var soundName = ""
        
        switch soundEffect {
        case .flip:
            soundName = "cardflip"
            break
        case .shuffle:
            soundName = "shuffle"
            break
        case .match:
            soundName = "dingcorrect"
            break
        case .noMatch:
            soundName = "dingwrong"
            break
        default:
            break
        }
        
        let path = Bundle.main.path(forResource: soundName, ofType: "wav")
        
        guard path != nil else {
            print("sound missing")
            return
        }
        
        let soundURL = URL(fileURLWithPath: path!)
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        }
        catch
        {
            print("issue")
        }
    }
}
