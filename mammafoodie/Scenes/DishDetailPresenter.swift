import UIKit

protocol DishDetailPresenterInput {
    func presentDish(_ response: DishDetail.Dish.Response)
    func presentLikeStatus(_ response: DishDetail.Like.Response)
    func presentFavoriteStatus(_ response: DishDetail.Favorite.Response)
    
}

protocol DishDetailPresenterOutput: class {
    func displayDish(_ response: DishDetail.Dish.Response)
    func displayLikeStatus(_ response: DishDetail.Like.Response)
    func displayFavoriteStatus(_ response: DishDetail.Favorite.Response)
    
}

class DishDetailPresenter: DishDetailPresenterInput {
    weak var output: DishDetailPresenterOutput!
    
    func presentDish(_ response: DishDetail.Dish.Response) {
        self.output.displayDish(response)
    }
    
    func presentLikeStatus(_ response: DishDetail.Like.Response) {
        self.output.displayLikeStatus(response)
    }
    
    func presentFavoriteStatus(_ response: DishDetail.Favorite.Response) {
    self.output.displayFavoriteStatus(response)
    }
    // MARK: - Presentation logic
    
}
