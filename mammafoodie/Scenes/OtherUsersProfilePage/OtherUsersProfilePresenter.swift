import UIKit

protocol OtherUsersProfilePresenterInput {
    func openDishPageWith(dishID:Int)
}

protocol OtherUsersProfilePresenterOutput: class {
    func openDishPageWith(dishID:Int)
    
}

class OtherUsersProfilePresenter: OtherUsersProfilePresenterInput {
    weak var output: OtherUsersProfilePresenterOutput!
    
    // MARK: - Presentation logic
    
    
    //MARK: - Input
    func openDishPageWith(dishID:Int){
        output.openDishPageWith(dishID: dishID)
    }
}
