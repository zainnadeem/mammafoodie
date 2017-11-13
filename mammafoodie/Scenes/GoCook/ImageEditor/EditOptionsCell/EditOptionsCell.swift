//
//  EditOptionsCell.swift
//  Filters
//
//  Created by Arjav Lad on 16/05/17.
//  Copyright © 2017 Aakar Solutions. All rights reserved.
//

import UIKit

class EditOptionsCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var lblFilterName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageView.clipsToBounds = true
//        self.imageView.layer.cornerRadius = 15.0
        self.lblFilterName.textAlignment = .center
    }

}
