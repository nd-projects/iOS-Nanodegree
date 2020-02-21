//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Dunning Nicholas, EV-44 on 21.02.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recodingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func recordAudio(_ sender: Any) {
        recodingLabel.text = "Recording in Progress"
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        recodingLabel.text = "Tab to Record"
    }
    
}

