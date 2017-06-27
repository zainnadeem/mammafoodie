import UIKit

protocol OtherUsersProfileInteractorInput {
    func setUpDishCollectionView(_ collectionView:UICollectionView, _ profileType:ProfileType)
    func loadDishCollectionViewForIndex(_ index:SelectedIndexForProfile)
}

protocol OtherUsersProfileInteractorOutput {
    func openDishPageWith(dishID:Int)
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
    
    func setUpDishCollectionView(_ collectionView:UICollectionView, _ profileType:ProfileType){
        dishCollectionViewAdapter = DishesCollectionViewAdapter()
        dishCollectionViewAdapter.delegate = self
        dishCollectionViewAdapter.profileType = profileType
        dishCollectionViewAdapter.collectionView = collectionView
    }
    
    func loadDishCollectionViewForIndex(_ index:SelectedIndexForProfile){
        
        worker.getDataSource(forIndex: index, forUserID: 0) { (dataSource) in
            
            print(dataSource)
            
            dishCollectionViewAdapter.selectedIndexForProfile = index
            dishCollectionViewAdapter.dataSource = dataSource
            
        }
        
    }
    
    
    
    //MARK: - DishesCollectionViewAdapterDelegate 
    
    func openDishPageWith(dishID:Int){
        
       output.openDishPageWith(dishID: dishID)
    
    }
    
}
