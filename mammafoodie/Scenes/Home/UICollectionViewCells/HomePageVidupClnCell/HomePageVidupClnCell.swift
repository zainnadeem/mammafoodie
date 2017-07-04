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
    
    var vidup: MFDish?
    var timerCountdown: Timer?
    var circleLayer: CAShapeLayer!
    
    var vidupDidEnd: ((MFDish)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgAddIcon.layer.cornerRadius = 8
        
        self.imgView.layer.borderColor = #colorLiteral(red: 1, green: 0.4745098039, blue: 0.1529411765, alpha: 1).cgColor
        self.imgView.layer.borderWidth = 2
        
        self.viewForViewAll.layer.borderColor = #colorLiteral(red: 1, green: 0.4745098039, blue: 0.1529411765, alpha: 1).cgColor
        self.viewForViewAll.layer.borderWidth = 2
    }
    
    func setup(with vidup: MFDish) {
        self.vidup = vidup
        
        self.stopTimer()
        
        self.viewForViewAll.isHidden = true
        if vidup.id == "-1" {
            // Option to create new vidup
            self.imgView.layer.borderWidth = 2
            self.imgAddIcon.isHidden = false
            self.imgView.image = UIImage(named: "ProfilePicture21")!
            self.circleView.isHidden = true
            self.circleView.vidup = nil
            self.circleView.currentValue = 0
        } else if vidup.id == "30" {
            self.viewForViewAll.isHidden = false
            self.circleView.isHidden = false
        } else {
            // Show existing vidup details
            self.imgView.layer.borderWidth = 0
            self.imgAddIcon.isHidden = true
            if let url: URL = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: vidup.user.id) {
                self.imgView.sd_setImage(with: url)
            } else {
                self.imgView.image = nil
            }
            self.circleView.isHidden = false
        }
        self.imgView.layer.cornerRadius = self.imgView.frame.width/2
        self.viewForViewAll.layer.cornerRadius = self.viewForViewAll.frame.width/2
        self.circleView.layer.cornerRadius = self.circleView.frame.width/2
        
        
        let createTimestamp: TimeInterval = vidup.createdAt?.timeIntervalSinceReferenceDate ?? 0
        let endTimestamp: TimeInterval = vidup.endedAt?.timeIntervalSinceReferenceDate ?? 0
        if endTimestamp > 0 {
            self.circleView.setup()
            self.circleView.vidup = vidup
            
            if endTimestamp < Date().timeIntervalSinceReferenceDate {
                self.circleView.animateCircle(duration: 0, toValue: 1)
            } else {
                self.timerCountdown = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                    if vidup != self.circleView.vidup {
                        self.circleView.vidup = vidup
                        self.circleView.currentValue = 0
                    }
                    let totalSeconds: TimeInterval = endTimestamp - createTimestamp
                    let currentTimestamp: TimeInterval = Date().timeIntervalSinceReferenceDate
                    let secondsPassed: TimeInterval = currentTimestamp - createTimestamp
                    self.circleView.animateCircle(duration: 0.5, toValue: secondsPassed/totalSeconds)
                    
                    if secondsPassed > totalSeconds {
                        self.stopTimer()
                        self.vidupDidEnd?(self.vidup!)
                    }
                    
                    print("Set ID: \(vidup.id), Percentage: \((secondsPassed/totalSeconds)*100)")
                })
            }
        } else {
            self.circleView.isHidden = true
        }
    }
    
    func stopTimer() {
        if self.timerCountdown != nil {
            self.timerCountdown!.invalidate()
            self.timerCountdown = nil
        }
    }
}
