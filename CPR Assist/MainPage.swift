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
    var beatTimer = Timer()
    var beatPlayer: AVAudioPlayer?
    var beatPlayer2: AVAudioPlayer?
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var compressions: UILabel!
    @IBOutlet weak var heartpic: UIImageView!
    
    @IBOutlet weak var breathText: UILabel!
    @IBOutlet weak var breathNoiseButton: UISwitch!
    @IBOutlet weak var advancedAirwayButton: UISwitch!
    var breathTimer = Timer()
    var breathPlayer: AVAudioPlayer?
    
    var defibtime: Int = 120
    var defibTimer = Timer()
    var defibPulse: Bool = false
    
    
    
    @IBOutlet weak var defibButton: UIButton!
    
    func setBeatPlayer() {
        guard let url = Bundle.main.url(forResource: "beep", withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            beatPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            beatPlayer2 = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func setBreathPlayer() {
        guard let url = Bundle.main.url(forResource: "beep", withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            breathPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func makeNoise(t: Timer) {
        counter += 1
        compressions.text = "Compressions: \(counter)"
        if counter%2 != 0{
            beatPlayer!.play()
            UIView.animate(withDuration: 0.6, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.heartpic.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3) //
                }) { (finished) in
                    UIView.animate(withDuration: 0.6, animations: {
                        self.heartpic.transform = CGAffineTransform.identity
                    })
            }
        }else{
            beatPlayer2!.play()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set default button behavior:
        breathNoiseButton.isOn = false
        advancedAirwayButton.isOn = false
        breathNoiseButton.isHidden = true
        
        // Set settings button icon:
        self.settingsButton.title = NSString(string: "\u{2699}\u{0000FE0E}") as String
        if let font = UIFont(name: "Helvetica", size: 24.0){ self.settingsButton.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
        
        //Rounded corner buttons:
        defibButton.layer.cornerRadius = 4
        
        //Set up players:
        setBeatPlayer()
        setBreathPlayer()
        
        //Get compressions going:
        compressions.text = "Compressions \(counter)"
        let interval: Double = 60/100
        beatTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: makeNoise)
    }
    
    //MARK: Actions
    @IBAction func advancedIn(_ sender: UISwitch) {
        if sender.isOn{
            breathNoiseButton.isHidden = false
            breathText.text = "1 Breath every 6 Seconds"
        }else{
            breathNoiseButton.isHidden = true
            breathTimer.invalidate()
            breathNoiseButton.isOn = false
            breathText.text = "2 Breaths every 30 Compressions"
        }
    }
    @IBAction func breathNoise(_ sender: UISwitch) {
        if sender.isOn{
            breathTimer = Timer.scheduledTimer(withTimeInterval: 6, repeats: true, block: { timer in
                self.breathPlayer!.play()
            })
        }else{
            breathTimer.invalidate()
        }
    }
    
    @IBAction func defibButtonPress(_ sender: UIButton) {
        if !defibPulse{
            defibButton.isEnabled = false
            defibTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block:{ timer in
                self.defibtime -= 1
                if (self.defibtime != 0){
                    let min: Int = self.defibtime/60
                    let sec: Int = self.defibtime%60
                    var p: String = ":"
                    if sec<10{
                        p=":0"
                    }
                    UIView.animate(withDuration: 0, delay: 0.0, animations: {
                        self.defibButton.setTitle( "Check Pulse in \(min)"+p+"\(sec)", for: .normal)
                    })
                }else{
                    self.defibButton.isEnabled = true
                    self.defibButton.setTitle( "Check Pulse!", for: .normal)
                    self.defibtime = 120
                }
            })
        }
        else{
            self.defibButton.setTitle( "AED Shock Given", for: .normal)
        }
        
    }
}
