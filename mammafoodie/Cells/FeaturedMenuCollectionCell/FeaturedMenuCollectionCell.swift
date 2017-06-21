//
//  FeaturedMenuCollectionCell.swift
//  mammafoodie
//
//  Created by Arjav Lad on 19/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class FeaturedMenuCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imgViewItem: UIImageView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblMenuItemName: UILabel!
    @IBOutlet weak var viewShadow: UIView!
    
    @IBOutlet weak var viewContainer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.clipsToBounds = false
        self.clipsToBounds = false
        
        self.viewContainer.clipsToBounds = true
        self.viewContainer.layer.cornerRadius = 10.0
        
        self.viewShadow.backgroundColor = .white
        self.viewShadow.layer.shadowColor = UIColor.black.cgColor
        self.viewShadow.layer.shadowOffset = CGSize(width: 1, height: 3)
        self.viewShadow.layer.shadowOpacity = 0.7
        self.viewShadow.layer.shadowRadius = 8.0
    }

}
