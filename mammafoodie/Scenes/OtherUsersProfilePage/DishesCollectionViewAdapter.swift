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
    
}

class DishesCollectionViewAdapter:NSObject,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var collectionView:UICollectionView? {
        didSet{
            setUpCollectionView()
        }
    }
    
    var cellSize:CGSize!
    
    var delegate:DishesCollectionViewAdapterDelegate?
    
    var selectedIndexForProfile:SelectedIndexForProfile!
    
    var dataSource : [AnyHashable:Any]? {
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
        
        print(dataSource?.keys.count)
        return dataSource?.keys.count ?? 0
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell : UICollectionViewCell!
        
        if selectedIndexForProfile == .cooked || selectedIndexForProfile == .bought {
            
            let dishCell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCollectionViewCell.reuseIdentifier, for: indexPath) as! DishCollectionViewCell
            
            var mediaDataSource = [MFMedia]()
            
            for media in dataSource!.keys where ((media as? MFMedia) != nil) {
                
                mediaDataSource.append(media as! MFMedia)
                
            }
            
            let dishData = mediaDataSource[indexPath.item] 
            
            dishCell.setUp(dishData)
            
            cell = dishCell
            
        } else if selectedIndexForProfile == .activity {
            
            let activityCell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityCollectionViewCell.reuseIdentifier, for: indexPath) as! ActivityCollectionViewCell
            
            var activityDataSource = [MFNewsFeed]()
            
            for activity in dataSource!.keys where ((activity as? MFNewsFeed) != nil) {
                
                activityDataSource.append(activity as! MFNewsFeed)
                
            }
            
            let activityData = activityDataSource[indexPath.item]
            
            activityCell.setup(activityData)
            
            cell = activityCell
            
        }
        
        
        return cell
    }

    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.selectedIndexForProfile == .activity{
            cellSize = CGSize(width: collectionView.frame.size.width - 10, height: 150)
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
