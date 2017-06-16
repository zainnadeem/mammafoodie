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
        self.layer.cornerRadius = (self.bounds.size.height / 2) - 5
        self.clipsToBounds = true
        
        self.lblMenuTitle.font = CuisineFilterCellFont
    }
    
    @IBOutlet weak var lblMenuTitle: UILabel!
    @IBOutlet weak var gradientView: GradientView!
    
    func prepareCell(for cuisine: CuisineFilter) {
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
        
        self.lblMenuTitle.text = cuisine.name
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
