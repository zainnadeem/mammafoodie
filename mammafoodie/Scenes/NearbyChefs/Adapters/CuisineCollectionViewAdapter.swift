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
        self.cuisineCollectionView.clipsToBounds = false
        self.cuisineCollectionView.register(UINib.init(nibName: "CuisineSearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CuisineSearchCollectionViewCell")
        self.cuisineCollectionView.reloadData()
        
        self.output.loadCuisines()
    }
    
    func selectFilter(at indexPath: IndexPath) {
        self.cuisineCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
//        self.selectedFilter = nil
//        self.cuisineCollectionView.reloadItems(at: [indexPath])
        self.selectedFilter = self.cuisineFilters[indexPath.item]
        self.cuisineCollectionView.reloadData()
    }
    
    func showCuisines(_ cuisines: [CuisineFilter]) {
        self.cuisineFilters = cuisines
        self.selectedFilter = self.cuisineFilters.first
        self.cuisineCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cuisineFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuisineSearchCollectionViewCell", for: indexPath) as! CuisineSearchCollectionViewCell
        let filter = self.cuisineFilters[indexPath.item]
        cell.prepareCell(for: filter)
        if let selfilter = self.selectedFilter {
            cell.showGradient((selfilter == filter))
        } else {
            cell.showGradient(false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectFilter(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let filter = self.cuisineFilters[indexPath.item]
        let height = collectionView.frame.size.height
        var width = filter.name.calculateWidth(withConstrainedHeight: 21, font: CuisineFilterCellFont)
        if width < 90 {
            width = 90
        }
        width += 8
        return CGSize.init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 5, 0, 0)
    }

}

struct CuisineFilter : Equatable {
    let name : String!
    let id : String!
    
    static func ==(lhs: CuisineFilter, rhs : CuisineFilter) -> Bool {
        return lhs.id == rhs.id
    }
}
