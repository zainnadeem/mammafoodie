import UIKit

protocol GoCookPresenterInput {
    
}

protocol GoCookPresenterOutput: class {
    
}

class GoCookPresenter: GoCookPresenterInput {
    weak var output: GoCookPresenterOutput!
    
    // MARK: - Presentation logic
    
}
