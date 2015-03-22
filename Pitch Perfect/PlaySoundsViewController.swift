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
    
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    
    var receivedAudio : RecordedAudio!
    var audioEngine : AVAudioEngine!
    var audioFile : AVAudioFile!
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
        playAudio(0, rate: 0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        // Call the playAudio method with default pitch and the given playback rate / 1.0 = default playback rate
        playAudio(0, rate: 1.5)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        // Stop any audio
        audioPlayerNode.stop()
        // Disable the stop button
        btnStop.enabled = false
    }
    
    @IBAction func playAudioNormal(sender: UIButton) {
        // Call the playAudio method with default pitch and the default playback rate
        playAudio(0, rate: 1)
    }

    @IBAction func playChipmunkEffect(sender: UIButton) {
        // Call the playAudio method with default playback rate and the given pitch / 0 = default playback rate
        playAudio(1000, rate: 1)
    }
    
    @IBAction func playDarthVaderEffect(sender: UIButton) {
        // Call the playAudio method with default playback rate and the given pitch / 0 = default playback rate
        playAudio(-1000, rate: 1)
    }
    
    @IBAction func playEchoEffect(sender: UIButton) {
        playAudio(0, rate: 1)
    }
    
    @IBAction func playReverbEffect(sender: UIButton) {
        playAudio(0, rate: 1)
    }
    
    private func playAudio(pitch : Float, rate: Float) {
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        var changePlaybackRateEffect = AVAudioUnitVarispeed()
        changePlaybackRateEffect.rate = rate
        audioEngine.attachNode(changePlaybackRateEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: changePlaybackRateEffect, format: nil)
        audioEngine.connect(changePlaybackRateEffect, to: audioEngine.outputNode, format: nil)
        
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
