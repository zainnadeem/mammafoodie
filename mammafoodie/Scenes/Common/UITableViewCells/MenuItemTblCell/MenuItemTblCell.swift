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
    
    var shadowLayer: CALayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewContainer.layer.cornerRadius = 10
        self.viewContainer.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imgViewProfilePicture.layer.cornerRadius = self.imgViewProfilePicture.frame.width/2
    }
    
    func setup(with media: MFMedia) {
        self.imgView.image = UIImage(named: media.cover_small!)!
        self.lblDishName.text = media.dish.name
        self.lblUsername.text =  media.user.name
        self.imgViewProfilePicture.image = UIImage(named: media.user.picture!)!
    }
    
    @IBAction func btnOptionsTapped(_ sender: UIButton) {
        
    }
    
}
