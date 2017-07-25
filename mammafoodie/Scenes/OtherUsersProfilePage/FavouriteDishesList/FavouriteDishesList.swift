//
//  FavouriteDishesList.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 29/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class FavouriteDishesList : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    
    var userID:String!
    var dataSource = [MFDish](){
        didSet{
            collectionView.reloadData()
        }
    }
    lazy var worker = OtherUsersProfileWorker()
    
    lazy var storyBoard = UIStoryboard(name: "DishDetail", bundle: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register Dish cell
        collectionView!.register(DishCollectionViewCell.self, forCellWithReuseIdentifier: DishCollectionViewCell.reuseIdentifier)
        collectionView!.register(UINib(nibName: "DishCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: DishCollectionViewCell.reuseIdentifier)
        
        worker.getSavedDishesForUser(userID: userID) { (dishes) in
            self.dataSource = dishes ?? []
        }
        
        
    }
    
    
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated:true, completion:nil)
        
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCollectionViewCell.reuseIdentifier, for: indexPath) as! DishCollectionViewCell
        
        let dish = dataSource[indexPath.item]
        
        cell.setUp(dish)
        
        
        return cell
    }
    

    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
       
          return  CGSize(width: collectionView.frame.size.width/3 - 2, height: 150)
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        delegate?.openDishPageWith(dishID: indexPath.item)
        
       let dishVC = storyBoard.instantiateViewController(withIdentifier: "DishDetailViewController") as! DishDetailViewController
        dishVC.dishID = dataSource[indexPath.item].id
       self.present(dishVC, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        
    }

    
}
