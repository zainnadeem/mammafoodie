//
//  DishesCollectionViewAdapter.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 12/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

protocol DishesCollectionViewAdapterDelegate{
    
    func openDishPageWith(dishID:Int)
    func loadDishCollectionViewForIndex(_ index:SelectedIndexForProfile)
}

class DishesCollectionViewAdapter:NSObject,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var collectionView:UICollectionView? {
        didSet{
            setUpCollectionView()
        }
    }
    
    var profileType:ProfileType! {
        didSet{
            collectionView?.reloadData()
        }
    }
    
    var cellSize:CGSize!
    
    var delegate:DishesCollectionViewAdapterDelegate?
    
    var selectedIndexForProfile:SelectedIndexForProfile!
    
    var userData : MFUser? {
        didSet{
            collectionView?.reloadData()
        }
    }
    
    var dishData:[MFDish]?{
        didSet{
            collectionView?.reloadData()
        }
    }
    
    var activityData:[MFNewsFeed]?{
        didSet{
            collectionView?.reloadData()
        }
    }
    
    func setUpCollectionView(){
        
        //Register Dish cell
        collectionView!.register(DishCollectionViewCell.self, forCellWithReuseIdentifier: DishCollectionViewCell.reuseIdentifier)
        collectionView!.register(UINib(nibName: "DishCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: DishCollectionViewCell.reuseIdentifier)
        
        //Register Activity cell
        collectionView!.register(ActivityCollectionViewCell.self, forCellWithReuseIdentifier: ActivityCollectionViewCell.reuseIdentifier)
        collectionView!.register(UINib(nibName: "ActivityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ActivityCollectionViewCell.reuseIdentifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if selectedIndexForProfile == .cooked || selectedIndexForProfile == .bought {
            return dishData?.count ?? 0
        } else {
            return activityData?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell : UICollectionViewCell! = UICollectionViewCell()
        cell.backgroundColor = .red
        
        
        if selectedIndexForProfile == .cooked || selectedIndexForProfile == .bought {
            
            let dishCell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCollectionViewCell.reuseIdentifier, for: indexPath) as! DishCollectionViewCell
            
            let dish = dishData![indexPath.item]
            dishCell.setUp(dish)
        
            cell = dishCell
            
        } else if selectedIndexForProfile == .activity {
            
            let activityCell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityCollectionViewCell.reuseIdentifier, for: indexPath) as! ActivityCollectionViewCell
            

            let activity = activityData![indexPath.item]
            activityCell.setup(activity)
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
            
            view.setUp(userData)
            
            reusableView = view
        } else {
            assert(false, "Unexpected element kind")
        }
        
        return reusableView
        
    }
    
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.selectedIndexForProfile == .activity{
            cellSize = CGSize(width: collectionView.frame.size.width, height: 150)
        } else {
            cellSize = CGSize(width: collectionView.frame.size.width/3 - 2, height: 150)
        }
        
        return cellSize
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if self.selectedIndexForProfile == .activity{
            return 10
        } else {
            return 2
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.openDishPageWith(dishID: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        
    }

}
