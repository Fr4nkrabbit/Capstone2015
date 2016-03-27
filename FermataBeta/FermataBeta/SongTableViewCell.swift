//
//  SongTableViewCell.swift
//  FermataBeta
//
//  Created by Young Liu on 11/16/15.
//  Copyright © 2015 Young Liu. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    //MARK: Properties 
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
