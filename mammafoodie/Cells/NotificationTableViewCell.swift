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
    
    func setUp(notification:MFNotification){
        
        let imageURL = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: notification.participantUserID)
        
        if let url = imageURL {
            profileImageView.sd_setImage(with: url)
        }
        
        lblNotificationText.attributedText = notification.attributedString
        
        
        if let dishID = notification.dishID{
            let dishImageURl = FirebaseReference.dishes.getImagePath(with: dishID)
            
            if let url = dishImageURl{
                dishImageView.sd_setImage(with: url)
            }
        }
        
        
    }
    
}
