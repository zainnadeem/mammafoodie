//
//  MenuCuisineSelectorClnCell.swift
//  mammafoodie
//
//  Created by Akshit Zaveri on 19/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class MenuCuisineSelectorClnCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(with cuisine: MFCuisine) {
        self.lblTitle.text = cuisine.name
        if cuisine.isSelected {
            self.lblTitle.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            self.lblTitle.textColor = #colorLiteral(red: 0.1333333333, green: 0.1450980392, blue: 0.2745098039, alpha: 0.3)
        }
    }
}
