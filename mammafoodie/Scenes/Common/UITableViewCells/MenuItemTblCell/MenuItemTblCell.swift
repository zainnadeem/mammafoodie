//
//  MenuItemTblCell.swift
//  mammafoodie
//
//  Created by Akshit Zaveri on 19/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class MenuItemTblCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgViewProfilePicture: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblDietType: UILabel!
    @IBOutlet weak var imgDietIcon: UIImageView!
    @IBOutlet weak var lblDishName: UILabel!
    @IBOutlet weak var lblTimeToPrepare: UILabel!
    @IBOutlet weak var lblOrderCounts: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var btnLikedCount: UIButton!
    @IBOutlet weak var viewSlotsLeftCount: UIView!
    @IBOutlet weak var btnOrderNow: UIButton!
    
    var shapeLayer: CAShapeLayer!
    var gradientLayer: CAGradientLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewContainer.layer.cornerRadius = 10
        self.viewContainer.clipsToBounds = true
        self.imgViewProfilePicture.layer.cornerRadius = self.imgViewProfilePicture.frame.width/2
        self.btnBookmark.imageView?.contentMode = .scaleAspectFit
        self.btnLikedCount.imageView?.contentMode = .scaleAspectFit
        self.viewSlotsLeftCount.layer.cornerRadius = self.viewSlotsLeftCount.frame.height/2
        self.btnOrderNow.layer.cornerRadius = self.btnOrderNow.frame.height/2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setup(with media: MFMedia) {
        self.imgView.image = UIImage(named: media.cover_small!)!
        self.lblDishName.text = media.dish.name
        self.lblUsername.text =  media.user.name
        self.imgViewProfilePicture.image = UIImage(named: media.user.picture!)!
    }
    
    func cellWillDisplay() {
        self.updateDropShadowForViewContainer()
        self.updateInnerShadowOnRightEndOfImageview()
        self.addGradientInOrderNowButton()
    }
    
    func updateDropShadowForViewContainer() {
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
            
            self.contentView.layer.insertSublayer(self.shapeLayer, at: 0)
        }
    }
    
    func updateInnerShadowOnRightEndOfImageview() {
        if self.gradientLayer == nil {
            self.gradientLayer = CAGradientLayer()
            let view: UIView = UIView(frame: self.imgView.frame)
            self.gradientLayer.frame = view.bounds
            self.gradientLayer.colors = [
                #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.750187286).cgColor,
                #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.750187286).cgColor,
                #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.4978431373).cgColor,
                #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.4978431373).cgColor,
                #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.4978431373).cgColor,
                #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.25).cgColor,
                #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.25).cgColor,
                #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).cgColor,
                #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).cgColor
            ]
            self.gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
            self.gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
            self.viewContainer.layer.insertSublayer(self.gradientLayer, above: self.imgView.layer)
        }
    }
    
    func addGradientInOrderNowButton() {
        self.btnOrderNow.applyGradient(colors: [#colorLiteral(red: 1, green: 0.5490196078, blue: 0.168627451, alpha: 1), #colorLiteral(red: 1, green: 0.3882352941, blue: 0.1333333333, alpha: 1)], direction: .leftToRight)
    }
    
    
    @IBAction func btnOptionsTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btnBookmarkTapped(_ sender: UIButton) {
    }
    
    
}
