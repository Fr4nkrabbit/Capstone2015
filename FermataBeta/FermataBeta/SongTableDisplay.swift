//
//  testSearch.swift
//  FermataBeta
//
//  Created by Young Liu on 3/26/16.
//  Copyright © 2016 Young Liu. All rights reserved.
//

//
//  ViewController.swift
//  SwiftSearch
//
//  Created by Shrikar Archak on 2/16/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.

//HEAVILY BASED ON THE TUTORIAL BY Shrikar Archak
//

import UIKit

class SongDisplay: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    //@IBOutlet weak var searchBar: UISearchBar!
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchActive : Bool = false
    var data = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    var testData:[String] = []
    var filtered:[String] = []
    
    //MARK: Properties
    var songs = [Song]()
    var ID: [String] = []
    //var numbers: [Int] = []
    
    func loadSampleSongs(){
        
        
        //if let url = NSURL(string: "http://people.eecs.ku.edu/~sbenson/grabTitles.php") {
        if let url = NSURL(string: "http://people.eecs.ku.edu/~sxiao/grabTitles.php"){
            do {
                let songListNP = try NSString(contentsOfURL: url, usedEncoding: nil)
                let songListAsString = songListNP as String
                let songList = songListAsString.characters.split{$0 == "@"}.map(String.init)
         
                var bool = true
                
                print(songList)
         
                //populate songList
                for item in songList{
                    if bool {
                        songs += [Song(name: item)]
                        testData.append(item)
                    }else {
                        ID.append(item)
                    }
                    bool = !bool
                    
                }
            } catch {
                print("contents could not be loaded")
            }
        } else {
            print("Contents are bad!")
        }
        
        //Going to Sam's database
        /*if let url = NSURL(string: "http://people.eecs.ku.edu/~sbenson/grabTitles.php"){
            do {
                let songListNP = try NSString(contentsOfURL: url, usedEncoding: nil)
                let songListAsString = songListNP as String
                let songList = songListAsString.characters.split{$0 == " "}.map(String.init)
                
                
                //populate songList
                for item in songList{
                    
                    songs += [Song(name: item)]
                    testData.append(item)
                    print(item)
                }
                
            } catch {
                print("contents could not be loaded")
            }
         } else {
            print("Contents are bad!")
        }*/
        
    }

    func swipe(){
        
        //allows the right wipe
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.view.backgroundColor = UIColor(red:246, green:247, blue:235, alpha:1)
        //self.view.backgroundColor = UIColor(red:(246/255), green:(247/255), blue: (235/255), alpha:1.0)
        //self.view.backgroundColor = UIColor(netHex:0x1E1E1E)
       self.view.backgroundColor = UIColor.redColor()
        
        loadSampleSongs()
        swipe()
        
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = testData.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return testData.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell;
        
        cell.textLabel?.font = UIFont(name: "Hiragino Sans", size: 35)
        cell.textLabel?.font = UIFont.systemFontOfSize(35, weight: UIFontWeightThin)
        
        
        //cell.contentView.backgroundColor = UIColor(red: 102/256, green: 255/256, blue: 255/256, alpha: 0.66)
        
        if(searchActive){
            cell.textLabel?.text = filtered[indexPath.row]
        } else {
            cell.textLabel?.text = testData[indexPath.row];
        }
        
        return cell;
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            print("do we even get here1?")
            let songDetailViewController = segue.destinationViewController as! SongViewController
            
            // Get the cell that generated this segue.
            if let selectedSongCell = sender as? UITableViewCell {
                print("do we even get here2?")
                let indexPath = tableView.indexPathForCell(selectedSongCell)!
                let selectedSong = songs[indexPath.row]
                let selectedID = ID[indexPath.row]
                songDetailViewController.song = selectedSong
                songDetailViewController.id = selectedID
                print(selectedSong.name)
                print("do we even get here3?")
            }
        }
    }
}