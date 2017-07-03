import UIKit

protocol DishDetailInteractorInput {
    func getDish(with id: String)
    func likeButtonTapped(userId: String, dishId: String, selected: Bool)
    func checkLikeStatus(userId: String, dishId: String)
    func checkFavoritesStatus(userId: String, dishId: String)
    func favoriteButtonTapped(userId: String, dishId: String, selected: Bool)
    
}

protocol DishDetailInteractorOutput {
     func presentDish(_ response: DishDetail.Dish.Response)
     func presentLikeStatus(_ response: DishDetail.Like.Response)
     func presentFavoriteStatus(_ response: DishDetail.Favorite.Response)
}

class DishDetailInteractor: DishDetailInteractorInput {
    
    var output: DishDetailInteractorOutput!
    var dishWorker: LoadDishWorker!
    
    var likeStatusWorker: CheckLikeStatusWorker!
    var likeTappedWorker: LikeTappedWorker!
    
    var favoriteStatusWorker: CheckFavoriteStatusWorker!
    var favoritesTappedWorker: FavoritesTappedWorker!
    
    func getDish(with id: String) {
        dishWorker = LoadDishWorker()
        dishWorker.getDish(with: id) { (dish) in
            
            let response = DishDetail.Dish.Response(dish: dish)
            self.output.presentDish(response)
            
        }
        
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
            
        }
    }
    

    
    func checkFavoritesStatus(userId: String, dishId: String) {
        favoriteStatusWorker = CheckFavoriteStatusWorker()
        favoriteStatusWorker.checkStatus(userId: userId, dishId: dishId) { (status) in
            
        }
        
    }
    
    
    
    
    
    // MARK: - Business logic
    
}
