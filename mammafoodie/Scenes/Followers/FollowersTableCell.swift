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
    var shouldShowFollowButton: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.userProfile.clipsToBounds = true
        self.userProfile.layer.cornerRadius = self.userProfile.frame.width/2
        self.followButtn.layer.cornerRadius = self.followButtn.frame.height/2
        self.followButtn.layer.borderWidth = 1
        self.followButtn.layer.borderColor = #colorLiteral(red: 1, green: 0.5998461843, blue: 0.206497252, alpha: 1).cgColor
        self.followButtn.clipsToBounds = true
        
//        self.makeUnfollowButton()
        self.followButtn.addTarget(self, action: #selector(follow(sender:)), for: .touchUpInside)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func makeFollowButton() {
        self.followButtn.setTitle("follow", for: .normal)
        self.followButtn.setTitleColor(.orange, for: .normal)
        self.followButtn.removeGradient()
    }
    
    func makeUnfollowButton() {
        let color1 = UIColor(red: 1, green: 0.55, blue: 0.17, alpha: 1)
        let color2 = UIColor(red: 1, green: 0.39, blue: 0.13, alpha: 1)
        self.followButtn.applyGradient(colors: [color1, color2], direction: .leftToRight)
        self.followButtn.setTitleColor(.white, for: .normal)
        self.followButtn.setTitle("unfollow", for: .normal)
    }
    
    func setUp(user: MFUser) {
        if self.shouldShowFollowButton == true {
            self.makeFollowButton()
        } else {
            self.makeUnfollowButton()
        }
        
        self.layoutIfNeeded()
        
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
    
    func follow(sender:UIButton) {
        let worker = OtherUsersProfileWorker()
        let currentUser = (UIApplication.shared.delegate as! AppDelegate).currentUser
        
        var shouldFollow: Bool = false
        if sender.currentTitle == "follow" {
            self.makeUnfollowButton()
            self.layoutIfNeeded()
            shouldFollow = true
        } else {
            self.makeFollowButton()
            shouldFollow = false
        }
        
        let activity = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        self.followButtn.addSubview(activity)
        self.followButtn.isEnabled = false
        worker.toggleFollow(targetUser: self.user!.id, currentUser: currentUser!.id, targetUserName: user!.name, currentUserName: currentUser!.name, shouldFollow: shouldFollow) { (status) in
            DispatchQueue.main.async {
                self.followButtn.isEnabled = true
                activity.removeFromSuperview()
                print("Following: \(status)")
            }
        }
    }
    
}
