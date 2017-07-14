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
            var status: Bool?
            
        }
    }
    
    struct Favorite {
        struct Request {
        }
        struct Response {
            var status: Bool?
            
        }
    }
    
}
