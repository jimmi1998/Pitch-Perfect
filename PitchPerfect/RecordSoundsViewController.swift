//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Jimit Raval on 04/04/20.
//  Copyright © 2020 Mango. All rights reserved.
//

import UIKit
// MARK: - Importing Audio Video Foundation library
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // MARK: - Creating optional audioRecorder variable
    var audioRecorder: AVAudioRecorder!
    
    // MARK: - Creating IBOutlets for buttons and lables
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    func configureUI(_ enabled:Bool) {
        
        recordButton.isEnabled = !enabled
        stopRecordingButton.isEnabled = enabled
        recordingLabel.text = enabled ? "Recording in progress": "Tap to Record"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }

    // MARK: - Creating IBActions for the Start button on the UI to start recording audio
    @IBAction func recordAudio(_ sender: Any) {
        
        configureUI(true)

        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    // MARK: - Creating IBActions for the stop button on the UI to stop recording audio
    @IBAction func stopRecording(_ sender: Any) {
        
        configureUI(false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording was not successful")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playsoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playsoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}
