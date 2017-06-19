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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgAddIcon.layer.cornerRadius = 8
        self.imgView.layer.borderColor = UIColor(css: "FF7927").cgColor
    }
    
    func setup(with liveVideo: MFMedia) {
        if liveVideo.id == "-1" {
            // Option to create new live video
            self.imgView.layer.borderWidth = 2
            self.imgAddIcon.isHidden = false
        } else {
            // Show existing live video details
            self.imgView.layer.borderWidth = 0
            self.imgAddIcon.isHidden = true
        }
        
        self.imgView.layer.cornerRadius = self.frame.width/2
    }    
}
