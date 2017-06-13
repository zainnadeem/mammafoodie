import UIKit

protocol CommentsPresenterInput {
    func EnterComments(comment:String)
}

protocol CommentsPresenterOutput: class {
    func EnterComments(comment:String)

}

class CommentsPresenter: CommentsPresenterInput {
    weak var output: CommentsPresenterOutput!
    
    // MARK: - Presentation logic
    
    func EnterComments(comment:String)
    {
        self.output.EnterComments(comment: comment)
    }
    
}

