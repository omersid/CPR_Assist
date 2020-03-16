//
//  MainPage.swift
//  CPR Assist
//
//  Created by Omer Siddiqui on 3/15/20.
//  Copyright © 2020 Omer Siddiqui. All rights reserved.
//

import UIKit
import AVFoundation

class MainPage: UIViewController {
    //MARK: Settings
    var counter = 0
    var timer = Timer()
    var player: AVAudioPlayer?
    var player2: AVAudioPlayer?
    
    @IBOutlet weak var compressions: UILabel!
    @IBOutlet weak var heartpic: UIImageView!
    
    func setBeatTimer() {
        guard let url = Bundle.main.url(forResource: "beep", withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            player2 = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
        } catch let error {
            print(error.localizedDescription)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        compressions.text = "Compressions \(counter)"
        let interval: Double = 60/100
        setBeatTimer()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: makeNoise)
    }
    
    func makeNoise(t: Timer) {
        counter += 1
        compressions.text = "Compressions: \(counter)"
        if counter%2 != 0{
            player!.play()
            UIView.animate(withDuration: 0.6, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.heartpic.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3) //
                }) { (finished) in
                    UIView.animate(withDuration: 0.6, animations: {
                        self.heartpic.transform = CGAffineTransform.identity
                    })
            }
        }else{
            player2!.play()
        }
        
    }
}
