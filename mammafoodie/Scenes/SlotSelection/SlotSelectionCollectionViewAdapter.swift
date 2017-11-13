//
//  SlotSelectionCollectionViewAdapter.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 12/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

protocol SlotCollectionAdapterDelegate{
    func selectedSlotsCount(_ count:Int)
}


class SlotCollectionViewAdapter: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    private var collectionView : UICollectionView!
    var delegate : SlotCollectionAdapterDelegate!
    
    var selectedCells = [Int:Bool]() {
        didSet {
            self.delegate.selectedSlotsCount(selectedCells.keys.count)
        }
    }
    
    var totalSlotsCount : UInt = 0
    
    let interItemSpacingForCollectionView : CGFloat = 3
    
    let slotsPerRow : UInt = 4
    
    var availableSlots : UInt = 0
    
    func setUpCollectionView(_ collection : UICollectionView, totalSlots : UInt, availableSlots : UInt) {
        
        //Register cell
        self.collectionView = collection
        self.collectionView.register(SlotSelectionCollectionViewCell.self, forCellWithReuseIdentifier: SlotSelectionCollectionViewCell.reuseIdentifier)
        self.collectionView.register(UINib(nibName: "SlotSelectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SlotSelectionCollectionViewCell.reuseIdentifier)
        self.collectionView.showsVerticalScrollIndicator = false
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsMultipleSelection = true
        
        self.totalSlotsCount = totalSlots
        self.availableSlots = availableSlots
    }
    
    
    func addCollectionViewGrid() {
        
        let gridLineViewThickness:CGFloat = 11
        
        let cvWidth = collectionView.frame.size.width
        
        //Add vertical lines
        (1 ..< self.slotsPerRow).forEach({ (index) in
            
            let fIndex = CGFloat(index)
            
            let verticalView = UIView()
            
            verticalView.frame = CGRect(x: ((cvWidth/4) * fIndex) - (gridLineViewThickness/2) , y: 0, width: gridLineViewThickness, height: self.collectionView.contentSize.height)
            
            verticalView.backgroundColor = UIColor(red: 0.27, green: 0.27, blue: 0.27, alpha: 1)
            verticalView.layer.cornerRadius = gridLineViewThickness/2
            verticalView.clipsToBounds = true
            self.collectionView.addSubview(verticalView)
            
        })
        
        //Add Horizontal lines
        let quotient = Int(self.totalSlotsCount / self.slotsPerRow)
        
        var numberOfHorizontalLines = quotient
        
        if self.totalSlotsCount > 0 {
            if self.totalSlotsCount % self.slotsPerRow == 0 {
                numberOfHorizontalLines = quotient - 1
            }
            
            if numberOfHorizontalLines <= 0 {
                return
            }
            (1 ... numberOfHorizontalLines).forEach { (index) in
                let fIndex = CGFloat(index)
                let horizontalView = UIView()
                horizontalView.frame = CGRect(x: 0, y: ((cvWidth/4) * fIndex) - (gridLineViewThickness/2), width: self.collectionView.frame.size.width, height: gridLineViewThickness)
                
                horizontalView.backgroundColor = UIColor(red: 0.27, green: 0.27, blue: 0.27, alpha: 1)
                horizontalView.layer.cornerRadius = gridLineViewThickness/2
                horizontalView.clipsToBounds = true
                self.collectionView.addSubview(horizontalView)
            }
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(self.totalSlotsCount + (self.totalSlotsCount % self.slotsPerRow))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlotSelectionCollectionViewCell.reuseIdentifier, for: indexPath) as! SlotSelectionCollectionViewCell
        
        let bookedSlots = Int(self.totalSlotsCount - self.availableSlots)
        
        if indexPath.item < bookedSlots{
            cell.imageView.image = UIImage(named: "Food Bowl Unselected")
            return cell
        } else if indexPath.item >= Int(self.totalSlotsCount) {
            cell.imageView.image = UIImage(named: "CloseWhite")
            return cell
        }
        
        if self.selectedCells[indexPath.item] != nil {
            cell.imageView.image = UIImage(named: "Food Bowl Selected")
        } else {
            cell.imageView.image = nil
        }
        return cell
    }
    
    
    func selectCollectionViewCell(atIndexPath: IndexPath){
        self.collectionView.selectItem(at: atIndexPath, animated: true, scrollPosition: .centeredVertically)
        self.collectionView(self.collectionView, didSelectItemAt: atIndexPath)
        
    }
    
    func deSelectCollectionViewCell(atIndexPath: IndexPath){
        self.collectionView.deselectItem(at: atIndexPath, animated: true)
        self.collectionView(self.collectionView, didDeselectItemAt: atIndexPath)
    }
    
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard indexPath.item >= Int(self.totalSlotsCount - self.availableSlots) &&
            indexPath.item < Int(self.totalSlotsCount) else { return }
        
        let cell = collectionView.cellForItem(at: indexPath) as! SlotSelectionCollectionViewCell
        cell.imageView.image = UIImage(named: "Food Bowl Selected")
        cell.isSelected = true
        self.selectedCells.updateValue(true, forKey: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard indexPath.item >= Int(self.totalSlotsCount - self.availableSlots)
            && indexPath.item < Int(self.totalSlotsCount) else { return }
        
        let cell = collectionView.cellForItem(at: indexPath) as! SlotSelectionCollectionViewCell
        cell.imageView.image = nil
        cell.isSelected = false
        
        self.selectedCells.removeValue(forKey: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width/4 - (self.interItemSpacingForCollectionView * 3)
        
        return CGSize(width: width , height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.interItemSpacingForCollectionView * 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.interItemSpacingForCollectionView
    }
    
}
