import Foundation
import Alamofire

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
//        DatabaseGateway.sharedInstance.postComment(comment, on: dish) {
//            completion()
//        }
        
        
       var urlString = "https://us-central1-mammafoodie-baf82.cloudfunctions.net/commentOnDish"
    
        let params = "dishId=\(dish.id)&userId=\(comment.user.id!)&userFullname=\(comment.user.name ?? "")&comment=\(comment.text!)"
        
        
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { print("Error encoding the url string"); return }
        
        let url = URL(string: encodedString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = params.data(using: String.Encoding.utf8)
        
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { (data, response, error) in
            
            completion()
            
            guard let response = response as? HTTPURLResponse else { print("there was an error"); return }
            if response.statusCode != 200 {
                print("There was an error with your request")
            }
            if let responseDict = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                if let responseDict = responseDict {
                   print(responseDict)
                }
                else { print("error") }
            }
            }.resume()
     
    }
}
