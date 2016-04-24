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
var loggedIn = false

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
    
    @IBOutlet weak var btnFacebook: FBSDKButton!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivUserProfileImage: UIImageView!
    
    func swipe(){
        //allows the right wipe
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func fillImage(){
        self.lblName.text = "Welcome to Fermata Sheet Music, \(firstName) \(lastName)"
        self.ivUserProfileImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: imageURL)!)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Facebook Login"
        swipe()
        
        //self.view.backgroundColor = UIColor(hexString: "#b5b5b7ff")
        
         self.view.backgroundColor = UIColor(red: 0, green: 33/256, blue: 66/256, alpha: 1)
        
        /*let imageName = "facebook.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let screenHeight = screenSize.height * (2/6)
        let screenWidth = screenSize.width - 500
        
        let screenHeightEnd = screenSize.height - 750
        let screenWidthEnd = screenSize.width * (1/4)*/
        
        lblName.text = ""
        
        //imageView.frame = CGRect(x: screenWidth, y: screenHeight, width: screenWidthEnd, height: screenHeightEnd)
        //view.addSubview(imageView)
         
         //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
         
         /*if (FBSDKAccessToken.currentAccessToken() == nil){
         print("not logged in")
         } else {
         print("logged in!")
         }*/
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        //loginButton.frame.height = 600
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        // Do any additional setup after loading the view, typically from a nib.*/
        
        if loggedIn{
            fillImage()
        }
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
            
            loggedIn = true
            
            self.fillImage()
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