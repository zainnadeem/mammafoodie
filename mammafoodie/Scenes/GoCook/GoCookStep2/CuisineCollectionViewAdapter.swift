//
//  CuisineCollectionViewAdapter.swift
//  mammafoodie
//
//  Created by Arjav Lad on 21/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class CuisineCollectionViewAdapter: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var cuisineCollectionView : UICollectionView!
    var cuisines : [MFCuisine] = [MFCuisine]()
    var worker : CuisineWorker = CuisineWorker()
    
    func selectFilter(at indexPath: IndexPath) {
        if let _ = self.cuisineCollectionView.cellForItem(at: indexPath) {
            self.cuisineCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
        let filter = self.cuisines[indexPath.item]
        for cuisine in self.cuisines {
            if filter == cuisine {
                if cuisine.isSelected {
                    cuisine.isSelected = false
                } else {
                    cuisine.isSelected = true
                }
            } else {
                cuisine.isSelected = false
            }
        }
        self.cuisineCollectionView.reloadData()
    }
    
    func deselectAllCuisines() {
        let indexPath = IndexPath(item: 0, section: 0)
        if let _ = self.cuisineCollectionView.cellForItem(at: indexPath) {
            self.cuisineCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        for cuisine in self.cuisines {
            cuisine.isSelected = false
        }
        self.cuisineCollectionView.reloadData()
    }
    
    func showCuisines(_ cuisines: [MFCuisine]) {
        self.cuisines = cuisines
        self.cuisineCollectionView.reloadData()
    }
    
    func prepareCuisineCollectionView(_ collectionView : UICollectionView ) {
        self.cuisineCollectionView = collectionView
        self.cuisineCollectionView.delegate = self
        self.cuisineCollectionView.dataSource = self
        if let flow = self.cuisineCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.scrollDirection = .horizontal
        }
        self.cuisineCollectionView.register(UINib.init(nibName: "CuisineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CuisineCollectionViewCell")
        self.cuisineCollectionView.reloadData()
        self.worker.getCuisines { (cuisinesList, error) in
            self.showCuisines(cuisinesList!)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cuisines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuisineCollectionViewCell", for: indexPath) as! CuisineCollectionViewCell
        let filter = self.cuisines[indexPath.item]
        if filter.isSelected {
            cell.prepareCell(for: filter, is : true)
        } else {
            cell.prepareCell(for: filter, is : false)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectFilter(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var font : UIFont = CuisineCollectionViewCell.unselectedFont
        let cuisine = self.cuisines[indexPath.item]
        if cuisine.isSelected {
            font = CuisineCollectionViewCell.selectedFont
        }
        
        let height = 70
        var width = cuisine.name.calculateWidth(withConstrainedHeight: 21, font: font)
        if width < 80 {
            width = 80
        }
        width += 8
        return CGSize.init(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 10, 0, 0)
    }
    
}
