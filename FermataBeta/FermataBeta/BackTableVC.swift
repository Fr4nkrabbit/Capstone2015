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
    
    override func viewDidLoad() {
        MenuItems = ["Login", "Songs", "Metronome", "Tuner"]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MenuItems.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let block = tableView.dequeueReusableCellWithIdentifier(MenuItems[indexPath.row], forIndexPath: indexPath) as UITableViewCell
    
        block.textLabel?.text = MenuItems[indexPath.row]
        block.textLabel?.font = UIFont(name: "Hiragino Sans", size: 15)
        block.textLabel?.font = UIFont.systemFontOfSize(15, weight: UIFontWeightThin)
        
        return block
    }
    
    

}