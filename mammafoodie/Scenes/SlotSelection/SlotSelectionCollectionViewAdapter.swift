//
//  SlotSelectionCollectionViewAdapter.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 12/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit


class SlotCollectionViewAdapter: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var collectionView:UICollectionView? {
        didSet{
            setUpCollectionView()
        }
    }

    var selectedCells = [Int:Bool]()
    
    var totalSlotsCount : Int! = 30
    
    let interItemSpacingForCollectionView : CGFloat = 3
    
    let slotsPerRow = 4
    
    func setUpCollectionView(){
        
        //Register cell
        collectionView!.register(SlotSelectionCollectionViewCell.self, forCellWithReuseIdentifier: SlotSelectionCollectionViewCell.reuseIdentifier)
        collectionView!.register(UINib(nibName: "SlotSelectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SlotSelectionCollectionViewCell.reuseIdentifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
    
    
    func addCollectionViewGrid(){
        
        let gridLineViewThickness:CGFloat = 11
        
        let cvWidth = collectionView!.frame.size.width
        
        //Add vertical lines
        (1..<slotsPerRow).forEach({ (index) in
            
            let fIndex = CGFloat(index)
            
            let verticalView = UIView()
            
            verticalView.frame = CGRect(x: ((cvWidth/4) * fIndex) - (gridLineViewThickness/2) , y: 0, width: gridLineViewThickness, height: collectionView!.contentSize.height)
            
            verticalView.backgroundColor = UIColor(red: 0.27, green: 0.27, blue: 0.27, alpha: 1)
            verticalView.layer.cornerRadius = gridLineViewThickness/2
            verticalView.clipsToBounds = true
            collectionView!.addSubview(verticalView)
            
        })
        
        //Add Horizontal lines
        let quotient = totalSlotsCount/slotsPerRow
        
        var numberOfHorizontalLines = quotient
        
        if totalSlotsCount % slotsPerRow == 0 {
            numberOfHorizontalLines = quotient - 1
        }
        
        (1...numberOfHorizontalLines).forEach { (index) in
            
            let fIndex = CGFloat(index)
            
            let horizontalView = UIView()
            horizontalView.frame = CGRect(x: 0, y: ((cvWidth/4) * fIndex) - (gridLineViewThickness/2), width: collectionView!.frame.size.width, height: gridLineViewThickness)
            
            horizontalView.backgroundColor = UIColor(red: 0.27, green: 0.27, blue: 0.27, alpha: 1)
            horizontalView.layer.cornerRadius = gridLineViewThickness/2
            horizontalView.clipsToBounds = true
            collectionView!.addSubview(horizontalView)
        }
        
        
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return totalSlotsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlotSelectionCollectionViewCell.reuseIdentifier, for: indexPath) as! SlotSelectionCollectionViewCell
       
        if cell.isSelected {
            cell.imageView.image = UIImage(named: "Food Bowl Selected")
        } else {
            cell.imageView.image = UIImage(named: "Food Bowl Unselected")
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
        let cell = collectionView.cellForItem(at: indexPath) as! SlotSelectionCollectionViewCell
        cell.imageView.image = UIImage(named: "Food Bowl Selected")
        cell.isSelected = true
        
        selectedCells.updateValue(true, forKey: indexPath.item)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SlotSelectionCollectionViewCell
        cell.imageView.image = UIImage(named: "Food Bowl Unselected")
        cell.isSelected = false
        
        selectedCells.removeValue(forKey: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width/4 - (interItemSpacingForCollectionView * 3)
        
        return CGSize(width: width , height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacingForCollectionView * 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacingForCollectionView
    }
 
}
