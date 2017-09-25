//
//  ActivityCollectionViewCell.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 19/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class ActivityCollectionViewCell: UICollectionViewCell, TTTAttributedLabelDelegate {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComments: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var imgCharacterEmoji: UIImageView!
    @IBOutlet weak var conWidthImgCharacterEmoji: NSLayoutConstraint!
    @IBOutlet weak var lblActivity: TTTAttributedLabel!
    @IBOutlet weak var btnTime: UIButton!
    
    var likeButtonTapped: (()->Void)?
    var shapeLayer: CAShapeLayer!
    var openURL: ((String, String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnLike.imageView?.contentMode = .scaleAspectFit
        self.btnComments.imageView?.contentMode = .scaleAspectFit
        self.btnShare.imageView?.contentMode = .scaleAspectFit
        self.viewContainer.layer.cornerRadius = 8
        self.btnTime.imageView?.contentMode = .scaleAspectFit
        self.lblActivity.linkAttributes = [NSForegroundColorAttributeName: UIColor.black, NSUnderlineStyleAttributeName: NSNumber(value: NSUnderlineStyle.styleNone.rawValue as Int) ]
        self.imgProfilePicture.image = UIImage(named: "IconMammaFoodie")
    }
    
    func setup(with newsFeed: MFNewsFeed) {
        self.lblActivity.delegate = self
        self.imgCharacterEmoji.image = nil
        self.conWidthImgCharacterEmoji.constant = 0
        
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
        
        var relevantText: String = ""
        
        switch newsFeed.activity {
        case .bought,
             .liked,
             .requested,
             .purchased:
            relevantText = "a dish."
            
        case .uploaded:
            relevantText = "a vidup."
            
        case .started,
             .watching:
            relevantText = "a live video."
            
        case .followed,
             .tipped:
            relevantText = newsFeed.participantUser.name
            
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
        self.lblActivity.addLink(to: URL.init(string: "\(newsFeed.activity.path.rawValue)://\(newsFeed.redirectID)")!, with: rangeRelevantItem)
    }

    /*
     func setup(with newsFeed: MFNewsFeed) {
     self.lblActivity.delegate = self
     self.imgCharacterEmoji.image = nil
     self.conWidthImgCharacterEmoji.constant = 0

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

     switch newsFeed.activity {
     case .bought,
     .liked,
     .requested,
     .purchased:
     relevantText = "a dish."

     case .uploaded:
     relevantText = "a vidup."

     case .started,
     .watching:
     relevantText = "a live video."

     case .followed,
     .tipped:
     relevantText = newsFeed.participantUser.name

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
     self.lblActivity.addLink(to: URL.init(string: "\(newsFeed.activity.path.rawValue)://\(newsFeed.redirectID)")!, with: rangeRelevantItem)
     }

     */

    @IBAction func btnLikeTapped(_ sender: UIButton) {
        self.likeButtonTapped?()
        sender.isSelected = !sender.isSelected
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if let path = url.scheme,
            let id = url.host {
            self.openURL?(path, id)
        } else {
            print("Incorrect URL: \(url.absoluteString)")
        }
    }
}
