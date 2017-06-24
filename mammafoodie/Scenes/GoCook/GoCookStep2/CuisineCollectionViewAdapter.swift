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
    var selectedCuisine: MFCuisine?
    var worker : CuisineWorker = CuisineWorker()
    
    func selectFilter(at indexPath: IndexPath) {
        self.selectedCuisine = self.cuisines[indexPath.item]
        if let _ = self.cuisineCollectionView.cellForItem(at: indexPath) {
            self.cuisineCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        self.cuisineCollectionView.reloadData()
    }
    
    func showCuisines(_ cuisines: [MFCuisine]) {
        self.cuisines = cuisines
        self.selectedCuisine = self.cuisines.first
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
        if let selfilter = self.selectedCuisine {
            cell.prepareCell(for: filter, is : (selfilter == filter))
        } else {
            cell.prepareCell(for: filter, is : false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectFilter(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font  = UIFont.MontserratLight(with: 12)
        let cuisine = self.cuisines[indexPath.item]
        let height = 70
        var width = cuisine.name.calculateWidth(withConstrainedHeight: 21, font: font!)
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

struct Cuisine : Equatable {
    let name : String!
    let id : String!
    let selectedImage : UIImage?
    let unselectedImage : UIImage?
    
    static func ==(lhs: Cuisine, rhs : Cuisine) -> Bool {
        return lhs.id == rhs.id
    }
}

