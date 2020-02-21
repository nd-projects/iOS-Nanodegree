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
    @IBOutlet weak var startRecordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //
    }

    @IBAction func recordAudio(_ sender: Any) {
        recodingLabel.text = "Recording in Progress"
        startRecordingButton.isEnabled = false
        stopRecordingButton.isEnabled = true
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        recodingLabel.text = "Tab to Record"
        startRecordingButton.isEnabled = true
        stopRecordingButton.isEnabled = false
    }
    
}

