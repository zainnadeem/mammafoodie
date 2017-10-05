import UIKit

class LoadDishWorker:HUDRenderer {
    
    var observer : DatabaseConnectionObserver?
    
    func getDish(with dishID:String, completion: @escaping (MFDish?)->Void) {
        
        showActivityIndicator()
       observer =  DatabaseGateway.sharedInstance.getDishWith(dishID: dishID, frequency: .realtime) { (dish) in
//            self.hideActivityIndicator()
            completion(dish)
            
        }

    }
    
    func stopObserving(){
        self.observer?.stop()
    }
    
    func updateViewersforDish(dishID:String,opened:Bool){
        
        var params = "dishId=\(dishID)"
        
        if opened {
            params += "&opened=1"
        } else {
            params += "&closed=1"
        }
        
        let urlString = "https://us-central1-mammafoodie-baf82.cloudfunctions.net/updateViewersCount?\(params)"
        
        
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { print("Error encoding the url string"); return }
        
        let url = URL(string: encodedString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.httpBody = params.data(using: String.Encoding.utf8)
        
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { (data, response, error) in
            
//            completion()
            
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
