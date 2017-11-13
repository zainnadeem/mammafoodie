import UIKit

struct DishDetail {
    
    struct Dish {
        struct Request {
        }
        struct Response {
            var dish: MFDish?
        }
    }
    
    struct Like {
        struct Request {
        }
        struct Response {
            var status: Bool = false
            
        }
    }
    
    struct Favourite {
        struct Request {
        }
        struct Response {
            var status: Bool = false
        }
    }
    
}
