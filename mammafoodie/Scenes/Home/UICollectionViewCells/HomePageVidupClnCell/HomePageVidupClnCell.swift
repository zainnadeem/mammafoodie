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
    @IBOutlet weak var circleView: CircleView!
    
    var timerCountdown: Timer?
    var circleLayer: CAShapeLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgAddIcon.layer.cornerRadius = 8
        
        self.imgView.layer.borderColor = #colorLiteral(red: 1, green: 0.4745098039, blue: 0.1529411765, alpha: 1).cgColor
        self.imgView.layer.borderWidth = 2
        
        self.viewForViewAll.layer.borderColor = #colorLiteral(red: 1, green: 0.4745098039, blue: 0.1529411765, alpha: 1).cgColor
        self.viewForViewAll.layer.borderWidth = 2
    }
    
    func setup(with vidup: MFMedia) {
        if self.timerCountdown != nil {
            self.timerCountdown!.invalidate()
            self.timerCountdown = nil
        }
        
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
        self.imgView.layer.cornerRadius = self.imgView.frame.width/2
        self.viewForViewAll.layer.cornerRadius = self.viewForViewAll.frame.width/2
        self.circleView.layer.cornerRadius = self.circleView.frame.width/2
        
        self.circleView.setup()
        self.animateCircleView()
    }
    
    func animateCircleView() {
        // Animate the drawing of the circle over the course of 1 second
        self.circleView.animateCircle(duration: 0.5)
    }
    
}
