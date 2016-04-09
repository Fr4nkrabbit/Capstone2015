//
//  smartFeatures.swift
//  FermataBeta
//
//  Created by Young Liu on 4/9/16.
//  Copyright © 2016 Young Liu. All rights reserved.
//

import Foundation
import AVFoundation

class SmartFeatures: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var Note: UILabel!
    @IBOutlet weak var Next: UIImageView!
    @IBOutlet weak var Prev: UIImageView!
    
    /***************************************************
     PLAYS A PITCH FOR THE USER
     ***************************************************/
    var audioPlayer = AVAudioPlayer()
    var count = 0
    var beingPlayed = false
    
    var noteList = [String]()
    var noteNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initializes all the note files and the displayed note names
        noteList = ["0A", "1As", "2B", "3C", "4Cs", "5D", "6Ds", "7E", "8F", "9Fs", "10G", "11Gs"]
        noteNames = ["A", "Bb", "B", "C", "C#", "D", "Eb", "E", "F", "F#", "G", "G#"]
        
        //changes the note display
        Note.text = noteNames[count]
        
        Note?.font = UIFont(name: "Hiragino Sans", size: 35)
        Note?.font = UIFont.systemFontOfSize(35, weight: UIFontWeightThin)
        
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
        print(count)
    }
    
    func stopNote(){
        audioPlayer.stop()
    }
}

 
        

