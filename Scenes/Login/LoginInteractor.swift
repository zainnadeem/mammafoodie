import UIKit

protocol LoginInteractorInput {
    func doSomething(request: Login.Something.Request)
}

protocol LoginInteractorOutput {
    func presentSomething(response: Login.Something.Response)
}

class LoginInteractor: LoginInteractorInput {
    var output: LoginInteractorOutput!
    var worker: LoginWorker!
    
    // MARK: - Business logic
    
    func doSomething(request: Login.Something.Request) {
        // NOTE: Create some Worker to do the work
        
        worker = LoginWorker()
        worker.doSomeWork()
        
        // NOTE: Pass the result to the Presenter
        
        let response = Login.Something.Response()
        output.presentSomething(response: response)
    }
}
