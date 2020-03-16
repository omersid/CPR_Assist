//
//  ViewController.swift
//  CPR Assist
//
//  Created by Omer Siddiqui on 3/15/20.
//  Copyright © 2020 Omer Siddiqui. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var tutorial: UIButton!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.settingsButton.title = NSString(string: "\u{2699}\u{0000FE0E}") as String
        if let font = UIFont(name: "Helvetica", size: 24.0){ self.settingsButton.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
    }
    //MARK: Actions
    @IBAction func clickTutorial(_ sender: UIButton) {
    }
}
