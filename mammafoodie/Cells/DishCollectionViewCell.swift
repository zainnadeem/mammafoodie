//
//  DishCollectionViewCell.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 19/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import SDWebImage

class DishCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DishCell"
    
    @IBOutlet weak var lblNumberOfViews: UILabel!
    
    @IBOutlet weak var lblDishTypeTag: UILabel!
    
    @IBOutlet weak var vegIndicatorImageView: UIImageView!
    
    @IBOutlet weak var lblDishName: UILabel!
    
    @IBOutlet weak var dishImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dishImageView.applyGradient(colors: [.black,.clear,.black], direction: .topToBottom)
        
    }
    
    func setUp(_ dishData:MFDish){
        
        DatabaseGateway.sharedInstance.getMediaWith(mediaID: dishData.mediaID!) { (media) in
            
            guard let media = media else {return}
            
            self.lblDishName.text = dishData.name
            self.lblDishTypeTag.text = dishData.tag
            
            if  dishData.dishType != nil {
                
                switch dishData.dishType! {
                    
                case .NonVeg: self.vegIndicatorImageView.image = #imageLiteral(resourceName: "Non Veg")
                case .Veg: self.vegIndicatorImageView.image = #imageLiteral(resourceName: "Veg")
                case .Vegan , .None: self.vegIndicatorImageView.image = nil
                    
                }
                
            }
            
            self.lblNumberOfViews.text = media.numberOfViewers.description
            
            if let picURL = media.cover_large{
                self.dishImageView.sd_setImage(with: picURL)
            }
        }
    }

}
