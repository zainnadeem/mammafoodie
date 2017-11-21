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
//    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
//    @IBOutlet weak var conWidthDishImageView: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
        self.profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(notification: MFNotification) {
        self.profileImageView.sd_cancelCurrentImageLoad()
        if let url = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: notification.actionUserId) {
            self.profileImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "IconMammaFoodie"), options:.refreshCached, completed: { (image, error, cacheType, url) in
//                if image == nil {
//                    DispatchQueue.main.async {
//                        self.conWidthDishImageView.constant = 0
//                        self.contentView.layoutIfNeeded()
//                    }
//                }
            })
//            self.conWidthDishImageView.constant = 44
        } else {
//            self.conWidthDishImageView.constant = 0
        }
        
        self.lblNotificationText.text = notification.text
        
//        self.dishImageView.sd_cancelCurrentImageLoad()
//        if let dishID = notification.dishID {
//            let dishImageURl = FirebaseReference.dishes.getImagePath(with: dishID)
//            if let url = dishImageURl{
//                self.dishImageView.sd_setImage(with: url)
//            }
//        }
        
        self.lblTime.text = notification.date?.toStringWithRelativeTime()
    }
    
}
