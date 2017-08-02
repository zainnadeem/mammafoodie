//
//  InfiniteCollectionViewAdapter.swift
//  mammafoodie
//
//  Created by Arjav Lad on 01/08/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class InfiniteCollectionViewAdapter: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var scrollTimer = Timer()
    private var height:CGFloat = 0.0
    
    private let totalCount : Int = 62
    
    private let infiniteCollectionView: UICollectionView
    
    init(with collectionView: UICollectionView) {
        self.infiniteCollectionView = collectionView
        self.infiniteCollectionView.register(UINib.init(nibName: "InfiniteClnCell", bundle: nil), forCellWithReuseIdentifier: "InfiniteClnCell")
        self.infiniteCollectionView.isUserInteractionEnabled = false
    }
    
    func startScrolling() {
        self.infiniteCollectionView.delegate = self
        self.infiniteCollectionView.dataSource = self
        self.infiniteCollectionView.reloadData()
        
        self.scrollTimer = Timer.scheduledTimer(timeInterval: 0.09, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    
    func imageAtIndexPath(_ indexPath : IndexPath) -> UIImage {
        var count = indexPath.item
        if count > (self.totalCount / 2) - 1 {
            count = self.totalCount - 1 - count
        }
        if count < 0 {
            count = 0
        }
        return UIImage.init(named: "WelcomeImage\(count)")!
    }
    
    func stopScrolling() {
        self.scrollTimer.invalidate()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.totalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfiniteClnCell", for: indexPath) as! InfiniteClnCell
        cell.imageView.image = self.imageAtIndexPath(indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width = collectionView.frame.size.width
        var height = collectionView.frame.size.height
        
        width = (width / 2) - 10
        if width < 100 {
            width = 100
        }
        height = width * 1.1
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    private func onTimer() {
        self.autoScroll()
    }
    
    @objc private func autoScroll() {
        let initailPoint = CGPoint(x: 0, y: self.height)
        
        if let lastCellFrame = self.infiniteCollectionView.layoutAttributesForItem(at: IndexPath.init(item: (self.infiniteCollectionView.numberOfItems(inSection: 0) - 1) , section: 0))?.frame {
            
            let maxY = lastCellFrame.origin.y + lastCellFrame.size.height
            if __CGPointEqualToPoint(initailPoint, self.infiniteCollectionView.contentOffset) {
                if self.height >= self.infiniteCollectionView.contentSize.height {
                    self.height = 0
                } else {
                    //                self.height = -self.infiniteCollectionView.frame.size.height
                    self.height += 2
//                    print("Height: \(self.height) --- Content Offset: \(self.infiniteCollectionView.contentOffset)")
                }
                let offsetPoint = CGPoint(x: 0, y: self.height)
                self.infiniteCollectionView.contentOffset = offsetPoint
            } else {
                self.height = self.infiniteCollectionView.contentOffset.y
//                print("Positive Height: \(self.height) --- Content Offset: \(self.infiniteCollectionView.contentOffset)")
            }
        } else {
            print("Some critical issue")
        }
    }
}
