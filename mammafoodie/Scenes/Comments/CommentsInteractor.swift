import UIKit

protocol CommentsInteractorInput {
func EnterComments(comment:String)}

protocol CommentsInteractorOutput {
func EnterComments(comment:String)
}

class CommentsInteractor: CommentsInteractorInput {
    
    var output: CommentsInteractorOutput!
    lazy var commenstWorker = CommentsWorker()

    
    // MARK: - Business logic
    
    func EnterComments(comment:String) {
        commenstWorker.comments(comment: comment) { (success, errorMessage) in
                self.output.EnterComments(comment: comment)
            }
        }
    }
    

    


