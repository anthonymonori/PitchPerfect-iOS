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
    
    // References to UI elements
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    
    // Global variables
    var receivedAudio : RecordedAudio!
    var audioPlayerNode : AVAudioPlayerNode!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Make sure the stop button is not enabled from the start
        btnStop.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playSlowAudio(sender: UIButton) {
        // Call the playAudio method with default pitch and the given playback rate / 1.0 = default playback rate
        playAudio(0, rate: 0.5, reverb: 0, echo: 0)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        // Call the playAudio method with default pitch and the given playback rate / 1.0 = default playback rate
        playAudio(0, rate: 1.5, reverb: 0, echo: 0)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        // Stop any audio
        audioPlayerNode.stop()
        // Disable the stop button
        btnStop.enabled = false
    }
    
    @IBAction func playAudioNormal(sender: UIButton) {
        // Call the playAudio method with default pitch and the default playback rate
        playAudio(0, rate: 1, reverb: 0, echo: 0)
    }

    @IBAction func playChipmunkEffect(sender: UIButton) {
        // Call the playAudio method with default playback rate and the given pitch / 0 = default playback rate
        playAudio(1000, rate: 1, reverb: 0, echo: 0)
    }
    
    @IBAction func playDarthVaderEffect(sender: UIButton) {
        // Call the playAudio method with default playback rate and the given pitch / 0 = default playback rate
        playAudio(-1000, rate: 1, reverb: 0, echo: 0)
    }
    
    @IBAction func playEchoEffect(sender: UIButton) {
        playAudio(0, rate: 1, reverb: 0, echo: 0.2)
    }
    
    @IBAction func playReverbEffect(sender: UIButton) {
        playAudio(0, rate: 1, reverb: 50.0, echo: 0)
    }
    
    private func playAudio(pitch : Float, rate: Float, reverb: Float, echo: Float) {
        // Initialize variables
        var audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        
        // Get the recorded audio file
        var audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        // Attach it to the audio segment
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
