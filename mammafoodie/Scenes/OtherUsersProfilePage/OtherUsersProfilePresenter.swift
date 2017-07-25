import UIKit

protocol OtherUsersProfilePresenterInput {
    func openDishPageWith(dishID:String)
    func openFollowers(followers:Bool, userList:[MFUser])
    func openFavouriteDishes()
}

protocol OtherUsersProfilePresenterOutput: class {
    func openDishPageWith(dishID:String)
    func openFollowers(followers:Bool, userList:[MFUser])
    func openFavouriteDishes()
    
}

class OtherUsersProfilePresenter: OtherUsersProfilePresenterInput {
    weak var output: OtherUsersProfilePresenterOutput!
    
    // MARK: - Presentation logic
    
    
    //MARK: - Input
    func openDishPageWith(dishID:String){
        output.openDishPageWith(dishID: dishID)
    }
    
    func openFollowers(followers: Bool, userList:[MFUser]) {
        output.openFollowers(followers: followers, userList:userList)
    }
    
    func openFavouriteDishes(){
        output.openFavouriteDishes()
    }
}
