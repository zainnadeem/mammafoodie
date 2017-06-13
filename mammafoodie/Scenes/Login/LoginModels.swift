import UIKit

enum AuthProvider:String{
    case facebook, google, firebase
}



struct Login {
    struct Email {
        struct Request {
            var email: String
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
    
    struct Credentials{
        var email:String
        var password:String
        var authProvider: AuthProvider
    }
}
