//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Antal János Monori on 07/03/15.
//  Copyright (c) 2015 Antal János Monori. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var lblRecording : UILabel!
    @IBOutlet weak var btnStop : UIButton!
    @IBOutlet weak var btnRecord : UIButton!
    var audioRecorder : AVAudioRecorder!
    var recordedAudio : RecordedAudio!
    
    /** Lifecylcle methods **/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        // Make sure the stop button is hidden from the start; only enable it once the recording has started
        btnStop.hidden = true
        
        // Make sure the recording button is enabled
        btnRecord.enabled = true
        
        // Make sure the label is not hidden and the proper text is set
        lblRecording.hidden = false
        lblRecording.text = "Tap to record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func recordAudio(sender: UIButton) {
        // Show text "recording in progress"
        lblRecording.text = "Recording in progress"
        
        // Make sure the stop button is visible
        btnStop.hidden = false
        
        // Make sure the record button is disabled until the current recording is ongoing
        btnRecord.enabled = false
        
        /** Start recording the user's voice **/
        // Set the path where to save the recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        // Get the current date which will be used as the name of the file
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        // Combine the directory and filename by putting them into an array
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        // Debugging purposes; print the filepath
        println(filePath)
        
        // Create a session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        // Set the filepath and start recording
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true // turns level metering on
        audioRecorder.record()
    }
    
    /** Called when the recording has been finished; this method is actually saving the file**/
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        // If successful
        if (flag) {
            // Save the recorded audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
        
            // Move to the next screen
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
    
    /** This method is used to perform transitions to next views **/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC : PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio!
            playSoundsVC.receivedAudio = data
        }
    }

    /** Stop recording and reset state **/
    @IBAction func stopRecording(sender: UIButton) {
        // Change "recording in progress" label to "Tap to record"; make sure it's visible
        lblRecording.hidden = false
        lblRecording.text = "Tap to record"
        
        // Stop the recording session
        audioRecorder.stop()
        
        // Hide stop button
        btnStop.hidden = true
    }
}

