//
//  CheckBox.swift
//  FermataBeta
//
//  Created by Young Liu on 2/26/16.
//  Copyright © 2016 Young Liu. All rights reserved.
//

//based off of youtube video Xcode Swift Checkbox Control
import UIKit

class CheckBox: UIButton {
    
    //images
    let checkedImage = UIImage(named: "checked_checkbox")! as UIImage
    let uncheckedImage = UIImage(named: "unchecked_checkbox")! as UIImage
    
    //bool properties
    //where the magic happens
    var isChecked:Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, forState: .Normal)
            }else {
                self.setImage(uncheckedImage, forState: .Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: "buttonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender:UIButton) {
        if (sender == self) {
            if isChecked == true {
                isChecked = false
            }else {
                isChecked = true
            }
        }
    }
}
