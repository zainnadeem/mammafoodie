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
    @IBOutlet weak var lblLastMessage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profilePicImageView.layer.cornerRadius = 22
        self.profilePicImageView.clipsToBounds = true
    }
    
    func setup(conversation:MFConversation, currentUserID:String) {
        var user: String!
        var userName: String!
        if conversation.user1 == currentUserID {
            user = conversation.user2
            userName = conversation.user2Name
        } else {
            user = conversation.user1
            userName = conversation.user1Name
        }
        
        self.lblUserName.text = userName
        let url = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: user)
        if let url = url {
            self.profilePicImageView.sd_setImage(with: url, placeholderImage: UIImage(named:"IconMammaFoodie")!)
        }
    }
}
