//
//  Login.swift
//  FermataBeta
//
//  Created by Young Liu on 1/30/16.
//  Copyright © 2016 Young Liu. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class Login: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var btnFacebook: FBSDKButton!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivUserProfileImage: UIImageView!
    
    func fillImage(){
        self.lblName.text = "Welcome to Fermata Sheet Music, "
        self.userName.text = "\(firstName)"
        self.ivUserProfileImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: imageURL)!)!)
    }

    func menuAppears(){
        print("menu appears")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.currentAccessToken() == nil)
        {
            print("Not logged in...")
            
        }
        else
        {
            print("Logged in...")
            //menuAppears()
        }
        
        self.fillImage()
        
        self.navigationItem.title = "Facebook Login"
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = Selector("revealToggle:")
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.view.backgroundColor = UIColor(red: 103/256, green: 112/256, blue: 119/256, alpha: 1)
        
        lblName.font = UIFont(name: "Hiragino Sans", size: 55)
        lblName.font = UIFont.systemFontOfSize(40, weight: UIFontWeightThin)
        lblName.textColor = UIColor.whiteColor()
        
        userName.textAlignment = .Center
        userName.font = UIFont(name: "Hiragino Sans", size: 55)
        userName.font = UIFont.systemFontOfSize(40, weight: UIFontWeightThin)
        userName.textColor = UIColor.whiteColor()
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.frame = CGRectMake(self.view.frame.size.width/2 - loginButton.frame.size.width/2, self.view.frame.size.height/2+100, loginButton.frame.size.width, loginButton.frame.size.height);
        //loginButton.frame.height = 700
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        // Do any additional setup after loading the view, typically from a nib.*/
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
     {

     }
     
     func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
     {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
     
        ivUserProfileImage.image = nil
        lblName.text = "Please login!"
        self.performSegueWithIdentifier("showOld", sender: self)
     }
    
}