import UIKit

protocol OwnProfilePageInteractorInput {
    func setUpDishCollectionView(_ collectionView:UICollectionView)
    func loadDishCollectionViewForIndex(_ index:Int)
}

protocol OwnProfilePageInteractorOutput {
    func openDishPageWith(dishID:Int)
}

class OwnProfilePageInteractor: OwnProfilePageInteractorInput,DishesCollectionViewAdapterDelegate {
    
    var output: OwnProfilePageInteractorOutput!
    var worker: OwnProfilePageWorker!
    
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
