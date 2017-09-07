//
//  WalletTransactionsTblCell.swift
//  mammafoodie
//
//  Created by Arjav Lad on 25/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class WalletTransactionsTblCell: UITableViewCell {
    
//    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var lblAction: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func set(transaction: MFTransaction) {
        self.lblAction.text = transaction.getReadableText()
        
//        if let dishId = transaction.dishId {
//            if let url = FirebaseReference.dishes.getImagePath(with: dishId) {
//                self.imageViewUser.sd_setImage(with: url, placeholderImage: UIImage(named:"IconMammaFoodie")!)
//            }
//        }
//        self.imageViewUser.layer.cornerRadius = self.imageViewUser.frame.height / 2.0
    }
}
