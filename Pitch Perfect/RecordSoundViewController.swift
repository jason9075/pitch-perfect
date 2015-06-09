//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by jason9075 on 2015/6/8.
//  Copyright (c) 2015年 Jason Kuan. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController,AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingInProcess: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        pauseButton.hidden = true
        recordingInProcess.hidden = false
        recordingInProcess.text = "Tap to Record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        stopButton.hidden = false
        pauseButton.hidden = false
        recordingInProcess.hidden = false
        recordButton.enabled = false
        
        recordingInProcess.text = "recording..."
        
        //Record user voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            //Save record audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
        
            //Move to next scene
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("record was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
            pauseButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
 
    @IBAction func stopRecording(sender: UIButton) {
        recordButton.enabled = true
        recordingInProcess.hidden = true
        
        //Inside func stopAudio(sender: UIButton)
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        if(audioRecorder.recording){
            audioRecorder.pause()
            let imagePlay = UIImage(named: "play") as UIImage?
            pauseButton.setImage(imagePlay, forState: UIControlState.Normal)
            stopButton.hidden = true
            recordingInProcess.text = "Pause"
        }else{
            audioRecorder.record()
            let imagePlay = UIImage(named: "pause") as UIImage?
            pauseButton.setImage(imagePlay, forState: UIControlState.Normal)
            stopButton.hidden = false
            recordingInProcess.text = "recording..."
        }
    }

}

