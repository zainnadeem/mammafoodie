//
//  MosaicCollectionCell.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 05/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class MosaicCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = "MosaicCollectionCell"
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var btnProfileImage: UIButton!
    @IBOutlet weak var btnNumberOfViews: UIButton!
    @IBOutlet weak var btnTimeLeft: UIButton!
    @IBOutlet weak var screenShotImageView: UIImageView!
    @IBOutlet weak var btnUsername: UIButton!
    //    @IBOutlet var smallCellConstraints: [NSLayoutConstraint]!
    //    @IBOutlet var largeCellConstraints: [NSLayoutConstraint]!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    var media: MFDish! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        if let coverURL = self.media.coverPicURL ?? self.media.mediaURL {
            self.screenShotImageView.sd_setImage(with: coverURL, completed: { (image, error, cacheType, coverPictureURL) in
                if image == nil {
                    if let userProfilePictureURL = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: self.media.user.id) {
                        self.screenShotImageView.sd_setImage(with: userProfilePictureURL, completed: { (image, error, cacheType, url) in
                            if image == nil || error != nil {
                                self.screenShotImageView.image = nil
                            }
                        })
                    }
                }
            })
        } 
        
        if let url: URL = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: self.media.user.id) {
            self.btnProfileImage.sd_setImage(with: url, for: .normal, completed: { (image, error, _, _) in
                if image == nil || error != nil {
                    self.btnProfileImage.setImage(#imageLiteral(resourceName: "IconMammaFoodie"), for: .normal)
                }
            })
        } else {
            self.btnProfileImage.setImage(#imageLiteral(resourceName: "IconMammaFoodie"), for: .normal)
        }
        
        self.btnNumberOfViews.setTitle(String(self.media.numberOfViewers), for: .normal)
        self.btnUsername.setTitle("  " + self.media.user.name, for: .normal)
        self.title.text = self.media.name
        
        if self.media.mediaType == .liveVideo {
            self.btnTimeLeft.isHidden = true
        } else {
            if let timeStamp = self.media.endTimestamp {
                let timeLeft = "  " + timeStamp.toStringWithRelativeTime()
                self.btnTimeLeft.setTitle(timeLeft, for: .normal)
                self.btnTimeLeft.isHidden = false
            } else {
                self.btnTimeLeft.isHidden = true
            }
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setViewProperties()
    }
    
    func setViewProperties() {
        //sets properties for buttons inside cell
        let buttons : [UIButton] = [btnNumberOfViews, btnTimeLeft, btnUsername]
        self.screenShotImageView.contentMode = .scaleAspectFill
        
        for button in buttons {
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.layer.shadowRadius = 5
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowOpacity = 1
            button.layer.masksToBounds = false
            button.imageView?.contentMode = .scaleAspectFit
        }
        
        self.btnUsername.titleLabel?.numberOfLines = 2
        self.btnUsername.titleLabel?.adjustsFontSizeToFitWidth = false
        
        self.btnUsername.titleLabel?.lineBreakMode = .byWordWrapping
        
        self.btnProfileImage.imageView?.contentMode = .scaleAspectFill
        self.btnProfileImage.layer.shadowRadius = 3
        self.btnProfileImage.layer.shadowColor = UIColor.blue.cgColor
        self.btnProfileImage.layer.masksToBounds = false
        self.btnProfileImage.imageView?.layer.cornerRadius = btnProfileImage.frame.height / 2
        self.btnProfileImage.imageView?.clipsToBounds = true
        
        self.title.layer.shadowRadius = 3
        self.title.layer.shadowColor = UIColor.black.cgColor
        self.title.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.title.layer.shadowOpacity = 0.5
        self.title.layer.masksToBounds = false
        
    }

    //call these functions based on size of the cell
    func setLargeCellContraints() {
        //        btnNumberOfViews.isHidden = false
        //        for con in self.smallCellConstraints{
        //            con.isActive = false
        //        }
        //
        //        for con in self.largeCellConstraints{
        //            con.isActive = true
        //        }
        self.topStackView.axis = .horizontal
        self.bottomStackView.axis = .horizontal
        self.btnNumberOfViews.contentHorizontalAlignment = .right
    }
    
    func setSmallCellConstraints() {
        //        btnNumberOfViews.isHidden = true
        self.btnUsername.titleLabel?.adjustsFontForContentSizeCategory = true
        //
        //        for con in self.largeCellConstraints{
        //            con.isActive = false
        //        }
        //
        //        for con in self.smallCellConstraints {
        //            con.isActive = true
        //        }
        self.topStackView.axis = .vertical
        self.bottomStackView.axis = .vertical
        self.btnNumberOfViews.contentHorizontalAlignment = .left
    }
    
}
