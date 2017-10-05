//
//  DishesCollectionViewAdapter.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 12/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

protocol DishesCollectionViewAdapterDelegate {
    func openDishPageWith(dishID:String)
    func loadDishCollectionViewForIndex(_ index:SelectedIndexForProfile)
    func openFollowers(followers:Bool, userList:[MFUser])
    func openFavouriteDishes()
}

class DishesCollectionViewAdapter:NSObject,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView? {
        didSet {
            self.setUpCollectionView()
        }
    }
    
    var profileType: ProfileType! {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    var delegate: DishesCollectionViewAdapterDelegate?
    
    var selectedIndexForProfile: SelectedIndexForProfile! {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    var userData: MFUser? {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    var cookedDishData: [MFDish] = [MFDish]() {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    var boughtDishData: [MFDish] = [MFDish]() {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    var activityData: [MFNewsFeed] = [MFNewsFeed]() {
        didSet {
            self.activityCount = self.activityData.count
            self.collectionView?.reloadData()
        }
    }
    
    var followers: [MFUser] = [MFUser]() {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    var following: [MFUser] = [MFUser]() {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    var savedDishDataCount: Int = 0 {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var activityCount: Int = 0 {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var openURL: ((String, String) -> Void)?
    
    func setUpCollectionView() {
        
        //Register Dish cell
        self.collectionView!.register(DishCollectionViewCell.self, forCellWithReuseIdentifier: DishCollectionViewCell.reuseIdentifier)
        self.collectionView!.register(UINib(nibName: "DishCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: DishCollectionViewCell.reuseIdentifier)
        
        //Register Activity cell
        self.collectionView!.register(ActivityCollectionViewCell.self, forCellWithReuseIdentifier: "ActivityCollectionViewCell")
        self.collectionView!.register(UINib(nibName: "ActivityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ActivityCollectionViewCell")
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.emptyDataSetDelegate = self
        self.collectionView?.emptyDataSetSource = self
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.selectedIndexForProfile == .cooked  {
            return self.cookedDishData.count
        } else if self.selectedIndexForProfile == .bought{
            return self.boughtDishData.count
        } else {
            return self.activityData.count
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell! = UICollectionViewCell()
        cell.backgroundColor = .red
        if selectedIndexForProfile == .cooked {
            let dishCell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCollectionViewCell.reuseIdentifier, for: indexPath) as? DishCollectionViewCell
            let dish = self.cookedDishData[indexPath.item]
            if let dishCell = dishCell {
                dishCell.setUp(dish)
            }
            cell = dishCell
            
        } else if selectedIndexForProfile == .bought {
<<<<<<< HEAD
            let dishCell: DishCollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: DishCollectionViewCell.reuseIdentifier, for: indexPath) as? DishCollectionViewCell
=======
            let dishCell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCollectionViewCell.reuseIdentifier, for: indexPath) as? DishCollectionViewCell
>>>>>>> origin/BugFixes
            let dish = self.boughtDishData[indexPath.item]
            if let dishCell = dishCell {
                dishCell.setUp(dish)
            }
            cell = dishCell
            
        } else if selectedIndexForProfile == .activity {
            let activityCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCollectionViewCell", for: indexPath) as? ActivityCollectionViewCell
            let activity = self.activityData[indexPath.item]
            if let activityCell = activityCell {
                activityCell.setup(with: activity)
            }
            cell = activityCell
            
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView = UICollectionReusableView()
        if kind == UICollectionElementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "userHeaderView", for: indexPath) as! UserProfileCollectionViewHeader
            view.delegate = self.delegate
            view.profileType = self.profileType
            view.setUp (
                userData,
                followersCount: "\(followers.count)",
                followingCount: "\(following.count)",
                cookedDishesCount: "\(cookedDishData.count)",
                favouriteDishesCount: "0",
                boughtDishesCount: "\(boughtDishData.count)",
                followers: self.followers,
                following:self.following,
                savedDishCount: savedDishDataCount,
                activityCount: activityCount )
            reusableView = view
            reusableView.sizeToFit()
        } else {
            assert(false, "Unexpected element kind")
        }
        return reusableView
        
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // ofSize should be the same size of the headerView's label size:
        return CGSize(width: collectionView.frame.size.width, height: ((userData?.profileDescription?.calculateHeight(withConstrainedWidth: collectionView.frame.size.width, font: UIFont.MontserratLight(with: 14)!)) ?? 0) + 346)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize: CGSize = CGSize.zero
        if self.selectedIndexForProfile == .activity {
            let activityCell: ActivityCollectionViewCell? = Bundle.main.loadNibNamed("ActivityCollectionViewCell", owner: self, options: nil)?.first as? ActivityCollectionViewCell
            if let activityCell = activityCell {
                let activity = self.activityData[indexPath.item]
                activityCell.setup(with: activity)
                let width = UIScreen.main.bounds.width - 16
                activityCell.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: 188))
                activityCell.layoutIfNeeded()
                
                let size: CGSize = activityCell.systemLayoutSizeFitting(UILayoutFittingCompressedSize,
                                                                        withHorizontalFittingPriority: UILayoutPriorityDefaultHigh,
                                                                        verticalFittingPriority: UILayoutPriorityDefaultHigh)
                cellSize.height = size.height
                print("Size: \(size.height)")
            }
            cellSize.width = collectionView.frame.size.width
            
        } else {
            cellSize = CGSize(width: collectionView.frame.size.width/3 - 2, height: 150)
        }
        
        return cellSize
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if self.selectedIndexForProfile == .activity {
            return 10
        } else {
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndexForProfile == .cooked {
            let dish = self.cookedDishData[indexPath.item]
            self.delegate?.openDishPageWith(dishID: dish.id)
            
        } else if selectedIndexForProfile == .bought {
            let dish = self.boughtDishData[indexPath.item]
            self.delegate?.openDishPageWith(dishID: dish.id)
            
        }
        
    }
    
}

extension DishesCollectionViewAdapter: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if self.selectedIndexForProfile == .activity {
            return NSAttributedString.init(string: "No activity", attributes: [NSFontAttributeName: UIFont.MontserratLight(with: 15)!])
        }
        return NSAttributedString.init(string: "No dish", attributes: [NSFontAttributeName: UIFont.MontserratLight(with: 15)!])
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return self.collectionView(self.collectionView!, layout: self.collectionView!.collectionViewLayout, referenceSizeForHeaderInSection: 0).height - 120
    }

}

