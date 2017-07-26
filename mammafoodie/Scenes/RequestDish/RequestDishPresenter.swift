import UIKit

protocol RequestDishPresenterInput {
     func dishRequestCompletion(success:Bool,message:String)

}

protocol RequestDishPresenterOutput: class {
    func dishRequestCompletion(success:Bool,message:String)
}

class RequestDishPresenter: RequestDishPresenterInput {
    weak var output: RequestDishPresenterOutput!
    
    // MARK: - Presentation logic
    
    func dishRequestCompletion(success:Bool,message:String){
        self.output.dishRequestCompletion(success: success, message: message)
    }
}
