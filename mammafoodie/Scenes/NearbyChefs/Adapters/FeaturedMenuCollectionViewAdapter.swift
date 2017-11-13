//
//  FeaturedMenuCollectionViewAdapter.swift
//  mammafoodie
//
//  Created by Arjav Lad on 19/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation

class FeaturedMenuCollectionViewAdapter : NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var menuCollectionView : UICollectionView!
    
    func prepareCollectionView(_ collectionView : UICollectionView) {
        self.menuCollectionView = collectionView
        self.menuCollectionView.register(UINib.init(nibName: "FeaturedMenuCollectionCell", bundle: nil), forCellWithReuseIdentifier: "FeaturedMenuCollectionCell")
        self.menuCollectionView.delegate = self
        self.menuCollectionView.dataSource = self
        
        self.menuCollectionView.reloadData()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedMenuCollectionCell", for: indexPath) as! FeaturedMenuCollectionCell
        
        cell.imgViewItem.image = #imageLiteral(resourceName: "Minestrone Soup")
        cell.lblUserName.text = "Douglas Keller"
        cell.lblMenuItemName.text = "Pumpkin Soup"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.size.height - 20
        let width = collectionView.frame.size.height * 1.25
        return CGSize.init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 20, 0, 20)
    }
}
