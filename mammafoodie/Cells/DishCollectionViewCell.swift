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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
