import UIKit

protocol DishDetailInteractorInput {
    func getDish(with id: String)
    func likeButtonTapped(userId: String, dishId: String, selected: Bool)
    func checkLikeStatus(userId: String, dishId: String)
    func checkFavoritesStatus(userId: String, dishId: String)
    func favoriteButtonTapped(userId: String, dishId: String, selected: Bool)
    func stopObservingDish()
    
}

protocol DishDetailInteractorOutput {
     func presentDish(_ response: DishDetail.Dish.Response)
     func presentLikeStatus(_ response: DishDetail.Like.Response)
     func presentFavoriteStatus(_ response: DishDetail.Favorite.Response)
}

class DishDetailInteractor: DishDetailInteractorInput, HUDRenderer {
    
    var output: DishDetailInteractorOutput!
    var dishWorker: LoadDishWorker = LoadDishWorker()
    
    var likeStatusWorker: CheckLikeStatusWorker!
    var likeTappedWorker: LikeTappedWorker!
    
    var favoriteStatusWorker: CheckFavoriteStatusWorker!
    var favoritesTappedWorker: FavoritesTappedWorker!
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
    
    func favoriteButtonTapped(userId: String, dishId: String, selected: Bool) {
        favoritesTappedWorker = FavoritesTappedWorker()
        favoritesTappedWorker.favoritesTapped(userId: userId, dishID: dishId, selected: selected) {
            
        }

    }
    
    func checkLikeStatus(userId: String, dishId: String) {
        likeStatusWorker = CheckLikeStatusWorker()
        likeStatusWorker.checkStatus(userId: userId, dishId: dishId) { (status) in
            let response = DishDetail.Like.Response(status: status)
            self.output.presentLikeStatus(response)
        }
    }
    

    
    func checkFavoritesStatus(userId: String, dishId: String) {
        favoriteStatusWorker = CheckFavoriteStatusWorker()
        favoriteStatusWorker.checkStatus(userId: userId, dishId: dishId) { (status) in
            let response = DishDetail.Favorite.Response(status: status)
            self.output.presentFavoriteStatus(response)
        }
        
    }
    
    
    
    
    
    // MARK: - Business logic
    
}
