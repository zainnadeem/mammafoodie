import UIKit

protocol RequestDishPresenterInput {
    func RequestDishes(dishName:String,dishNo:String)

}

protocol RequestDishPresenterOutput: class {
    
}

class RequestDishPresenter: RequestDishPresenterInput {
    weak var output: RequestDishPresenterOutput!
    
    // MARK: - Presentation logic
    
    func RequestDishes(dishName:String,dishNo:String)
    {
        print(dishName)
        print(dishNo)
    }
    
}
