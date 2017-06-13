import UIKit

class CommentsWorker {
    // MARK: - Business Logic
//    var commentsArray = [Comments]()

    
    func comments(comment:String, completion: @escaping (_ success:Bool, _ errorMessage:String?)->()){
        completion(true, "")
//        let comment = Comments.init(with: comment, at: Date())
//        if !self.commentsArray.contains(comment) {
//            self.commentsArray.append(comment)
//            print(comment)
//            print(self.commentsArray)
////            self.comments.text = ""
//        }
        //Filter Values
        //        self.commentsArray =  self.commentsArray.filter {
        //            $0.textContent == "hi"
        //        }
    }
}
extension Comments : Equatable, Comparable {
    static func ==(lhs: Comments, rhs: Comments) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func > (lhs: Comments, rhs: Comments) -> Bool {
        return lhs.timeStamp.timeIntervalSince1970 > rhs.timeStamp.timeIntervalSince1970
    }
    
    static func < (lhs: Comments, rhs: Comments) -> Bool {
        return lhs.timeStamp.timeIntervalSince1970 < rhs.timeStamp.timeIntervalSince1970
    }
    
    static func >= (lhs: Comments, rhs: Comments) -> Bool {
        return lhs.timeStamp.timeIntervalSince1970 >= rhs.timeStamp.timeIntervalSince1970
    }
    
    static func <= (lhs: Comments, rhs: Comments) -> Bool {
        return lhs.timeStamp.timeIntervalSince1970 <= rhs.timeStamp.timeIntervalSince1970
    }
    
}
