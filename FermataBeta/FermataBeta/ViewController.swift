//
//  ViewController.swift
//  FermataBeta
//
//  Created by Young Liu on 1/28/16.
//  Copyright © 2016 Young Liu. All rights reserved.

//  Code is heavily based on the tutorial provided by Jared Davidson in his
//  youtube video "Makeing a Slide Out Menu (Swift in Xcode : SWRevealViewController)
//  Additionally, I use the open source SWRevealController.swift from github to assist in making
//  the slide out menu

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var Menu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Menu.target = self.revealViewController()
        Menu.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
