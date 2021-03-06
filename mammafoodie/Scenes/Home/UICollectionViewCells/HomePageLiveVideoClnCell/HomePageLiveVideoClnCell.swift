//
//  HomePageLiveVideoClnCell.swift
//  mammafoodie
//
//  Created by Akshit Zaveri on 18/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class HomePageLiveVideoClnCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgAddIcon: UIImageView!
    @IBOutlet weak var viewForViewAll: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgAddIcon.layer.cornerRadius = 8
        
        self.imgView.layer.borderColor = #colorLiteral(red: 1, green: 0.4745098039, blue: 0.1529411765, alpha: 1).cgColor
        self.imgView.layer.borderWidth = 2
        
        self.viewForViewAll.layer.borderColor = #colorLiteral(red: 1, green: 0.4745098039, blue: 0.1529411765, alpha: 1).cgColor
        self.viewForViewAll.layer.borderWidth = 2
    }
    
    override func layoutSubviews() {
        self.imgView.layer.cornerRadius = self.imgView.frame.width/2
        self.viewForViewAll.layer.cornerRadius = self.viewForViewAll.frame.width/2
        super.layoutSubviews()
    }
    
    func setup(with liveVideo: MFDish) {
        self.viewForViewAll.isHidden = true
        self.imgView.sd_cancelCurrentImageLoad()
        if liveVideo.id == "-1" {
            // Option to create new live video
            self.imgView.layer.borderWidth = 2
            self.imgAddIcon.isHidden = false
            self.imgView.image = UIImage(named: "ProfilePicture21")!
        } else if liveVideo.id == "30" {
            self.viewForViewAll.isHidden = false
        } else {
            // Show existing live video details
            self.imgView.layer.borderWidth = 0
            self.imgAddIcon.isHidden = true
            
            if let url: URL = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: liveVideo.user.id) {
                self.imgView.sd_setImage(with: url)
            } else {
                self.imgView.image = nil
            }
        }
        
    }
}
