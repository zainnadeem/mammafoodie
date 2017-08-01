//
//  InfiniteCollectionViewAdapter.swift
//  mammafoodie
//
//  Created by Arjav Lad on 01/08/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class InfiniteCollectionViewAdapter: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var scrollTimer = Timer()
    var height:CGFloat=0.0
    
    
    let infiniteCollectionView: UICollectionView
    
    init(with collectionView: UICollectionView) {
        self.infiniteCollectionView = collectionView
        self.infiniteCollectionView.register(UINib.init(nibName: "InfiniteClnCell", bundle: nil), forCellWithReuseIdentifier: "InfiniteClnCell")
    }
    
    func startScrolling() {
        self.infiniteCollectionView.delegate = self
        self.infiniteCollectionView.dataSource = self
        
        self.infiniteCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfiniteClnCell", for: indexPath)
        
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        configAutoscrollTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        deconfigAutoscrollTimer()
    }
    
    func configAutoscrollTimer() {
        
        timr=Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(dashboard_ViewController.autoScrollView), userInfo: nil, repeats: true)
    }
    
    func deconfigAutoscrollTimer() {
        timr.invalidate()
        
    }
    
    func onTimer() {
        autoScrollView()
    }
    
    func autoScrollView() {
        
        let initailPoint = CGPoint(x: w,y :0)
        
        if __CGPointEqualToPoint(initailPoint, ticker.contentOffset)
        {
            if w<collection_view.contentSize.width
            {
                w += 0.5
            }
            else
            {
                w = -self.view.frame.size.width
            }
            
            let offsetPoint = CGPoint(x: w,y :0)
            
            collection_view.contentOffset=offsetPoint
            
        }
        else
        {
            w=collection_view.contentOffset.x
        }
    }
}
