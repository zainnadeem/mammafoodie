import UIKit

protocol LoginPresenterInput {
    func presentSomething(response: Login.Something.Response)
}

protocol LoginPresenterOutput: class {
    func displaySomething(viewModel: Login.Something.ViewModel)
}

class LoginPresenter: LoginPresenterInput {
    weak var output: LoginPresenterOutput!
    
    // MARK: - Presentation logic
    
    func presentSomething(response: Login.Something.Response) {
        // NOTE: Format the response from the Interactor and pass the result back to the View Controller
        
        let viewModel = Login.Something.ViewModel()
        output.displaySomething(viewModel: viewModel)
    }
}
