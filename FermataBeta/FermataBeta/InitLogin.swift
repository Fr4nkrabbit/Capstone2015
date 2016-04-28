//
//  InitLogin.swift
//  FermataBeta
//
//  Created by Young Liu on 4/27/16.
//  Copyright © 2016 Young Liu. All rights reserved.
//
//we segue from this to another

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

var firstName=""
var lastName=""
var imageURL=""
class InitLogin: UIViewController, FBSDKLoginButtonDelegate
{
    @IBOutlet weak var facebookImage: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 25/256, green: 28/256, blue: 39/256, alpha: 0.66)
        //UIColor(red: 0, green: 33/256, blue: 66/256, alpha: 1)//UIColor(red: 0, green: 33/256, blue: 66/256, alpha: 1)
        
        facebookImage.layer.cornerRadius = facebookImage.frame.size.width/2
        facebookImage.clipsToBounds = true
        
        if (FBSDKAccessToken.currentAccessToken() == nil)
        {
            print("Not logged in...")
        }
        else
        {
            print("Logged in...")
        }
        
        var loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Facebook Login
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large)"]).startWithCompletionHandler {
            (connection, result, error) -> Void in
            
            print("we were here")
            
            firstName = (result.objectForKey("first_name") as? String)!
            lastName = (result.objectForKey("last_name") as? String)!
            imageURL = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
        }

        if error == nil
        {
            print("Login complete.")
            self.performSegueWithIdentifier("showNew", sender: self)
        }
        else
        {
            print(error.localizedDescription)
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        print("User logged out...")
    }
    
}

