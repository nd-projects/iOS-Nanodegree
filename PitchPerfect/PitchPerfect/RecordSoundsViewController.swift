//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Copyright © 2020 nd-projects. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recodingLabel: UILabel!
    @IBOutlet weak var startRecordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }

    @IBAction func recordAudio(_ sender: Any) {
        toggleUIState(recordingActive: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        } catch {
            print(error)
            toggleUIState(recordingActive: false)
        }

        do {
            try audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        } catch {
            print(error)
            toggleUIState(recordingActive: false)
        }
        
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        toggleUIState(recordingActive: false)
        
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    func toggleUIState(recordingActive: Bool) {
        if recordingActive {
            recodingLabel.text = "Recording in Progress"
        } else {
            recodingLabel.text = "Tap to Record"
        }
        
        startRecordingButton.isEnabled = !recordingActive
        stopRecordingButton.isEnabled = recordingActive
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording failed to save")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            guard let playSoundsVC = segue.destination as? PlaySoundsViewController else {
                print("Segue destination was not of type PlaySoundsViewController")
                return
            }
            guard let recordedAudioUrl = sender as? URL else {
                print("sender was not of type URL")
                return
            }
            playSoundsVC.recordedAudioUrl = recordedAudioUrl
        }
    }
}
