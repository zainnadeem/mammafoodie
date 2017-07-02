//
//  ImageCollectionViewAdapter.swift
//  MediaPicker
//
//  Created by Arjav Lad on 27/06/17.
//  Copyright © 2017 Aakar Solutions. All rights reserved.
//

import UIKit

class ImageCollectionViewAdapter: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var collectionView : UICollectionView!
    var filteredImages : [UIImage] = [UIImage]()
    var sourceImage : UIImage!
    
    init(with image : UIImage) {
        self.sourceImage = image
    }
    
    func prepare(collectionView : UICollectionView) {
        self.collectionView = collectionView
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionCell")
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        cell.imageView.image = self.filteredImages[indexPath.item]
        
        return cell
    }
    
}
