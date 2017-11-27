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
    var likeButtonTapped: ((String, String)->Void)?
    var openURL: ((String, String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnLike.imageView?.contentMode = .scaleAspectFit
        self.btnComments.imageView?.contentMode = .scaleAspectFit
        self.btnShare.imageView?.contentMode = .scaleAspectFit
        self.viewContainer.layer.cornerRadius = 8
        self.btnTime.imageView?.contentMode = .scaleAspectFit
        self.lblActivity.linkAttributes = [NSForegroundColorAttributeName: UIColor.black,
                                           NSUnderlineStyleAttributeName: NSNumber(value: NSUnderlineStyle.styleNone.rawValue) ]
        self.imgProfilePicture.image = #imageLiteral(resourceName: "IconMammaFoodie")
    }
    
    func setup(with newsFeed: MFNewsFeed, withUser currentUser: MFUser) {
        self.lblActivity.delegate = self
//        self.imgCharacterEmoji.image = nil
//        self.conWidthImgCharacterEmoji.constant = 0
        
        if let url: URL = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: newsFeed.actionUser.id) {
            self.imgProfilePicture.sd_setImage(with: url, completed: { (image, error, cacheType, url) in
                if image == nil || error != nil {
                    self.imgProfilePicture.image = #imageLiteral(resourceName: "IconMammaFoodie")
                }
            })
        } else {
            self.imgProfilePicture.image = #imageLiteral(resourceName: "IconMammaFoodie")
        }
        
        let actionUserName = NSAttributedString.init(string: newsFeed.actionUser.name + " ", attributes: [NSFontAttributeName: UIFont.MontserratSemiBold(with: 14)!])
        
        let activityAction = NSAttributedString.init(string: newsFeed.activity.text, attributes: [NSFontAttributeName: UIFont.MontserratRegular(with: 13)!])
        
        var relevantText: String = ""
        
        var imagePath: String = "https://firebasestorage.googleapis.com/v0/b/mammafoodie-baf82.appspot.com/o/"

        switch newsFeed.activity {
        case .bought,
             .liked,
             .requested,
             .purchased:
            relevantText = "a dish."
            imagePath.append("dishes")
            
        case .uploaded:
            relevantText = "a vidup."
            
        case .started,
             .watching:
            relevantText = "a live video."
            imagePath.append("dishes")
            
        case .followed,
             .tipped:
            if newsFeed.participantUser == currentUser {
                relevantText = "You"
            } else {
                relevantText = newsFeed.participantUser.name
            }
            imagePath.append("users")
            
        case .none:
            self.lblActivity.setText("")
            return
        }
        
       
        let relevantItem = NSAttributedString.init(string: " " + relevantText, attributes: [NSFontAttributeName: UIFont.MontserratSemiBold(with: 14)!])
        
        let wholeText = NSMutableAttributedString.init()
        wholeText.append(actionUserName)
        wholeText.append(activityAction)
        wholeText.append(relevantItem)
        
        self.lblActivity.attributedText = wholeText
        let rangeActionUser = (self.lblActivity.attributedText.string as NSString).range(of: actionUserName.string)
        let rangeRelevantItem = (self.lblActivity.attributedText.string as NSString).range(of: relevantItem.string)
        
        self.lblActivity.addLink(to: URL.init(string: "\(MFActivityType.followed.path.rawValue)://\(newsFeed.actionUser.id)")!, with: rangeActionUser)
        if newsFeed.activity.path == .users {
            self.lblActivity.addLink(to: URL.init(string: "\(newsFeed.activity.path.rawValue)://\(newsFeed.participantUser.id)")!, with: rangeRelevantItem)
            imagePath.append("%2F\(newsFeed.participantUser.id).jpg?alt=media")
        } else {
            self.lblActivity.addLink(to: URL.init(string: "\(newsFeed.activity.path.rawValue)://\(newsFeed.redirectID)")!, with: rangeRelevantItem)
            imagePath.append("%2F\(newsFeed.redirectID).jpg?alt=media")
        }
        
        if let imageURL = newsFeed.mediaURL {
            self.imgCharacterEmoji.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "IconMammaFoodie"), options: .allowInvalidSSLCertificates)
        } else {
            print("invalid imageurl: \(newsFeed.mediaURL?.absoluteString ?? "")")
        }
        
        let timeString = newsFeed.createdAt.toStringWithRelativeTime(strings: nil)
        self.btnTime.setTitle(timeString, for: .normal)
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
        self.likeButtonTapped?("", "")
        sender.isSelected = !sender.isSelected
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if let path = url.scheme,
            let id = url.host {
            self.openURL?(path, id)
             print("Opening URL: \(url.absoluteString)")
        } else {
            print("Incorrect URL: \(url.absoluteString)")
        }
    }
    
}
