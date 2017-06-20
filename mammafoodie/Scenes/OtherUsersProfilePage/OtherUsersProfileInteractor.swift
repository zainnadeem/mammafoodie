import UIKit

protocol OtherUsersProfileInteractorInput {
    func setUpDishCollectionView(_ collectionView:UICollectionView)
    func loadDishCollectionViewForIndex(_ index:SelectedIndexForProfile)
}

protocol OtherUsersProfileInteractorOutput {
    func openDishPageWith(dishID:Int)
    func loadScreenWithData(_ profileData:[AnyHashable:Any])
}

///Defined in OtherUsersProfileInteractor
enum SelectedIndexForProfile {
    case cooked
    case bought
    case activity
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
    
    func loadDishCollectionViewForIndex(_ index:SelectedIndexForProfile){
        
        worker.getDataSource(forIndex: index, forUserID: 0) { (dataSource) in
            
            print(dataSource)
            
            dishCollectionViewAdapter.selectedIndexForProfile = index
            dishCollectionViewAdapter.dataSource = dataSource
            
            output.loadScreenWithData(dataSource)
            
        }
        
    }
    
    
    
    //MARK: - DishesCollectionViewAdapterDelegate 
    
    func openDishPageWith(dishID:Int){
        
       output.openDishPageWith(dishID: dishID)
    
    }
    
}
