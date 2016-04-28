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

class Tuner: UIViewController, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var Next: UIImageView!
    @IBOutlet weak var Prev: UIImageView!
    
    @IBOutlet weak var Note: UILabel!
    
    @IBAction func PlayStop(sender: UIButton) {
        sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        sender.titleLabel?.font =  UIFont(name: "Hiragino Sans", size: 60)
        sender.titleLabel?.font = UIFont.systemFontOfSize(35, weight: UIFontWeightThin)
        sender.titleLabel?.textColor = UIColor.whiteColor()
        if (!beingPlayed){
            playNote()
            sender.setTitle("Stop", forState: .Normal)

        }else {
            stopNote()
            sender.setTitle("Play", forState: .Normal)

        }
        //sender.titleLabel?.font =  UIFont(name: "Hiragino Sans", size: 35)
        //sender.titleLabel?.font = UIFont.systemFontOfSize(35, weight: UIFontWeightThin)
    }
    /*@IBAction func UserButton(sender: UIButton) {
        if (!beingPlayed){
            sender.setTitle("Stop", forState: UIControlState.Normal)
            playNote()
        }else {
            sender.setTitle("Play", forState: UIControlState.Normal)
            stopNote()
        }
    }*/
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
/***************************************************
    PLAYS A PITCH FOR THE USER
***************************************************/
    var audioPlayer = AVAudioPlayer()
    var count = 0
    var beingPlayed = false
    
    var noteList = [String]()
    var noteNames = [String]()
    
    @IBAction func UpButton(sender: AnyObject) {
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
        if beingPlayed == true {
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
        
        beingPlayed = true //indicates the note is being played
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
        if beingPlayed == true {
            playNote()
        }
    }
    
    func stopNote(){
        audioPlayer.stop()
        beingPlayed = false
    }
    
    @IBOutlet var NotePlayed: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = Selector("revealToggle:")
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        view.backgroundColor = UIColor(red: 103/256, green: 112/256, blue: 119/256, alpha: 1)
        
        //initializes all the note files and the displayed note names
        noteList = ["0A", "1As", "2B", "3C", "4Cs", "5D", "6Ds", "7E", "8F", "9Fs", "10G", "11Gs"]
        noteNames = ["A", "Bb", "B", "C", "C#", "D", "Eb", "E", "F", "F#", "G", "G#"]
        self.navigationItem.title = "Tuner"

        
        //changes the note display
        Note.text = noteNames[count]
        
        Note.textColor = UIColor.whiteColor()
        Note.font = UIFont(name: "Hiragino Sans", size: 55)
        Note.font = UIFont.systemFontOfSize(40, weight: UIFontWeightThin)
        
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
        tapNext.delegate = self

        //detect touch of the play button
        /*PlayButton.userInteractionEnabled = true
        let tapPlay: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(buttonPressed))
        Prev.addGestureRecognizer(tapPlay)
        
        tapPlay.delegate = self*/
        
        //for the swipe
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
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

}