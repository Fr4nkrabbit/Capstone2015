//
//  BackTableVC.swift
//  FermataBeta
//
//  Created by Young Liu on 1/29/16.
//  Copyright © 2016 Young Liu. All rights reserved.
//

import Foundation

class BackTableVC: UITableViewController {
    
    var MenuItems = [String]()
    var MenuPictures = [String]()
    /*var firstName=""
    var lastName=""
    var imageURL=""*/
    
    override func viewDidLoad() {
        MenuItems = ["Profile","Login", "Songs", "Metronome", "Tuner"]
        MenuPictures = ["nil","DUDE2","NOTE2","METRO2","FORK2"]
        if loggedIn {
            MenuItems[0] = "Welcome to Fermata Sheet Music, \(firstName) \(lastName)"
        }
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 100
        self.tableView.backgroundColor = UIColor(red: 25/256, green: 28/256, blue: 39/256, alpha: 1)
        //self.automaticallyAdjustsScrollViewInsets = false
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuItems.count
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = indexPath.row
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height * (1/3)
        if row == 0 {
            return screenHeight
        }
        else {
            return (screenSize.height*(1/6))
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.contentInset = UIEdgeInsetsZero;
        //let cell = tableView.dequeueReusableCellWithIdentifier(MenuItems[indexPath.row=0], forIndexPath: indexPath) as UITableViewCell
        
        let block = tableView.dequeueReusableCellWithIdentifier(MenuItems[indexPath.row], forIndexPath: indexPath) as UITableViewCell
        
        block.separatorInset = UIEdgeInsetsZero;
        //Text customizations
        block.textLabel?.text = MenuItems[indexPath.row]
        block.textLabel?.font = UIFont(name: "Hiragino Sans", size: 55)
        block.textLabel?.font = UIFont.systemFontOfSize(40, weight: UIFontWeightThin)
        block.textLabel?.textColor = UIColor.whiteColor()
        block.backgroundColor = UIColor(red: 25/256, green: 28/256, blue: 39/256, alpha: 0.66)

        //block.backgroundColor = UIColorFromRGB(#0e1d53)
        //block.contentView.backgroundColor = UIColor(red: 25/256, green: 28/256, blue: 39/256, alpha: 0.66)
        //block.backgroundColor = UIColor(red: 14/256, green: 29/256, blue: 83/256, alpha: 1.0)
        //block.contentView.backgroundColor = UIColor(red: 14/256, green: 29/256, blue: 83/256, alpha: 1.0)
        
        
        //Picture customization
        let imageName = UIImage(named: MenuPictures[indexPath.row])
        block.imageView?.image = imageName
        
        if loggedIn {
            block.imageView?.image = UIImage(data: NSData(contentsOfURL: NSURL(string: imageURL)!)!)
        }
        
        return block
    }
    
    

}