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
    var player : AVAudioPlayer!
    var receivedAudio : RecordedAudio!
    var audioEngine : AVAudioEngine!
    var audioFile : AVAudioFile!
    var audioPlayerNode : AVAudioPlayerNode!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        btnStop.enabled = false

        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

        player = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        player.enableRate = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playSlowAudio(sender: UIButton) {
        // play audio at a slow speed
        playAudioAtSpeed(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        // play audio at a fast speed
        playAudioAtSpeed(1.5)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        // Stop any audio
        player.stop()
        audioPlayerNode.stop()
        // Reset audio place
        player.playAtTime(0.0)
        // Disable
        btnStop.enabled = false
    }
    
    private func playAudioAtSpeed(speed:Float) {
        // enable the Stop button
        btnStop.enabled = true
        // Good practice to stop before starting
        player.stop()
        // Change the rate of the player / 1 = normal
        player.rate = speed
        // Play the audio file
        player.play()
    }

    @IBAction func playChipmunkEffect(sender: UIButton) {
        playAudioWithPitch(1000)
    }
    
    @IBAction func playDarthVaderEffect(sender: UIButton) {
        playAudioWithPitch(-1000)
    }
    
    private func playAudioWithPitch(pitch : Float) {
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
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
