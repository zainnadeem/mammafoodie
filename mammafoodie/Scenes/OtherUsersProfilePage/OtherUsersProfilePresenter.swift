import UIKit

protocol OtherUsersProfilePresenterInput {
    func openDishPageWith(dishID:Int)
    func openFollowers(followers:Bool, userList:[MFUser])
}

protocol OtherUsersProfilePresenterOutput: class {
    func openDishPageWith(dishID:Int)
    func openFollowers(followers:Bool, userList:[MFUser])
    
}

class OtherUsersProfilePresenter: OtherUsersProfilePresenterInput {
    weak var output: OtherUsersProfilePresenterOutput!
    
    // MARK: - Presentation logic
    
    
    //MARK: - Input
    func openDishPageWith(dishID:Int){
        output.openDishPageWith(dishID: dishID)
    }
    
    func openFollowers(followers: Bool, userList:[MFUser]) {
        output.openFollowers(followers: followers, userList:userList)
    }
}
