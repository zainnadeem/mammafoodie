import UIKit

protocol OtherUsersProfilePresenterInput {
    func openDishPageWith(dishID:String)
    func openFollowers(followers:Bool, userList:[MFUser])
    func openFavouriteDishes()
    func openUserprofile(id: String)
}

protocol OtherUsersProfilePresenterOutput: class {
    func openDishPageWith(dishID:String)
    func openFollowers(followers:Bool, userList:[MFUser])
    func openFavouriteDishes()
    func openUserprofile(id: String)
}

class OtherUsersProfilePresenter: OtherUsersProfilePresenterInput {
    weak var output: OtherUsersProfilePresenterOutput!
    
    // MARK: - Presentation logic
    
    
    //MARK: - Input
    func openDishPageWith(dishID:String){
        self.output.openDishPageWith(dishID: dishID)
    }
    
    func openFollowers(followers: Bool, userList:[MFUser]) {
        self.output.openFollowers(followers: followers, userList:userList)
    }
    
    func openFavouriteDishes(){
        self.output.openFavouriteDishes()
    }
    
    func openUserprofile(id: String) {
        self.output.openUserprofile(id: id)
    }
}
