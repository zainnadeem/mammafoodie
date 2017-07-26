//
//  SavedCardClnCell.swift
//  mammafoodie
//
//  Created by Akshit Zaveri on 26/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import Stripe

class SavedCardClnCell: UICollectionViewCell {

    @IBOutlet weak var imgViewBrand: UIImageView!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblCardExpiry: UILabel!
    @IBOutlet weak var viewContent: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewContent.layer.cornerRadius = 5
    }

    func set(card: STPCard) {
        self.lblCardNumber.text = "XXXX-XXXX-XXXX-\(card.last4())"
        self.lblCardExpiry.text = "\(card.expMonth) \(card.expYear)"
        self.imgViewBrand.image = STPPaymentCardTextField.brandImage(for: card.brand)
    }
}
