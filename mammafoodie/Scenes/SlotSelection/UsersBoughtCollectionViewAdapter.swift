//
//  UsersBoughtCollectionViewAdapter.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 22/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit


class UsersBoughtCollectionViewAdapter:NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var collectionView:UICollectionView? {
        didSet{
            setUpCollectionView()
        }
    }

    var dataSource : [MFUser]?
    
    func setUpCollectionView(){
        
        //Register cell
        collectionView!.register(SlotSelectionCollectionViewCell.self, forCellWithReuseIdentifier: SlotSelectionCollectionViewCell.reuseIdentifier)
        collectionView!.register(UINib(nibName: "SlotSelectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SlotSelectionCollectionViewCell.reuseIdentifier)
        
        
        
        collectionView?.delegate = self
        collectionView?.dataSource = self

    }
    
    
    
    //CollectionView dataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataSource?.count ?? 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlotSelectionCollectionViewCell.reuseIdentifier, for: indexPath) as! SlotSelectionCollectionViewCell
        
        //cell.imageView.layer.cornerRadius = cell.imageView.frame.size.height/2
        cell.imageView.clipsToBounds = true
        
//        let user = dataSource[indexPath.item]
        
        cell.imageView.image = UIImage(named: "chefScreenShot")
        
        return cell
    }
    
    
    //CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        

        return CGSize(width: 60 , height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -50
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    
}
