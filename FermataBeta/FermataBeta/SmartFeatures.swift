//
//  smartFeatures.swift
//  FermataBeta
//
//  Created by Young Liu on 4/9/16.
//  Copyright © 2016 Young Liu. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

var globalTempo = "120.0"
class SmartFeatures:  UIViewController, UIGestureRecognizerDelegate {
    
    let callStuff = SongViewController()
    
    //tuner stuff
    
    @IBOutlet weak var playing: UILabel!
    @IBOutlet weak var Next: UIImageView!
    @IBOutlet weak var Note: UILabel!
    @IBOutlet weak var Prev: UIImageView!
    

    /***************************************************
     PLAYS A PITCH FOR THE USER
     ***************************************************/
    var audioPlayer = AVAudioPlayer()
    var count = 0
    var beingPlayed = false
    
    var noteList = [String]()
    var noteNames = [String]()
    //var freqList = [Float]()
    
    //metronome stuff
    @IBOutlet weak var tempoTextField: UITextField!
    
    @IBOutlet weak var tempoStepper: UIStepper!
    
    //might not be room for the blinking light
    //@IBOutlet weak var blinkingLight: UILabel!
    
    
    var metronomeTimer: NSTimer!
    var metronomeIsOn = false
    
    var metronomeSoundPlayer: AVAudioPlayer!
    
    var tempo: NSTimeInterval = 60 {
        didSet {
            tempoTextField.text = String(format: "%.0f", tempo)
            tempoStepper.value = Double(tempo)
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tempo = 120
        
        //view.backgroundColor = UIColor(red: 255/256, green: 255/256, blue: 240/256, alpha: 1)
        
        //backgroundColor = UIColor(red: 25/256, green: 28/256, blue: 39/256, alpha: 0.6240
        
        // Initialize the sou/Users/youngliu/Documents/EECS_581/FermataBeta/FermataBeta/SmartFeatures.swift:71:28: Use of instance member 'setStructDataReference' on type 'SongViewController'; did you mean to use a value of type 'SongViewController' instead?nd player
        let metronomeSoundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("metronomeClick", ofType: "wav")!)
        metronomeSoundPlayer = try? AVAudioPlayer(contentsOfURL: metronomeSoundURL)
        metronomeSoundPlayer.prepareToPlay()
        
        
        //initializes all the note files and the displayed note names
        noteList = ["0A", "1As", "2B", "3C", "4Cs", "5D", "6Ds", "7E", "8F", "9Fs", "10G", "11Gs"]
        noteNames = ["A", "Bb", "B", "C", "C#", "D", "Eb", "E", "F", "F#", "G", "G#"]
        //freqList = [440, 466, 493, 523, 554, 587, 622, 659, 698, 739, 783, 830]
        
        //changes the note display
        Note.text = noteNames[count]
        Note.textAlignment = .Center
        //displayFreq(count)
        
        Note?.font = UIFont(name: "Hiragino Sans", size: 35)
        Note?.font = UIFont.systemFontOfSize(35, weight: UIFontWeightThin)
        
        //make it look like a button
        //blackBox?.layer.borderWidth = 3
        //blackBox?.layer.borderColor = UIColor.blueColor().CGColor
        //Note?.textAlignment = .Center
        
        //To play the note
        Note.userInteractionEnabled = true // Remember to do this
        let tapNote: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didTapNote))
        Note.addGestureRecognizer(tapNote)
        
        //To change the note up
        Next.userInteractionEnabled = true
        let tapNext: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didTapNext))
        Next.addGestureRecognizer(tapNext)
        
        //To change the note down
        Prev.userInteractionEnabled = true
        let tapPrev: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didTapPrev))
        Prev.addGestureRecognizer(tapPrev)
        
        tapPrev.delegate = self
        tapNote.delegate = self
        tapNext.delegate = self
        
    }
    
    func didTapPrev(sender: UITapGestureRecognizer){
        print("did tap prev")
        if count == 0{
            count=noteList.count-1
        }
        else {
            count = count - 1
        }
        print(count)
        Note.text = noteNames[count]
        //displayFreq(count)

        if beingPlayed {
            playNote()
        }
    }
    
    func didTapNext(sender: UITapGestureRecognizer){
        print("did tap next")
        if count == noteList.count-1 {
            count = 0
        }
        else {
            count += 1
        }
        print(count)
        Note.text = noteNames[count]
        
        //automatically changes the sound upon the user changing it if it's being played
        //pretty much the play button function
        if beingPlayed {
            playNote()
        }
    }
    
    func didTapNote(sender: UITapGestureRecognizer){
        print("did tap note")
        beingPlayed = !beingPlayed
        if (beingPlayed){
            playNote()
        }
        else {
            stopNote()
        }
    }
        
    func playNote()
    {
        //Sets up the sound
        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(noteList[count], ofType: "wav")!)
        print(alertSound)
        
        // Removed deprecated use of AVAudioSessionDelegate protocol
        //var errors:NSError?
        do
        {
            try audioPlayer = AVAudioPlayer(contentsOfURL: alertSound)
        }
        catch _ { }
        
        audioPlayer.prepareToPlay()
        audioPlayer.numberOfLoops = -1 //for infinite holding
        audioPlayer.play()
        playing.text = "playing.."
        print(count)
    }
    
    func stopNote(){
        audioPlayer.stop()
        playing?.text = ""
    }
    
    //more metronome stuff
    @IBAction func tempoChanged(tempoStepper: UIStepper) {
        // Save the new tempo.
        tempo = tempoStepper.value
        globalTempo = String(tempoStepper.value)
    }
    
    @IBAction func toggleMetronome(toggleMetronomeButton: UIButton) {
        // If the metronome is currently on, stop the metronome and change
        // the image of the toggle metronome button to the "Play" image and
        // its tint color to green.
        if metronomeIsOn {
            // Mark the metronome as off.
            metronomeIsOn = false
            
            // Turn the blinking off, and change the label to its gray color
            //blinkingLight.backgroundColor = UIColor.lightGrayColor()
            
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
            metronomeTimer = NSTimer.scheduledTimerWithTimeInterval(metronomeTimeInterval, target: self, selector: #selector(SmartFeatures.playMetronomeSound), userInfo: nil, repeats: true)
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
        
        //gives short delay and blinks red
        //delay(0.4){
          //  self.blinkingLight.backgroundColor = UIColor.redColor()
        //}
        
        //blinkingLight.backgroundColor = UIColor.lightGrayColor()
        
        metronomeSoundPlayer.play()
        
    }
    
    //delay function that works cleaner then the Swift one
    func delay(delay:Double, closure:()->()){
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    // MARK: - UIViewController
    // MARK: Managing the View
}

 
        

