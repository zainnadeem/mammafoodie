import UIKit

protocol OtherUsersProfilePresenterInput {
    func openDishPageWith(dishID:Int)
    func loadScreenWithData(_ profileData:[AnyHashable:Any])
}

protocol OtherUsersProfilePresenterOutput: class {
    func openDishPageWith(dishID:Int)
    func loadScreenWithData(_ profileData:[AnyHashable:Any])
}

class OtherUsersProfilePresenter: OtherUsersProfilePresenterInput {
    weak var output: OtherUsersProfilePresenterOutput!
    
    // MARK: - Presentation logic
    
    
    //MARK: - Input
    func openDishPageWith(dishID:Int){
        output.openDishPageWith(dishID: dishID)
    }
    
    func loadScreenWithData(_ profileData:[AnyHashable:Any]){
        
        output.loadScreenWithData(profileData)
        
    }
}
