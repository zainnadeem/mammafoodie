import UIKit

//struct Comments {
//    struct <#Feature name#> {
//        struct Request {
//        }
//        struct Response {
//        }
//        struct ViewModel {
//        }
//    }
//}

struct Comments {
    let textContent : String
    let timeStamp : Date
    let id : Double!
    
    init(with text: String, at time: Date) {
        self.textContent = text
        self.timeStamp = time
        self.id = time.timeIntervalSince1970
    }
}

