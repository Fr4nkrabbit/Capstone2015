//
//  Metronome.swift
//  FermataBeta
//
//  Created by Young Liu on 1/30/16.
//  Copyright © 2016 Young Liu. All rights reserved.
//

//Eugene

import UIKit

import AVFoundation

class MetronomeViewController: UIViewController {
    
    @IBOutlet weak var tempoTextField: UITextField!
    
    @IBOutlet weak var tempoStepper: UIStepper!

    var metronomeTimer: NSTimer!
    
    var metronomeIsOn = false
    
    var metronomeSoundPlayer: AVAudioPlayer!
    
    var tempo: NSTimeInterval = 60 {
        didSet {
            tempoTextField.text = String(format: "%.0f", tempo)
            tempoStepper.value = Double(tempo)
        }
    }
    
    @IBAction func tempoChanged(tempoStepper: UIStepper) {
        // Save the new tempo.
        tempo = tempoStepper.value
    }
    
    @IBAction func toggleMetronome(toggleMetronomeButton: UIButton) {
        // If the metronome is currently on, stop the metronome and change
        // the image of the toggle metronome button to the "Play" image and
        // its tint color to green.
        if metronomeIsOn {
            // Mark the metronome as off.
            metronomeIsOn = false
            
            // Stop the metronome.
            metronomeTimer?.invalidate()
            
            // Change the toggle metronome button's image to "Play" and tint
            // color to green.
            toggleMetronomeButton.setImage(UIImage(named: "Play"), forState: .Normal)
            toggleMetronomeButton.tintColor = UIColor.greenColor()
            
            // Enable the metronome stepper.
            tempoStepper.enabled = true
            
            // Enable editing the tempo text field.
            tempoTextField.enabled = true
        }
            
            // If the metronome is currently off, start the metronome and change
            // the image of the toggle metronome button to the "Start" image and
            // its tint color to green
        else {
            // Mark the metronome as on.
            metronomeIsOn = true
            
            // Start the metronome.
            let metronomeTimeInterval:NSTimeInterval = 60.0 / tempo
            metronomeTimer = NSTimer.scheduledTimerWithTimeInterval(metronomeTimeInterval, target: self, selector: Selector("playMetronomeSound"), userInfo: nil, repeats: true)
            metronomeTimer?.fire()
            
            // Change the toggle metronome button's image to "Stop" and tint
            // color to red.
            toggleMetronomeButton.setImage(UIImage(named: "Stop"), forState: .Normal)
            toggleMetronomeButton.tintColor = UIColor.redColor()
            
            // Disable the metronome stepper.
            tempoStepper.enabled = false
            
            // Hide the keyboard
            tempoTextField.resignFirstResponder()
            
            // Disable editing the tempo text field.
            tempoTextField.enabled = false
        }
    }
    
    
    func playMetronomeSound() {
        let currentTime = CFAbsoluteTimeGetCurrent()
        print("Play metronome sound @ \(currentTime)")
        
        metronomeSoundPlayer.play()
    }
    
    // MARK: - UIViewController
    // MARK: Managing the View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the inital value of the tempo.
        tempo = 120
        
        // Initialize the sound player
        let metronomeSoundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("metronomeClick", ofType: "mp3")!)
        metronomeSoundPlayer = try? AVAudioPlayer(contentsOfURL: metronomeSoundURL)
        metronomeSoundPlayer.prepareToPlay()
    }
    
    // MARK: - UIResponder
}