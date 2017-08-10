//
//  ActivityTblCell.swift
//  mammafoodie
//
//  Created by Akshit Zaveri on 20/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class ActivityTblCell: UITableViewCell, TTTAttributedLabelDelegate {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComments: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var imgCharacterEmoji: UIImageView!
    @IBOutlet weak var conWidthImgCharacterEmoji: NSLayoutConstraint!
    
    @IBOutlet weak var lblActivity: TTTAttributedLabel!
    @IBOutlet weak var btnTime: UIButton!
    
    var shapeLayer: CAShapeLayer!
    
    var openURL: ((String, String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnLike.imageView?.contentMode = .scaleAspectFit
        self.btnComments.imageView?.contentMode = .scaleAspectFit
        self.btnShare.imageView?.contentMode = .scaleAspectFit
        self.viewContainer.layer.cornerRadius = 8
        self.btnTime.imageView?.contentMode = .scaleAspectFit
                self.lblActivity.linkAttributes = [NSForegroundColorAttributeName: UIColor.black,
                                                   NSUnderlineStyleAttributeName: NSNumber(value: NSUnderlineStyle.styleNone.rawValue as Int) ]
    }
    
    func setup(with newsFeed: MFNewsFeed) {
        self.lblActivity.delegate = self
        if let url: URL = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: newsFeed.actionUser.id) {
            self.imgProfilePicture.sd_setImage(with: url, completed: { (image, error, cacheType, url) in
                if image == nil || error != nil {
                    self.imgProfilePicture.image = UIImage(named: "IconMammaFoodie")
                }
            })
        } else {
            self.imgProfilePicture.image = UIImage(named: "IconMammaFoodie")
        }
        
        let actionUserName = NSAttributedString.init(string: newsFeed.actionUser.name + " ", attributes: [NSFontAttributeName: UIFont.MontserratSemiBold(with: 14)!])
        
        let activityAction = NSAttributedString.init(string: newsFeed.activity.text, attributes: [NSFontAttributeName: UIFont.MontserratRegular(with: 13)!])
        
        let relevantItem = NSAttributedString.init(string: " " + newsFeed.participantUser.name, attributes: [NSFontAttributeName: UIFont.MontserratSemiBold(with: 14)!])
        
        let wholeText = NSMutableAttributedString.init()
        wholeText.append(actionUserName)
        wholeText.append(activityAction)
        wholeText.append(relevantItem)
        
        self.lblActivity.attributedText = wholeText
        let rangeActionUser = (self.lblActivity.attributedText.string as NSString).range(of: actionUserName.string)
        let rangeRelevantItem = (self.lblActivity.attributedText.string as NSString).range(of: relevantItem.string)
        
        self.lblActivity.addLink(to: URL.init(string: "\(MFActivityType.followed.path.rawValue)://\(newsFeed.actionUser.id)")!, with: rangeActionUser)
        self.lblActivity.addLink(to: URL.init(string: "\(newsFeed.activity.path.rawValue)://\(newsFeed.redirectID)")!, with: rangeRelevantItem)
        
        self.imgCharacterEmoji.image = nil
        self.conWidthImgCharacterEmoji.constant = 0
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
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if let path = url.scheme,
            let id = url.host {
            self.openURL?(path, id)
        } else {
            print("Incorrect URL")
        }
    }
    
}
