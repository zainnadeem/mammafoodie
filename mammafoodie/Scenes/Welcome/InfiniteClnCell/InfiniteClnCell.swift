
//
//  InfiniteClnCell.swift
//  mammafoodie
//
//  Created by Arjav Lad on 01/08/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class InfiniteClnCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imageView.layer.cornerRadius = 5.0
        self.imageView.clipsToBounds = true
    }

}
