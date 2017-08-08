//
//  ActivityTblCell.swift
//  mammafoodie
//
//  Created by Akshit Zaveri on 20/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class ActivityTblCell: UITableViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComments: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var imgCharacterEmoji: UIImageView!
    @IBOutlet weak var conWidthImgCharacterEmoji: NSLayoutConstraint!
    
    @IBOutlet weak var lblActivity: UILabel!
    @IBOutlet weak var btnTime: UIButton!
    
    var shapeLayer: CAShapeLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnLike.imageView?.contentMode = .scaleAspectFit
        self.btnComments.imageView?.contentMode = .scaleAspectFit
        self.btnShare.imageView?.contentMode = .scaleAspectFit
        self.viewContainer.layer.cornerRadius = 8
        self.btnTime.imageView?.contentMode = .scaleAspectFit
    }
    
    func setup(with newsFeed: MFNewsFeed) {
        if let url: URL = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: newsFeed.actionUser.id) {
            self.imgProfilePicture.sd_setImage(with: url, completed: { (image, error, cacheType, url) in
                if image == nil || error != nil {
                    self.imgProfilePicture.image = UIImage(named: "IconMammaFoodie")
                }
            })
        } else {
            self.imgProfilePicture.image = UIImage(named: "IconMammaFoodie")
        }
        
        var actionUserName = NSAttributedString.init(string: newsFeed.actionUser.name, attributes: [NSFontAttributeName: UIFont.MontserratSemiBold(with: 14)!])
        var activityAction = NSAttributedString.init(string: "", attributes: [NSFontAttributeName: UIFont.MontserratRegular(with: 13)])
        var relevantItem = NSAttributedString.init(string: "", attributes: [NSFontAttributeName: UIFont.MontserratSemiBold(with: 14)!])
        switch newsFeed.activity {
        case .bought:
            break
        case .followed:
            break
        case .liked:
            break
        case .started:
            break
        case .tipped:
            break
        default:
            break
        }
//        self.lblActivity.attributedText = actionUserName + activityAction + relevantItem
        self.imgCharacterEmoji.image = nil
        self.conWidthImgCharacterEmoji.constant = 0
    }
    
    private func getEmojiCharacter(for cuisineId: String) -> UIImage {
        if cuisineId == "1" {
            return #imageLiteral(resourceName: "BeefTower")
        } else if cuisineId == "2" {
            return #imageLiteral(resourceName: "coleslawBurger")
        } else if cuisineId == "3" {
            return #imageLiteral(resourceName: "Crabcakes")
        } else if cuisineId == "4" {
            return #imageLiteral(resourceName: "GoatCheeseCanape")
        } else if cuisineId == "5" {
            return #imageLiteral(resourceName: "guac&chips")
        }
        return #imageLiteral(resourceName: "BeefTower")
    }
    
    func updateShadow() {
        if self.shapeLayer == nil {
            self.contentView.layoutIfNeeded()
            self.shapeLayer = CAShapeLayer()
            self.shapeLayer.shadowColor = #colorLiteral(red: 0.01568627451, green: 0.0431372549, blue: 0.3137254902, alpha: 1).cgColor
            self.shapeLayer.shadowOpacity = 0.1
            self.shapeLayer.shadowRadius = 7
            
            var shadowFrame: CGRect = self.viewContainer.frame
            shadowFrame.origin.x -= 2
            shadowFrame.origin.y += 8
            shadowFrame.size.width += 2
            shadowFrame.size.height -= 8
            
            self.shapeLayer.shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: self.viewContainer.layer.cornerRadius).cgPath
            self.shapeLayer.shadowOffset = CGSize(width: 0, height: 1)
            
            self.viewContainer.superview?.layer.insertSublayer(self.shapeLayer, at: 0)
        }
    }
    
    @IBAction func btnLikeTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}
