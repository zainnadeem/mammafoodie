//
//  FollowersTableCell.swift
//  mammafoodie
//
//  Created by Sireesha V on 7/3/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class FollowersTableCell: UITableViewCell {

    @IBOutlet weak var userProfile: UIImageView!
   
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var Lable2: UILabel!
    @IBOutlet weak var followButtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.userProfile.clipsToBounds = true
        self.userProfile.layer.cornerRadius = self.userProfile.frame.width/2
        self.followButtn.layer.cornerRadius = self.followButtn.frame.height/2
        self.followButtn.layer.borderWidth = 1
        self.followButtn.layer.borderColor = #colorLiteral(red: 1, green: 0.5998461843, blue: 0.206497252, alpha: 1).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
