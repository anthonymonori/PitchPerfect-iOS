//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Antal János Monori on 07/03/15.
//  Copyright (c) 2015 Antal János Monori. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    // references to UI elements
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    
    // Global variables
    var receivedAudio : RecordedAudio!
    var audioPlayerNode : AVAudioPlayerNode!
    var audioEngine : AVAudioEngine!
    var audioFile : AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Make sure the stop button is not enabled from the start
        btnStop.enabled = false
        
        // Get the audio file from recorder
        audioFile = AVAudioFile(forReading: receivedAudio.getFilePath(), error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** ***************************** **/
    /// Normal values
    /// =================
    /// Playback rate: 1
    /// Pitch:         0
    /// Reverb:        0
    /// Echo/Interval: 0
    ///
    ///
    /// Ranges values
    /// =================
    /// Playback rate: 0.25 to 4
    /// Pitch:         -2400 to 2400
    /// Reverb:        0 to 100
    /// Echo/Interval: 0 to 2
    /** ***************************** **/
    
    /** Function to play the recording on a slow playback rate **/
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudio(0, rate: 0.5, reverb: 0, echo: 0)
    }
    
    /** Function to play the recording on a fast playback rate **/
    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(0, rate: 1.5, reverb: 0, echo: 0)
    }
    
    /** Function to play the recording with no effects, but the default values **/
    @IBAction func playAudioNormal(sender: UIButton) {
        playAudio(0, rate: 1, reverb: 0, echo: 0)
    }

    /** Function to play the recording on a high pitch effect **/
    @IBAction func playChipmunkEffect(sender: UIButton) {
        playAudio(1000, rate: 1, reverb: 0, echo: 0)
    }
    
    /** Function to play the recording on a low pitch effect **/
    @IBAction func playDarthVaderEffect(sender: UIButton) {
        playAudio(-1000, rate: 1, reverb: 0, echo: 0)
    }
    
    /** Function to play the recording on a echo effect **/
    @IBAction func playEchoEffect(sender: UIButton) {
        playAudio(0, rate: 1, reverb: 0, echo: 0.2)
    }
    
    /** Function to play the recording on a reverb effect **/
    @IBAction func playReverbEffect(sender: UIButton) {
        playAudio(0, rate: 1, reverb: 50.0, echo: 0)
    }
    
    /** Function used to play a recorded audio using different parameters/effects **/
    private func playAudio(pitch : Float, rate: Float, reverb: Float, echo: Float) {
        // Initialize variables
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // Setting the pitch
        var pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = pitch
        audioEngine.attachNode(pitchEffect)
        
        // Setting the platback-rate
        var playbackRateEffect = AVAudioUnitVarispeed()
        playbackRateEffect.rate = rate
        audioEngine.attachNode(playbackRateEffect)
        
        // Setting the reverb effect
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverbEffect.wetDryMix = reverb
        audioEngine.attachNode(reverbEffect)
        
        // Setting the echo effect on a specific interval
        var echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = NSTimeInterval(echo)
        audioEngine.attachNode(echoEffect)

        // Chain all these up, ending with the output
        audioEngine.connect(audioPlayerNode, to: pitchEffect, format: nil)
        audioEngine.connect(pitchEffect, to: playbackRateEffect, format: nil)
        audioEngine.connect(playbackRateEffect, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: echoEffect, format: nil)
        audioEngine.connect(echoEffect, to: audioEngine.outputNode, format: nil)
        
        // enable the Stop button
        btnStop.enabled = true
        
        // Good practice to stop before starting
        audioPlayerNode.stop()
        
        // Play the audio file
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    /** Function used to stop the audio; connected to the UI element **/
    @IBAction func stopAudio(sender: UIButton) {
        // Stop any audio
        audioPlayerNode.stop()
        // Disable the stop button
        btnStop.enabled = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
