import UIKit

protocol OtherUsersProfileInteractorInput {
    func setUpDishCollectionView(_ collectionView:UICollectionView)
    func loadDishCollectionViewForIndex(_ index:Int)
}

protocol OtherUsersProfileInteractorOutput {
    func openDishPageWith(dishID:Int)
}

class OtherUsersProfileInteractor: OtherUsersProfileInteractorInput, DishesCollectionViewAdapterDelegate {
    
    var output: OtherUsersProfileInteractorOutput!
    var worker: OtherUsersProfileWorker! = OtherUsersProfileWorker()
    
    var dishCollectionViewAdapter:DishesCollectionViewAdapter!
    
    // MARK: - Business logic
    
    
    //MARK: - Input
    
    func setUpDishCollectionView(_ collectionView:UICollectionView){
        dishCollectionViewAdapter = DishesCollectionViewAdapter()
        dishCollectionViewAdapter.delegate = self
        dishCollectionViewAdapter.collectionView = collectionView
    }
    
    func loadDishCollectionViewForIndex(_ index:Int){
        
        worker.getDishes(boughtOrCooked: index, forUserID: 0) { dishes in
            dishCollectionViewAdapter.dataSource = dishes
        }
          
    }
    
    
    
    //MARK: - DishesCollectionViewAdapterDelegate 
    
    func openDishPageWith(dishID:Int){
        
       output.openDishPageWith(dishID: dishID)
    
    }
    
}
