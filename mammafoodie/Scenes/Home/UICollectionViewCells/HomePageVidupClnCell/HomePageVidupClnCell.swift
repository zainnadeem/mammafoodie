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
        self.layoutIfNeeded()
        self.imgView.layer.cornerRadius = self.imgView.frame.width/2
        self.viewForViewAll.layer.cornerRadius = self.viewForViewAll.frame.width/2
        self.circleView.layer.cornerRadius = self.circleView.frame.width/2
        
        self.vidup = vidup
        
        self.stopTimer()
        
        self.imgView.sd_cancelCurrentImageLoad()
        if vidup.id == "-1" {
            // Option to create new vidup
            self.imgView.layer.borderWidth = 2
            self.imgAddIcon.isHidden = false
            
            if let user = DatabaseGateway.sharedInstance.getLoggedInUser() {
                if let url: URL = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: user.id) {
                    self.imgView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "IconMammaFoodie"), options:.refreshCached, completed: { (image, error, cacheType, url) in
                        print("new Vidup picture refreshed")
                    })
                } else {
                    self.imgView.image = #imageLiteral(resourceName: "IconMammaFoodie")
                }
            } else {
                self.imgView.image = #imageLiteral(resourceName: "IconMammaFoodie")
            }
            self.circleView.isHidden = true
            self.circleView.vidup = nil
            self.circleView.currentValue = 0
            
        } else {
            // Show existing vidup details
            self.imgView.layer.borderWidth = 0
            self.imgAddIcon.isHidden = true
            if let url: URL = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: vidup.user.id) {
                self.imgView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "IconMammaFoodie"), options:.refreshCached, completed: { (image, error, cacheType, url) in
                    print("Vidup picture refreshed")
                })
            } else {
                self.imgView.image = #imageLiteral(resourceName: "IconMammaFoodie")
            }
            self.circleView.isHidden = false
        }
        
        let createTimestamp: TimeInterval = vidup.createTimestamp?.timeIntervalSinceReferenceDate ?? 0
        let endTimestamp: TimeInterval = vidup.endTimestamp?.timeIntervalSinceReferenceDate ?? 0
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
                    
                    //                    print("Set ID: \(vidup.id), Percentage: \((secondsPassed/totalSeconds)*100)")
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
    
    func showViewAll() {
        self.viewForViewAll.isHidden = false
    }
    
    func hideViewAll() {
        self.viewForViewAll.isHidden = true
    }
}
