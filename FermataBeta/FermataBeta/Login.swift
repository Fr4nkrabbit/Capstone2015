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

extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.startIndex.advancedBy(1)
            let hexColor = hexString.substringFromIndex(start)
            
            if hexColor.characters.count == 8 {
                let scanner = NSScanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexLongLong(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

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
    
    /*func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if error == nil
        {
            print("Login complete.")
            //self.performSegueWithIdentifier("showNew", sender: self)
        }
        else
        {
            print(error.localizedDescription)
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        print("User logged out...")
    }*/
    
     func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
     {

     }
     
     func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
     {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
     
        ivUserProfileImage.image = nil
        lblName.text = "Please login!"
     }
    
}