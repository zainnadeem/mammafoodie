//
//  CuisineSearchCollectionViewCell.swift
//  mammafoodie
//
//  Created by Arjav Lad on 16/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

let CuisineFilterCellFont : UIFont = UIFont.systemFont(ofSize: 14.0)
fileprivate let unselectedTextColor : UIColor = UIColor.init(red: 177.0/255.0, green: 192.0/255.0, blue: 202.0/255.0, alpha: 1)
fileprivate let selectedTextColor : UIColor = .white

class CuisineSearchCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //        self.layer.cornerRadius = (self.bounds.size.height / 2) - 5
        
        self.imgViewEmoji.layer.cornerRadius = (self.imgViewEmoji.frame.size.width / 2)
        self.imgViewEmoji.clipsToBounds = true
        
        self.lblMenuTitle.font = CuisineFilterCellFont
    }
    
    @IBOutlet weak var imgViewEmoji: UIImageView!
    @IBOutlet weak var lblMenuTitle: UILabel!
    @IBOutlet weak var gradientView: GradientView!
    
    func prepareCell(for cuisine: CuisineFilter, is selected : Bool) {
        
        //        self.layer.borderColor = UIColor.white.cgColor
        //        self.layer.borderWidth = 1.0
        
        //        self.lblMenuTitle.text = cuisine.name
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
//            UIView.animate(withDuration: 0.27, delay: 0, options: .curveEaseInOut, animations: {
//                self.imgViewEmoji.image = cuisine.selectedImage
//            }) { (finished) in
//                
//            }
        }
    }
    
    func showGradient(_ show : Bool) {
        if show {
            self.lblMenuTitle.textColor = selectedTextColor
            UIView.animate(withDuration: 0.27, delay: 0, options: .curveEaseInOut, animations: {
                self.gradientView.alpha = 1
            }) { (finished) in
                
            }
        } else {
            self.gradientView.alpha = 0
            self.lblMenuTitle.textColor = unselectedTextColor
        }
        
        
    }
    
}
