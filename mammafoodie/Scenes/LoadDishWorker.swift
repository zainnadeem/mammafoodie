import UIKit

class LoadDishWorker {
    
    
    func getDish(with dishID:String, completion: @escaping (MFDish?)->Void) {
        DatabaseGateway.sharedInstance.getDishWith(dishID: dishID) { (dish) in
            
            //calculate how far the dish is

            //Should I be handling the error again?
            completion(dish)
            
        }

    }
}
    
    
    
////    func getDummyDish(with dishID:String, completion: @escaping (MFDish?)->Void){
////        var dishOne = MFDish(id: "", description: "Really awesome meal", name: "The Best Food")
////        dishOne.name = "chocolate"
////        dishOne.username = "johnny Ive"
////        dishOne.type = MFDishType.Veg
////        dishOne.numberOfComments = 123
////        dishOne.numberOfLikes = 20
////        dishOne.preparationTime = 12.00
////        
////        completion(dishOne)
////    }
//
//}
