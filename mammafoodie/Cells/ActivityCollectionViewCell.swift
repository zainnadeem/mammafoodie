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
    
    var shapeLayer:CAShapeLayer!
    
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
//        self.layer.shadowOffset = CGSize(width: -10, height: -2)
        self.layer.shadowRadius = 1.5
        self.layer.shadowOpacity = 0.1
        self.layer.masksToBounds = false
        
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:10).cgPath
        
    }
    
    func setup(_ activityData:MFNewsFeed){
       
        self.lblActivityDescription.attributedText = activityData.attributedString
        self.lblTimeStamp.text = "2 mins ago."
        self.lblLikesCount.text = "12"
        self.lblCommentsCount.text = "23"
        self.profilePicImageView.image = UIImage(named: activityData.actionUserId.picture!)!
        self.emojiImageView.image = UIImage(named: "BeefTower")
//        updateShadow()
    }
    
//    func updateShadow() {
//        if self.shapeLayer == nil {
//            self.contentView.layoutIfNeeded()
//            self.shapeLayer = CAShapeLayer()
//            self.shapeLayer.shadowColor = #colorLiteral(red: 0.01568627451, green: 0.0431372549, blue: 0.3137254902, alpha: 1).cgColor
//            self.shapeLayer.shadowOpacity = 0.1
//            self.shapeLayer.shadowRadius = 7
//            
//            var shadowFrame: CGRect = self.frame
//            shadowFrame.origin.x -= 2
//            shadowFrame.origin.y += 8
//            shadowFrame.size.width += 2
//            shadowFrame.size.height -= 8
//            
//            self.shapeLayer.shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: self.contentView.layer.cornerRadius).cgPath
//            self.shapeLayer.shadowOffset = CGSize(width: 0, height: 1)
//            
//            self.contentView.layer.insertSublayer(self.shapeLayer, at: 0)
//        }
//    }

}
