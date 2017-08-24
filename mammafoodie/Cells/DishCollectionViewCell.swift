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
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
        
    }
    
    func setUp(_ dishData:MFDish){
        
        self.lblDishName.text = dishData.name
        self.lblDishTypeTag.text = dishData.tag
        DatabaseGateway.sharedInstance.getMediaWith(mediaID: dishData.id) { (media) in
            guard media != nil else { return }
            self.lblDishName.text = dishData.name
            self.lblDishTypeTag.text = dishData.tag
        }
        
        switch dishData.dishType {
        case .NonVeg:
            self.vegIndicatorImageView.image = #imageLiteral(resourceName: "Nonveg_selected")
        case .Veg:
            self.vegIndicatorImageView.image = #imageLiteral(resourceName: "Veg_selected")
        case .Vegan:
            self.vegIndicatorImageView.image = #imageLiteral(resourceName: "Vegan_selected")
        case .None:
            self.vegIndicatorImageView.image = nil
        }
        
        //        self.lblDishTypeTag.text = ""
        self.lblNumberOfViews.text = dishData.numberOfViewers.description
        if let picURL = dishData.mediaURL {
            //            print(picURL.absoluteString)
            self.dishImageView.sd_setImage(with: picURL)
        }
    }
}
