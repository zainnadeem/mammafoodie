import UIKit

protocol DishDetailPresenterInput {
    func presentDish(_ response: DishDetail.Dish.Response)
    func presentLikeStatus(_ response: DishDetail.Like.Response)
    func presentFavouriteStatus(_ response: DishDetail.Favourite.Response)
    
}

protocol DishDetailPresenterOutput: class {
    func displayDish(_ response: DishDetail.Dish.Response)
    func displayLikeStatus(_ response: DishDetail.Like.Response)
    func displayFavouriteStatus(_ response: DishDetail.Favourite.Response)
    
}

class DishDetailPresenter: DishDetailPresenterInput {
    weak var output: DishDetailPresenterOutput?
    
    func presentDish(_ response: DishDetail.Dish.Response) {
        self.output?.displayDish(response)
    }
    
    func presentLikeStatus(_ response: DishDetail.Like.Response) {
        self.output?.displayLikeStatus(response)
    }
    
    func presentFavouriteStatus(_ response: DishDetail.Favourite.Response) {
    self.output?.displayFavouriteStatus(response)
    }
    // MARK: - Presentation logic
    
}
