//
//  ChatListTableViewCell.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 21/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePicImageView.layer.cornerRadius = 25
        profilePicImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(conversation:MFConversation, currentUserID:String){
        
        if conversation.user1 == currentUserID {
            self.lblUserName.text = conversation.user2Name
            let url = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: conversation.user2)
            if let url = url{
                self.profilePicImageView.sd_setImage(with: url, placeholderImage: UIImage(named:"IconMammaFoodie")!)
            }
        } else {
            self.lblUserName.text = conversation.user1Name
            let url = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: conversation.user1)
            if let url = url{
                self.profilePicImageView.sd_setImage(with: url, placeholderImage: UIImage(named:"IconMammaFoodie")!)
            }
        }

    }
    
}
