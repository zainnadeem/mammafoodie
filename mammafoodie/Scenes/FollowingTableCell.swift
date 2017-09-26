//
//  FollowingTableCell.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 13/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class FollowingTableCell: UITableViewCell {

    @IBOutlet weak var userProfile: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var Lable2: UILabel!
    @IBOutlet weak var followButtn: UIButton!
    
    var user:MFUser?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.userProfile.clipsToBounds = true
        self.userProfile.layer.cornerRadius = self.userProfile.frame.width/2
        self.followButtn.layer.cornerRadius = self.followButtn.frame.height/2
        self.followButtn.layer.borderWidth = 1
        self.followButtn.layer.borderColor = #colorLiteral(red: 1, green: 0.5998461843, blue: 0.206497252, alpha: 1).cgColor
        
        followButtn.addTarget(self, action: #selector(unfollow(sender:)), for: .touchUpInside)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setUp(user:MFUser){
        
        if let url = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: user.id) {
            self.userProfile.sd_setImage(with: url) { (image, error, cacheType, url) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.userProfile.image = #imageLiteral(resourceName: "IconMammaFoodie")
                    }
                }
            }
        } else {
            self.userProfile.image = #imageLiteral(resourceName: "IconMammaFoodie")
        }
        self.nameLbl.text = user.name
        self.Lable2.text = user.profileDescription
        self.user = user
    }
    
    func unfollow(sender:UIButton){
        let worker = OtherUsersProfileWorker()
        let currentUser = (UIApplication.shared.delegate as! AppDelegate).currentUser
        
        worker.toggleFollow(targetUser: self.user!.id, currentUser: currentUser!.id, targetUserName: user!.name, currentUserName: currentUser!.name, shouldFollow: false) { (status) in
            print(status)
        }
    }
    
}
