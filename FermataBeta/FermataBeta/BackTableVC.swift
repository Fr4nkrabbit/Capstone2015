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
    
    override func viewDidLoad() {
        MenuItems = ["Login", "Songs", "Metronome", "Tuner"]
        MenuPictures = ["facebookIcon","NOTE","METRO","FORK"]
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 100
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuItems.count
        
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let block = tableView.dequeueReusableCellWithIdentifier(MenuItems[indexPath.row], forIndexPath: indexPath) as UITableViewCell
    
        
        //Text customizations
        block.textLabel?.text = MenuItems[indexPath.row]
        block.textLabel?.font = UIFont(name: "Hiragino Sans", size: 55)
        block.textLabel?.font = UIFont.systemFontOfSize(40, weight: UIFontWeightThin)
        block.textLabel?.textColor = UIColor.whiteColor()
        //block.backgroundColor = UIColorFromRGB(#0e1d53)
        block.backgroundColor = UIColor(red: 25/256, green: 28/256, blue: 39/256, alpha: 0.66)

        //block.backgroundColor = UIColor(red: 14/256, green: 29/256, blue: 83/256, alpha: 1.0)
            //.contentView.backgroundColor = UIColor(red: 102/256, green: 255/256, blue: 255/256, alpha: 0.66)
        
        
        //Picture customization
        let imageName = UIImage(named: MenuPictures[indexPath.row])
        block.imageView?.image = imageName
        
        return block
    }
    
    

}