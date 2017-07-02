import UIKit

protocol DishDetailPresenterInput {
    func presentDish(_ response: DishDetail.Response)
    
}

protocol DishDetailPresenterOutput: class {
    func displayDish(_ response: DishDetail.Response)
    
}

class DishDetailPresenter: DishDetailPresenterInput {
    weak var output: DishDetailPresenterOutput!
    
    func presentDish(_ response: DishDetail.Response) {
        self.output.displayDish(response)
    }
    
    // MARK: - Presentation logic
    
}
