//
//  HomePageVidupClnCell.swift
//  mammafoodie
//
//  Created by Akshit Zaveri on 18/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class HomePageVidupClnCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgAddIcon: UIImageView!
    @IBOutlet weak var viewForViewAll: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgView.layer.cornerRadius = 25
        self.imgAddIcon.layer.cornerRadius = 8
        
        self.imgView.layer.borderColor = #colorLiteral(red: 1, green: 0.4745098039, blue: 0.1529411765, alpha: 1).cgColor
        self.imgView.layer.borderWidth = 2
        
        self.viewForViewAll.layer.borderColor = #colorLiteral(red: 1, green: 0.4745098039, blue: 0.1529411765, alpha: 1).cgColor
        self.viewForViewAll.layer.borderWidth = 2
    }
    
    func setup(with vidup: MFMedia) {
        self.viewForViewAll.isHidden = true
        if vidup.id == "-1" {
            // Option to create new vidup
            self.imgView.layer.borderWidth = 2
            self.imgAddIcon.isHidden = false
            self.imgView.image = UIImage(named: "ProfilePicture21")!
        } else if vidup.id == "30" {
            self.viewForViewAll.isHidden = false
        } else {
            // Show existing vidup details
            self.imgView.layer.borderWidth = 0
            self.imgAddIcon.isHidden = true
            self.imgView.image = UIImage(named: "ProfilePicture\(vidup.id!)")!
        }
        self.imgView.layer.cornerRadius = self.frame.width/2
        self.viewForViewAll.layer.cornerRadius = self.frame.width/2
    }
    
}
