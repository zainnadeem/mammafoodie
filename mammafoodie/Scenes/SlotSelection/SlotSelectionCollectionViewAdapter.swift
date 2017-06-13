//
//  SlotSelectionCollectionViewAdapter.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 12/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit


class SlotCollectionViewAdapter: NSObject, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var collectionView:UICollectionView? {
        didSet{
            collectionView?.delegate = self
            collectionView?.dataSource = self
        }
    }
     private let reuseIdentifier = "Cell"
    var selectedCells = [Int:Bool]()
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if cell.isSelected {
            cell.backgroundColor = .gray
        } else {
            cell.backgroundColor = .red
        }
        
        return cell
    }
    
    
    func selectCollectionViewCell(atIndexPath: IndexPath){
        self.collectionView?.selectItem(at: atIndexPath, animated: true, scrollPosition: .centeredVertically)
        self.collectionView!.delegate!.collectionView!(self.collectionView!, didSelectItemAt: atIndexPath)
        
    }
    
    func deSelectCollectionViewCell(atIndexPath: IndexPath){
        self.collectionView?.deselectItem(at: atIndexPath, animated: true)
        self.collectionView!.delegate!.collectionView!(self.collectionView!, didDeselectItemAt: atIndexPath)
    }
    
    
    // MARK: UICollectionViewDelegate
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .gray
        cell?.isSelected = true
        
        selectedCells.updateValue(true, forKey: indexPath.item)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .red
        cell?.isSelected = false
        
        selectedCells.removeValue(forKey: indexPath.item)
    }
 
}
