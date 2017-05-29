//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Stuart Leach on 5/23/17.
//  Copyright © 2017 leachMusicLLC. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // Prepare UI for new recording
    func setUIState(isRecording: Bool, recordingText: String) {
        recordingLabel.text = recordingText
        stopRecordingButton.isEnabled = isRecording
    }
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        
        
        
        setUIState(isRecording: true, recordingText: "Tap to stop.")
        
        
        // Prepare file to record to
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath ?? true)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        // Begin recording
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
       
    }
    
    // avAudioEngine

    @IBAction func stopRecording(_ sender: Any) {
        
        audioRecorder.stop()

        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        setUIState(isRecording: false, recordingText: "Tap to record.")

    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("finished recording.")
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("failed.")
        }
    }
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
    }
}
}

    

