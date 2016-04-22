//
//  Recent.swift
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
    
    
    //@IBOutlet weak var btnFacebook: FBSDKButton!
   // @IBOutlet weak var ivProfileUserImage: UIImageView!
    
    //@IBOutlet weak var lblName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Facebook Login"

        self.view.backgroundColor = UIColor(red:246, green:247, blue:235, alpha:1)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        if (FBSDKAccessToken.currentAccessToken() == nil){
            print("not logged in")
        } else {
            print("logged in!")
        }
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large)"]).startWithCompletionHandler { (connection, result, error) -> Void in
            
            let strFirstName: String = (result.objectForKey("first_name") as? String)!
            let strLastName: String = (result.objectForKey("last_name") as? String)!
            let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
    
           // self.lblName.text = "Welcome, \(strFirstName) \(strLastName)"
            //self.ivProfileUserImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)
            //self.lblName.text = "Welcome, \(strFirstName) \(strLastName)"
            //self.ivUserProfileImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        //ivProfileUserImage.image = nil
        //lblName.text = ""
    }
    //- See more at: http://www.theappguruz.com/blog/facebook-integration-using-swift#sthash.rPJel4Wd.dpuf
    
}