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

class Metronome: UIViewController {
    
    @IBOutlet weak var tempoTextField: UILabel!
    
    @IBOutlet weak var tempoStepper: UIStepper!
    
    var timer: NSTimer!
    
    var isOn = false
    
    var soundPlayer: AVAudioPlayer!
    
    var tempo: NSTimeInterval = 60 {
        didSet {
            //use this to set up the initial image on the UI
            tempoTextField.text = String(format: "%.0f", tempo)
            tempoStepper.value = Double(tempo)
        }
    }
    
    @IBAction func tempoChanged(var tempoStepper: UIStepper) {
        tempo = tempoStepper.value
        tempoTextField.text = String(format: "%.0f", tempo)
    }
    
    @IBAction func toggleMetronome(var toggleMetronomeButton: UIButton){
        
        if isOn {
            
            //mark the metronome as off
            isOn = false
            
            //stop the metronome
            timer?.invalidate()
            
            //changing the start/stop button's tint and image
            toggleMetronomeButton.setImage(UIImage(named: "Play"), forState: .Normal)
            toggleMetronomeButton.tintColor = UIColor.greenColor()
            
            //enable the stepper
            tempoStepper.enabled = true
            
            //enable editing the tempo field
            tempoTextField.enabled = true
        }
        
        else {
            // mark as on
            isOn = true
            
            //start metronome
            let timeInterval:NSTimeInterval = 60.0 / tempo
            timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: Selector("playMetronomeSound"), userInfo: nil, repeats: true)
            
            //changing the image
            toggleMetronomeButton.setImage(UIImage(named: "stop"), forState: .Normal)
            toggleMetronomeButton.tintColor = UIColor.redColor()
            
            //disable stepper
            tempoStepper.enabled = false
            
            //hide keyboard
            tempoTextField.resignFirstResponder()
            
            //disable editing the tempo text field
            tempoTextField.enabled = false
            
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        tempoTextField.resignFirstResponder()
    }
    
    func playSound() {
        
        let curTime = CFAbsoluteTimeGetCurrent()
        print("Play metronome sound @ \(curTime)")
        
        soundPlayer.play()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tempo = 120
        
        //set the sound to the clicks
    }
    
}
