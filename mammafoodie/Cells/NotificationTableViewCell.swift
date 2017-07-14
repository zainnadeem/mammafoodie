//
//  NotificationTableViewCell.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 14/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var lblNotificationText: UILabel!
    
    
    @IBOutlet weak var dishImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
