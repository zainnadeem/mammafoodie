
//
//  CuisineCollectionViewCell.swift
//  mammafoodie
//
//  Created by Arjav Lad on 21/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class CuisineCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var imgViewEmoji: UIImageView!
    @IBOutlet weak var lblMenuTitle: UILabel!
    
    func prepareCell(for cuisine: MFCuisine, is selected : Bool) {
        self.contentView.layoutIfNeeded()
        self.lblMenuTitle.backgroundColor = .clear
        self.lblMenuTitle.text = cuisine.name
        if selected {
            let expandTransform:CGAffineTransform =  CGAffineTransform.init(scaleX: 1.15, y: 1.15)
            self.imgViewEmoji.image = cuisine.selectedImage
            UIView.transition(with: self, duration: 0.27, options: .transitionCrossDissolve, animations: {
                self.transform = expandTransform
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.27, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
                    self.transform = expandTransform.inverted()
                }, completion: nil)
            })
        } else {
            self.imgViewEmoji.image = cuisine.unselectedImage
        }
    }

}


