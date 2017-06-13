import UIKit

protocol OwnProfilePagePresenterInput {
    func openDishPageWith(dishID:Int)
}

protocol OwnProfilePagePresenterOutput: class {
    func openDishPageWith(dishID:Int)
}

class OwnProfilePagePresenter: OwnProfilePagePresenterInput {
    weak var output: OwnProfilePagePresenterOutput!
    
    // MARK: - Presentation logic
    
    
    
    //MARK: - Input
    func openDishPageWith(dishID:Int){
        output.openDishPageWith(dishID: dishID)
    }
    
}
