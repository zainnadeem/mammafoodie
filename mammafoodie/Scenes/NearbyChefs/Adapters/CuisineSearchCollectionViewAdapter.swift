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
        self.cuisineCollectionView.register(UINib.init(nibName: "CuisineSearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CuisineSearchCollectionViewCell")
        self.cuisineCollectionView.reloadData()
        self.output.loadCuisines()
    }
    
    func selectFilter(at indexPath: IndexPath) {
        if let _ = self.cuisineCollectionView.cellForItem(at: indexPath) {
            self.cuisineCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        self.selectedFilter = self.cuisineFilters[indexPath.item]
        self.cuisineCollectionView.reloadData()
        self.output.loadMarkers(at: CLLocationCoordinate2D.init(latitude: kCameraLatitude, longitude: kCameraLongitude))
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
        if let selfilter = self.selectedFilter {
            cell.prepareCell(for: filter, is : (selfilter == filter))
        } else {
            cell.prepareCell(for: filter, is : false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectFilter(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //WARNING : sdsd
        
        //FIXME: Bug in imageview clip bounds
        if let cuisineCell = cell as? CuisineSearchCollectionViewCell {
            cuisineCell.contentView.layoutIfNeeded()
            cuisineCell.imgViewEmoji.layer.cornerRadius = (cuisineCell.imgViewEmoji.frame.size.height / 2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let filter = self.cuisineFilters[indexPath.item]
        let height = collectionView.frame.size.height * 0.9
//        var width = filter.name.calculateWidth(withConstrainedHeight: 21, font: CuisineFilterCellFont)
//        if width < 90 {
//            width = 90
//        }
//        width += 8
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

struct CuisineFilter : Equatable {
    let name : String!
    let id : String!
    let selectedImage : UIImage?
    let unselectedImage : UIImage?
    let pin : UIImage?
    
    static func ==(lhs: CuisineFilter, rhs : CuisineFilter) -> Bool {
        return lhs.id == rhs.id
    }
}
