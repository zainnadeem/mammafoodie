//
//  CuisineSearchCollectionViewCell.swift
//  mammafoodie
//
//  Created by Arjav Lad on 16/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

fileprivate let unselectedTextColor : UIColor = UIColor.init(red: 177.0/255.0, green: 192.0/255.0, blue: 202.0/255.0, alpha: 1)
fileprivate let selectedTextColor : UIColor = .white

class CuisineSearchCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgViewEmoji.layer.cornerRadius = (self.imgViewEmoji.frame.size.width / 2)
        self.imgViewEmoji.clipsToBounds = true
        self.contentView.layoutIfNeeded()
    }
    
    @IBOutlet weak var imgViewEmoji: UIImageView!
    @IBOutlet weak var lblMenuTitle: UILabel!
    @IBOutlet weak var gradientView: GradientView!
    
    func prepareCell(for cuisine: CuisineFilter, is selected : Bool) {
        self.contentView.layoutIfNeeded()
        self.imgViewEmoji.layer.cornerRadius = (self.imgViewEmoji.frame.size.width / 2)
        self.imgViewEmoji.clipsToBounds = true
        
        self.lblMenuTitle.backgroundColor = .clear
        self.lblMenuTitle.text = cuisine.name
        self.imgViewEmoji.image = cuisine.unselectedImage
        
        if selected {
            let expandTransform:CGAffineTransform =  CGAffineTransform.init(scaleX: 1.15, y: 1.15)
            UIView.transition(with: self, duration: 0.27, options: .transitionCrossDissolve, animations: {
                self.imgViewEmoji.image = cuisine.selectedImage
                self.transform = expandTransform
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.27, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: { 
                    self.transform = expandTransform.inverted()
                }, completion: nil)
            })
        }
    }
}
