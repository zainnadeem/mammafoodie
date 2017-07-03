import Foundation

class CommentsWorker {
    var observer: DatabaseConnectionObserver?
    var comments: [MFComment] = []
    func load(for dish: MFDish, _ completion: @escaping (([MFComment])->Void)) {
        self.observer = DatabaseGateway.sharedInstance.getComments(on: dish, frequency: DatabaseRetrievalFrequency.realtime) { (comments) in
            self.comments.append(contentsOf: comments)
            completion(self.comments)
        }
    }
    
    func stopObserving() {
        self.observer?.stop()
    }
    
    func post(_ comment: MFComment, on dish: MFDish, _ completion: @escaping (()->Void)) {
        DatabaseGateway.sharedInstance.postComment(comment, on: dish) {
            completion()
        }
    }
}
