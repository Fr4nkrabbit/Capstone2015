//
//  BackTableVC.swift
//  FermataBeta
//
//  Created by Young Liu on 1/29/16.
//  Copyright © 2016 Young Liu. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

class BackTableVC: UITableViewController {
   
    var MenuItems = [String]()
    var MenuPictures = [String]()
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        definesPresentationContext = true
        
        MenuItems = ["cell","Login", "Songs", "Metronome", "Tuner"]
        MenuPictures = ["nil","DUDE2","NOTE2","METRO2","FORK2"]
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
    
    func maskRoundedImage(image: UIImage, radius: Float) -> UIImage {
        var imageView: UIImageView = UIImageView(image: image)
        var layer: CALayer = CALayer()
        layer = imageView.layer
        
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(radius)
        
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        var roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.contentInset = UIEdgeInsetsZero;
        
        let block = tableView.dequeueReusableCellWithIdentifier(MenuItems[indexPath.row], forIndexPath: indexPath) as UITableViewCell
        //let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell;
        
        block.separatorInset = UIEdgeInsetsZero;
        let row = indexPath.row
        if row == 0 {
            /*block.textLabel?.text = " \(firstName) \(lastName)"
            let image: UIImage = UIImage(data: NSData(contentsOfURL: NSURL(string: imageURL)!)!)!
            let newImage = UIImageView(image: image)
            newImage.layer.cornerRadius = newImage.frame.size.width/2
            newImage.clipsToBounds = true
            
            block.imageView?.image = newImage.image*/
            
        }
        //fills out the rest of the menu
        else {
            block.textLabel?.text = MenuItems[indexPath.row]
            //Picture customization
            let imageName = UIImage(named: MenuPictures[indexPath.row])
            block.imageView?.image = imageName
        }
        
        //Text customizations
        block.textLabel?.font = UIFont(name: "Hiragino Sans", size: 55)
        block.textLabel?.font = UIFont.systemFontOfSize(40, weight: UIFontWeightThin)
        block.textLabel?.textColor = UIColor.whiteColor()
        block.backgroundColor = UIColor(red: 25/256, green: 28/256, blue: 39/256, alpha: 0.66)

        //block.backgroundColor = UIColorFromRGB(#0e1d53)
        //block.contentView.backgroundColor = UIColor(red: 25/256, green: 28/256, blue: 39/256, alpha: 0.66)
        //block.backgroundColor = UIColor(red: 14/256, green: 29/256, blue: 83/256, alpha: 1.0)
        //block.contentView.backgroundColor = UIColor(red: 14/256, green: 29/256, blue: 83/256, alpha: 1.0)
        
        print("are we logged in?")
        
        return block
    }
    
    

}