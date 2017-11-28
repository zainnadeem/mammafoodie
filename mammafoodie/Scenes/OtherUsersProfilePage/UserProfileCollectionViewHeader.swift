//
//  UserProfileCollectionViewHeader.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 27/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit


class UserProfileCollectionViewHeader : UICollectionReusableView {
    
    var delegate: DishesCollectionViewAdapterDelegate?
    var profileType: ProfileType!
    var selectedIndexForProfile: SelectedIndexForProfile = .cooked
    let unSelectedMenuTextColor = UIColor(red: 83/255, green: 85/255, blue: 87/255, alpha: 1)
    var followers = [MFUser]()
    var following = [MFUser]()
    
    //MARK: - IBOutlets
    @IBOutlet weak var btnConversationsList: UIButton!
    @IBOutlet weak var lblUserName:UILabel!
    @IBOutlet weak var lblProfileDescription:UILabel!
    @IBOutlet weak var lblDishesSold:UILabel!
    @IBOutlet weak var lblFollowers:UILabel!
    @IBOutlet weak var lblFollowing:UILabel!
    @IBOutlet weak var collectionViewHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var cookedSegmentStackView: UIStackView!
    @IBOutlet weak var boughtSegmentStackView: UIStackView!
    @IBOutlet weak var activitySegmentStackView: UIStackView!
    @IBOutlet weak var menuSelectionHairlineView: UIView!
    @IBOutlet weak var lblCookedCount: UILabel!
    @IBOutlet weak var lblBoughtCount: UILabel!
    @IBOutlet weak var lblActivityCount: UILabel!
    @IBOutlet weak var hairLineViewXConstraint: NSLayoutConstraint?
    @IBOutlet weak var lblFavouriteDishesCount: UILabel!
    @IBOutlet weak var lblCookedDishesCount: UILabel!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var lblCookedMenuHeader: UILabel!
    @IBOutlet weak var lblBoughtMenuHeader: UILabel!
    @IBOutlet weak var lblActivityMenuHeader: UILabel!
    @IBOutlet weak var favouriteDishesStackView: UIStackView!
    @IBOutlet weak var followersSegmentStackView: UIStackView!
    @IBOutlet weak var followingSegmentStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapCooked = UITapGestureRecognizer(target: self, action: #selector(self.segmentedControlDidChangeSelection(sender:)))
        
        let tapBought = UITapGestureRecognizer(target: self, action: #selector(self.segmentedControlDidChangeSelection(sender:)))
        
        let tapActivity = UITapGestureRecognizer(target: self, action: #selector(self.segmentedControlDidChangeSelection(sender:)))
        
        self.cookedSegmentStackView.restorationIdentifier = "cooked"
        self.boughtSegmentStackView.restorationIdentifier = "bought"
        self.activitySegmentStackView.restorationIdentifier = "activity"
        
        self.lblUserName.text = ""
        
        self.cookedSegmentStackView.addGestureRecognizer(tapCooked)
        self.boughtSegmentStackView.addGestureRecognizer(tapBought)
        self.activitySegmentStackView.addGestureRecognizer(tapActivity)
        
        self.btnFollow.layer.cornerRadius = self.btnFollow.frame.size.height/2
        self.btnFollow.clipsToBounds = true
        
        self.menuSelectionHairlineView.layer.cornerRadius = self.menuSelectionHairlineView.frame.size.height/2
        self.menuSelectionHairlineView.clipsToBounds = true
        
        self.profilePicImageView.layer.cornerRadius = 5
        self.profilePicImageView.clipsToBounds  = true
        
        let tapFollowers = UITapGestureRecognizer(target: self, action: #selector(self.openFollowers(sender:)))
        let tapFollowing = UITapGestureRecognizer(target: self, action: #selector(self.openFollowing(sender:)))
        let tapFavourite = UITapGestureRecognizer(target: self, action: #selector(self.openFavouriteDishes(sender:)))
        
        self.followersSegmentStackView.addGestureRecognizer(tapFollowers)
        self.followingSegmentStackView.addGestureRecognizer(tapFollowing)
        self.favouriteDishesStackView.addGestureRecognizer(tapFavourite)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let color1 = UIColor(red: 1, green: 0.55, blue: 0.17, alpha: 1)
        let color2 = UIColor(red: 1, green: 0.39, blue: 0.13, alpha: 1)
        
        if profileType == .othersProfile {
            self.btnFollow.applyGradient(colors: [color1, color2], direction: .leftToRight)
            favouriteDishesStackView.isHidden = true //Hide favourite dishes in others profile page
            
        } else {
            //Own profile
            let greenColor = UIColor(red: 0, green: 0.74, blue: 0.22, alpha: 1)
            self.btnFollow.backgroundColor = greenColor
            self.btnFollow.setTitle("Go Cook", for: .normal)
            favouriteDishesStackView.isHidden = false
        }
        
        menuSelectionHairlineView.applyGradient(colors: [color1, color2], direction: .leftToRight)
    }
    
    func setUp(_ data:MFUser?, followersCount:String,followingCount:String,cookedDishesCount:String,favouriteDishesCount:String, boughtDishesCount:String, followers:[MFUser]?, following:[MFUser]?, savedDishCount: Int, activityCount: Int) {
        
        self.layoutIfNeeded()
        
        //Load Data
        
        self.followers = followers ?? []
        self.following = following ?? []
        
        print(savedDishCount.description)
        self.lblFavouriteDishesCount.text = savedDishCount.description
        
        guard let data = data else {return}
        
        guard let loggedInUser: MFUser = DatabaseGateway.sharedInstance.getLoggedInUser() else {
            return
        }
        
        if data.id == loggedInUser.id {
            self.btnConversationsList.isHidden = false
        } else {
            self.btnConversationsList.isHidden = true
        }
        
        self.lblUserName.text = data.name
        self.lblFollowers.text = followersCount
        self.lblFollowing.text = followingCount
        self.lblProfileDescription.text = data.profileDescription
        self.lblDishesSold.text = data.dishesSoldCount.description
        self.lblCookedDishesCount.text = cookedDishesCount
        self.lblCookedCount.text = cookedDishesCount
        self.lblFavouriteDishesCount.text = favouriteDishesCount
        self.lblBoughtCount.text = boughtDishesCount
        self.lblActivityCount.text = "\(activityCount)"
        
        self.profilePicImageView.sd_cancelCurrentImageLoad()
        if let url: URL = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: data.id) {
            self.profilePicImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "IconMammaFoodie"), options: .refreshCached, completed: { (image, error, cacheType, url) in
                print("user profile collection view header. picture refreshed")
            })
        } else {
            self.profilePicImageView.image = #imageLiteral(resourceName: "IconMammaFoodie")
        }
        
        if profileType == .othersProfile {
            if let currentUser = (UIApplication.shared.delegate as! AppDelegate).currentUserFirebase{
                DatabaseGateway.sharedInstance.checkIfUser(withuserID: currentUser.uid, isFollowing: data.id, { (following) in
                    if following{
                        self.btnFollow.setTitle("unfollow", for: .normal)
                    } else {
                        self.btnFollow.setTitle("follow", for: .normal)
                    }
                })
            }
        }
        self.updateHairLineMenuPosition()
        
    }
    
    //MARK: - Event Handling
    func segmentedControlDidChangeSelection(sender:UITapGestureRecognizer) {
        let senderView = sender.view!.restorationIdentifier!
        switch senderView {
        case "cooked":
            self.selectedIndexForProfile = .cooked
            self.delegate?.loadDishCollectionViewForIndex(.cooked)
            
        case "bought":
            self.selectedIndexForProfile = .bought
            self.delegate?.loadDishCollectionViewForIndex(.bought)
            
        case "activity":
            self.selectedIndexForProfile = .activity
            self.delegate?.loadDishCollectionViewForIndex(.activity)
            
        default:
            return
        }
        self.updateHairLineMenuPosition()
        UIView.animate(withDuration: 0.27, animations: {
            self.layoutIfNeeded()
        })
    }
    
    func openFollowers(sender:UITapGestureRecognizer) {
        self.delegate?.openFollowers(followers: true, userList:self.followers)
    }
    
    func openFollowing(sender:UITapGestureRecognizer) {
        self.delegate?.openFollowers(followers: false, userList:self.following)
    }
    
    func openFavouriteDishes(sender:UITapGestureRecognizer) {
        self.delegate?.openFavouriteDishes()
    }
    
    func updateHairLineMenuPosition() {
        self.lblBoughtMenuHeader.textColor = self.unSelectedMenuTextColor
        self.lblCookedMenuHeader.textColor = self.unSelectedMenuTextColor
        self.lblActivityMenuHeader.textColor = self.unSelectedMenuTextColor
        
        switch self.selectedIndexForProfile {
        case .cooked:
            self.hairLineViewXConstraint?.constant = self.cookedSegmentStackView.center.x - 10
            self.lblCookedMenuHeader.textColor = .black
            
        case .bought:
            self.hairLineViewXConstraint?.constant = self.boughtSegmentStackView.center.x - 10
            self.lblBoughtMenuHeader.textColor = .black
            
        case .activity:
            self.hairLineViewXConstraint?.constant = self.activitySegmentStackView.center.x - 10
            self.lblActivityMenuHeader.textColor = .black
        }
    }
    
}
