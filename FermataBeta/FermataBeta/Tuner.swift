//
//  Tuner.swift
//  FermataBeta
//
//  Created by Young Liu and Eric on 1/30/16.
//  Copyright © 2016 Young Liu. All rights reserved.
//

//ALL the free notes come from this page

import Foundation
import AVFoundation

class Tuner: UIViewController {

    
/***************************************************
    PLAYS A PITCH FOR THE USER
***************************************************/
    var audioPlayer = AVAudioPlayer()
    var count = 0
    var beingPlayed = 0
    
    var noteList = [String]()
    var noteNames = [String]()
    
    @IBAction func UpButton(sender: AnyObject) {
        if count == noteList.count-1 {
            count = 0
        }
        else {
           count++
        }
        print(count)
        Note.text = noteNames[count]
        
        //automatically changes the sound upon the user changing it if it's being played
        //pretty much the play button function
        if beingPlayed == 1 {
                playNote()
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
        
        beingPlayed = 1; //indicates the note is being played
        audioPlayer.prepareToPlay()
        audioPlayer.numberOfLoops = -1 //for infinite holding
        audioPlayer.play()
        print(count)

    }
    
    @IBAction func DownButton(sender: AnyObject) {
        if count == 0{
            count=noteList.count-1
        }
        else {
            count -= 1
        }
        print(count)
        Note.text = noteNames[count]
        if beingPlayed == 1 {
            playNote()
        }
    }
    
    @IBOutlet var Note: UILabel!
    
    //play button: plays sound
    @IBAction func play(sender: AnyObject) {
       playNote()
    }
    
    //stops the music
    @IBAction func stopButton(sender: AnyObject) {
        stopNote()
    }
    
    func stopNote(){
        audioPlayer.stop()
        beingPlayed = 0;
    }
    
    @IBOutlet var NotePlayed: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initializes all the note files and the displayed note names
        noteList = ["0A", "1As", "2B", "3C", "4Cs", "5D", "6Ds", "7E", "8F", "9Fs", "10G", "11Gs"]
        noteNames = ["A", "Bb", "B", "C", "C#", "D", "Eb", "E", "F", "F#", "G", "G#"]
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        //changes the note display
        Note.text = noteNames[count]
        
        //for the swipe
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
}