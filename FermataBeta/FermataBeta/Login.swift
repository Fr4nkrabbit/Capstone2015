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

var firstName=""
var lastName=""
var imageURL=""

class Login: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var btnFacebook: FBSDKButton!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivUserProfileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Facebook Login"
        
        /* self.view.backgroundColor = UIColor(red:246, green:247, blue:235, alpha:1)
         
         self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
         
         if (FBSDKAccessToken.currentAccessToken() == nil){
         print("not logged in")
         } else {
         print("logged in!")
         }*/
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
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
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large)"]).startWithCompletionHandler { (connection, result, error) -> Void in
            
            firstName = (result.objectForKey("first_name") as? String)!
            lastName = (result.objectForKey("last_name") as? String)!
            imageURL = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
            
            self.lblName.text = "Welcome to Fermata Sheet Music, \(firstName) \(lastName)"
            self.ivUserProfileImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: imageURL)!)!)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        ivUserProfileImage.image = nil
        lblName.text = "Please login!"
    }
    
}