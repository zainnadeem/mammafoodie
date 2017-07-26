//
//  FollowersTableCell.swift
//  mammafoodie
//
//  Created by Sireesha V on 7/3/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class FollowersTableCell: UITableViewCell {
    
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
        self.followButtn.clipsToBounds = true
        
        addGradient()
        
        followButtn.addTarget(self, action: #selector(follow(sender:)), for: .touchUpInside)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func addGradient(){
        let color1 = UIColor(red: 1, green: 0.55, blue: 0.17, alpha: 1)
        let color2 = UIColor(red: 1, green: 0.39, blue: 0.13, alpha: 1)
        
        
        
        followButtn.applyGradient(colors: [color1, color2], direction: .leftToRight)
    }
    
    func setUp(user:MFUser){
        
        self.userProfile.sd_setImage(with: user.generateProfilePictureURL())
        self.nameLbl.text = user.name
        self.Lable2.text = user.profileDescription
        self.user = user
        
        if let currentUser = AppDelegate.shared().currentUser {
            DatabaseGateway.sharedInstance.checkIfUser(withuserID: currentUser.id, isFollowing: user.id, { (following) in
                
                if following{
                    self.followButtn.setTitle("Unfollow", for: .normal)
                    
                    self.followButtn.removeGradient()
                    self.followButtn.setTitleColor(.orange, for: .normal)
                } else {
                    self.followButtn.setTitle("Follow", for: .normal)
                    self.followButtn.setTitleColor(.white, for: .normal)
                    self.removeGradient()
                }
                self.layoutIfNeeded()
            })
        }
    }
    
    func follow(sender:UIButton){
        let worker = OtherUsersProfileWorker()
        let currentUser = (UIApplication.shared.delegate as! AppDelegate).currentUser
        
        var shouldFollow:Bool
        
        if sender.currentTitle == "Follow"{
            sender.setTitle("Unfollow", for: .normal)
            sender.setTitleColor(.orange, for: .normal)
            sender.removeGradient()
            self.layoutIfNeeded()
            shouldFollow = true
        } else {
            sender.setTitle("Follow", for: .normal)
            sender.setTitleColor(.white, for: .normal)
            addGradient()
            shouldFollow = false
        }
        
        worker.toggleFollow(targetUser: self.user!.id, currentUser: currentUser!.id, targetUserName: user!.name, currentUserName: currentUser!.name, shouldFollow: shouldFollow) { (status) in
            print(status)
        }
    }
    
}
