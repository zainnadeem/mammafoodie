import UIKit

protocol DishDetailInteractorInput {
    func getDish(with id: String)
    func likeButtonTapped(userId: String, dishId: String, selected: Bool)
    func checkLikeStatus(userId: String, dishId: String)
    func checkFavouritesStatus(userId: String, dishId: String)
    func favouriteButtonTapped(userId: String, dishId: String, selected: Bool)
    func stopObservingDish()
    func updateDishViewersCount(dishID:String, opened:Bool)
}

protocol DishDetailInteractorOutput {
     func presentDish(_ response: DishDetail.Dish.Response)
     func presentLikeStatus(_ response: DishDetail.Like.Response)
     func presentFavouriteStatus(_ response: DishDetail.Favourite.Response)
}

class DishDetailInteractor: DishDetailInteractorInput, HUDRenderer {
    
    var output: DishDetailInteractorOutput!
    var dishWorker: LoadDishWorker = LoadDishWorker()
    
    var likeStatusWorker: CheckLikeStatusWorker!
    var likeTappedWorker: LikeTappedWorker!
    
    var favouriteStatusWorker: CheckFavouriteStatusWorker!
    var favouritesTappedWorker: FavouritesTappedWorker!
    var orderCountWorker: OrderCountWorker!
    
    func getDish(with id: String) {
//        dishWorker = LoadDishWorker()
        
//        self.showActivityIndicator()
        
        dishWorker.getDish(with: id) { (dish) in
//            self.hideActivityIndicator()
            let response = DishDetail.Dish.Response(dish: dish)
            self.output.presentDish(response)
            
//            if ((dish?.totalSlots)! - (dish?.availableSlots)!) == 0 {
//                
//            }else{
//                self.orderCountWorker = OrderCountWorker()
//                self.orderCountWorker.getOrderCount(dishID: id, completion: { (count) in
//                    <#code#>
//                })
//            
//            }
        }
    }
    
    func stopObservingDish(){
        dishWorker.stopObserving()
    }
    
    func likeButtonTapped(userId: String, dishId: String, selected: Bool) {
        likeTappedWorker = LikeTappedWorker()
        likeTappedWorker.likeTapped(userId: userId, dishID: dishId, selected: selected) { 
            
        }
        
    }
    
    func favouriteButtonTapped(userId: String, dishId: String, selected: Bool) {
        favouritesTappedWorker = FavouritesTappedWorker()
        favouritesTappedWorker.favouritesTapped(userId: userId, dishID: dishId, selected: selected) { status in
            let response = DishDetail.Favourite.Response(status: status)
            self.output.presentFavouriteStatus(response)
        }

    }
    
    func checkLikeStatus(userId: String, dishId: String) {
        likeStatusWorker = CheckLikeStatusWorker()
        likeStatusWorker.checkStatus(userId: userId, dishId: dishId) { (status) in
            let response = DishDetail.Like.Response(status: status ?? false)
            self.output.presentLikeStatus(response)
        }
    }
    

    
    func checkFavouritesStatus(userId: String, dishId: String) {
        favouriteStatusWorker = CheckFavouriteStatusWorker()
        favouriteStatusWorker.checkStatus(userId: userId, dishId: dishId) { (status) in
            let response = DishDetail.Favourite.Response(status: status ?? false)
            self.output.presentFavouriteStatus(response)
        }
        
    }
    
    
    func updateDishViewersCount(dishID:String, opened: Bool) {
        dishWorker.updateViewersforDish(dishID: dishID, opened: opened)
    }
    
    
    
    // MARK: - Business logic
    
}
