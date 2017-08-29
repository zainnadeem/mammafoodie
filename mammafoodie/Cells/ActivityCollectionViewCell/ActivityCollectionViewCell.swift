//
//  ActivityCollectionViewCell.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 19/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class ActivityCollectionViewCell: UICollectionViewCell {

    
    static let reuseIdentifier = "ActivityCell"
    
    
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var lblActivityDescription: UILabel!
    
    @IBOutlet weak var lblTimeStamp: UILabel!
    
    @IBOutlet weak var emojiImageView: UIImageView!
    
    @IBOutlet weak var lblLikesCount: UILabel!
    
    @IBOutlet weak var lblCommentsCount: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.size.width/2
        profilePicImageView.clipsToBounds = true

        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 1.0
        
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 1.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
        
    }
    
    func setup(_ activityData:MFNewsFeed){
       
        self.lblActivityDescription.text = activityData.text
        self.lblTimeStamp.text = "2 mins ago."
        self.lblLikesCount.text = "12"
        self.lblCommentsCount.text = "23"
        
        DatabaseGateway.sharedInstance.getUserWith(userID: activityData.actionUser.id) { (user) in
            guard let user = user else {return}
            if let picture = user.picture {
                self.profilePicImageView.sd_setImage(with: picture)
            }
        }
        
//        self.profilePicImageView.image = UIImage(named: activityData.actionUserID.picture!)!
        self.emojiImageView.image = UIImage(named: "BeefTower")
    }

}
