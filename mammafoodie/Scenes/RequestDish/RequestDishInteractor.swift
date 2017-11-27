import UIKit

protocol RequestDishInteractorInput {
    func RequestDishes(dish:MFDish,quantity:String)

}

protocol RequestDishInteractorOutput {
    func dishRequestCompletion(success:Bool,message:String)

}

class RequestDishInteractor: RequestDishInteractorInput {
    
    var output: RequestDishInteractorOutput!
    var worker: RequestDishWorker!
    lazy var requestDishWorker = RequestDishWorker()

    // MARK: - Business logic
    func RequestDishes(dish:MFDish,quantity:String) {
//        let quantity = Int(quantity)!
//        requestDishWorker.requestDish(dish: dish, quantity: quantity) { (success, errorMessage) in
//            if errorMessage != nil {
//                self.output.dishRequestCompletion(success: false, message: "Something went wrong! Please try again.")
//            } else {
//                self.output.dishRequestCompletion(success: true, message: "Successfully requested for the dish.")
//            }
//        }
    
    }

}
