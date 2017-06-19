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
    }
}
