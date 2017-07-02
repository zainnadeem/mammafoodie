import UIKit

protocol DishDetailInteractorInput {
    func getDish(with id: String)
    
}

protocol DishDetailInteractorOutput {
     func presentDish(_ response: DishDetail.Response)
}

class DishDetailInteractor: DishDetailInteractorInput {
    
    var output: DishDetailInteractorOutput!
    var worker: LoadDishWorker!
    
    
    func getDish(with id: String) {
        worker = LoadDishWorker()
        
        
        worker.getDish(with: id) { (dish) in
            
            let response = DishDetail.Response(dish: dish)
            self.output.presentDish(response)
            
        }
        
        
        
//        worker.getDish(with: id) { (dish) in
//           let response = DishDetail.Response(dish: dish)
//           self.output.presentDish(response)
//        }
    }
    
    
    
    
    // MARK: - Business logic
    
}
