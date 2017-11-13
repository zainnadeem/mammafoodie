//
//  CuisineCollectionViewAdapter.swift
//  mammafoodie
//
//  Created by Arjav Lad on 15/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation

extension NearbyChefsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func prepareCuisineCollectionView() {
        self.cuisineCollectionView.delegate = self
        self.cuisineCollectionView.dataSource = self
        self.cuisineCollectionView.register(UINib.init(nibName: "CuisineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CuisineCollectionViewCell")
        self.cuisineCollectionView.reloadData()
        self.output.loadCuisines()
    }
    
    func selectFilter(at indexPath: IndexPath) {
        if let _ = self.cuisineCollectionView.cellForItem(at: indexPath) {
            self.cuisineCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
        let filter = self.cuisineFilters[indexPath.item]
        for cuisine in self.cuisineFilters {
            if filter == cuisine {
                if cuisine.isSelected {
                    cuisine.isSelected = false
                    self.searchAdapter.filter(for: nil)
                } else {
                   cuisine.isSelected = true
                    self.searchAdapter.filter(for: cuisine)
                }
            } else {
                cuisine.isSelected = false
            }
        }
        self.cuisineCollectionView.reloadData()
    }
    
    func showCuisines(_ cuisines: [MFCuisine]) {
        self.cuisineFilters = cuisines
        self.cuisineCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cuisineFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuisineCollectionViewCell", for: indexPath) as! CuisineCollectionViewCell
        let filter = self.cuisineFilters[indexPath.item]
        if filter.isSelected {
            cell.prepareCell(for: filter, is : true)
            cell.lblMenuTitle.textColor = .white
        } else {
            cell.prepareCell(for: filter, is : false)
            cell.lblMenuTitle.textColor = .white
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectFilter(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let filter = self.cuisineFilters[indexPath.item]
        let height = collectionView.frame.size.height * 0.9
        var width = filter.name.calculateWidth(withConstrainedHeight: 21, font: UIFont.MontserratLight(with: 12)!)
        if width < 90 {
            width = 90
        }
        width += 2
        return CGSize.init(width: width, height: height)
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
