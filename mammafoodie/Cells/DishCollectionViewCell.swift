//
//  DishCollectionViewCell.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 19/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class DishCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DishCell"
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var lblChefName: UILabel!
    
    @IBOutlet weak var lblNumberOfViews: UILabel!
    
    @IBOutlet weak var lblDishTypeTag: UILabel!
    
    @IBOutlet weak var vegIndicatorImageView: UIImageView!
    
    @IBOutlet weak var lblDishName: UILabel!
    
    @IBOutlet weak var dishImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.width/2
        profilePicImageView.clipsToBounds = true
        
        dishImageView.applyGradient(colors: [.black,.clear,.black], direction: .topToBottom)
        
    }
    
    func setUp(_ dishData:MFMedia){
        
        self.lblChefName.text = dishData.user.name
        self.lblDishName.text = dishData.dish.name
        self.lblDishTypeTag.text = "HEALTHY"
        
        self.lblNumberOfViews.text = dishData.numberOfViewers.description
        self.profilePicImageView.image = UIImage(named: dishData.user.picture!)!
        self.dishImageView.image = UIImage(named: dishData.cover_large!)!
    }

}
