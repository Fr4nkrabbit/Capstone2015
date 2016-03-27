//
//  SongTableViewController.swift
//  FermataBeta
//
//  Created by Young Liu on 11/16/15.
//  Copyright © 2015 Young Liu. All rights reserved.
//

import UIKit
import JavaScriptCore
import WebKit

class SongTableViewController: UITableViewController {
    
    @IBOutlet var Menu: UIBarButtonItem!
    @IBOutlet weak var searchBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipe()
        loadSampleSongs()
        
        /* Setup delegates */
        //      searchBar.delegate = self
    }
    

    
    
    
    
    let rect = CGRect(
        origin: CGPoint(x: 0, y: 0),
        size: UIScreen.mainScreen().bounds.size)
    
    //MARK: Properties
    var songs = [Song]()
    var ID: [String] = []
    //var numbers: [Int] = []
    
    func loadSampleSongs(){
    
        
        //if let url = NSURL(string: "http://people.eecs.ku.edu/~sbenson/grabTitles.php") {
        /*if let url = NSURL(string: "http://people.eecs.ku.edu/~sxiao/grabTitles.php"){
            do {
                let songListNP = try NSString(contentsOfURL: url, usedEncoding: nil)
                let songListAsString = songListNP as String
                let songList = songListAsString.characters.split{$0 == "@"}.map(String.init)
                
                var bool = true
                
                //populate songList
                for item in songList{
                    if bool {
                        songs += [Song(name: item)]
                    }else {
                        ID.append(item)
                    }
                    bool = !bool
                    
        }*/if let url = NSURL(string: "http://people.eecs.ku.edu/~sbenson/grabTitles.php"){
            do {
                let songListNP = try NSString(contentsOfURL: url, usedEncoding: nil)
                let songListAsString = songListNP as String
                let songList = songListAsString.characters.split{$0 == " "}.map(String.init)

                
                //populate songList
                for item in songList{
      
                        songs += [Song(name: item)]

                    
                }
                
            } catch {
                print("contents could not be loaded")
            }
        } else {
            print("Contents are bad!")
        }

    }
    
    func swipe(){
        
        //allows the right wipe
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "SongTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SongTableViewCell
        
        let song = songs[indexPath.row]
        
        cell.nameLabel.text = song.name

        // Configure the cell...

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            print("do we even get here1?")
            let songDetailViewController = segue.destinationViewController as! InstrumentsViewController
            
            // Get the cell that generated this segue.
            if let selectedSongCell = sender as? SongTableViewCell {
                print("do we even get here2?")
                let indexPath = tableView.indexPathForCell(selectedSongCell)!
                let selectedSong = songs[indexPath.row]
               // let selectedID = ID[indexPath.row]
                songDetailViewController.song = selectedSong
                //songDetailViewController.id = selectedID
                print(selectedSong.name)
                print("do we even get here3?")
            }
        }
    }

}
