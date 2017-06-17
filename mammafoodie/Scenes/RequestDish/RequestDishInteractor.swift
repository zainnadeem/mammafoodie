import UIKit

protocol RequestDishInteractorInput {
    func RequestDishes(dishName:String,dishNo:String)

}

protocol RequestDishInteractorOutput {
    func RequestDishes(dishName:String,dishNo:String)

}

class RequestDishInteractor: RequestDishInteractorInput {
    
    var output: RequestDishInteractorOutput!
    var worker: RequestDishWorker!
    lazy var requestDishWorker = RequestDishWorker()

    // MARK: - Business logic
    func RequestDishes(dishName:String,dishNo:String)
    {
        requestDishWorker.dish(dishName: dishName,dishNo:dishNo) { (success, errorMessage) in
            self.output.RequestDishes(dishName: dishName,dishNo:dishNo)
        }
    }

}
