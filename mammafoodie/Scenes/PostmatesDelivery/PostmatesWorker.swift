import UIKit
import Foundation

class PostmatesWorker {
    
    let BaseUrl = "https://api.postmates.com/v1"
    let customer_id = "cus_LJ3POZGLqcA4SF"
    let API_Key = "57beb930-8b5d-4f55-a896-69a047f93f6b"
    
    var encodedSandboxKey:String?
    
    //MARK:- Get Authorization Key value
    
    func authorizationValue()-> String {
        let userPasswordString = "\(API_Key):\("")"
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        let encodedSandboxKey = userPasswordData?.base64EncodedString()
        let authString = "Basic \(encodedSandboxKey!)"
        return authString
    }
    
    
    //MARK: - CheckforDelivery
    
    func checkforDeliveryAndQuote(pickupAddress:MFUserAddress,dropOffAddress:MFUserAddress,completion:@escaping (_ status:Bool,_ response:[String:Any]?, _ errorMessage:String?)->Void){
        
        if encodedSandboxKey == nil || encodedSandboxKey == ""{
            encodedSandboxKey = authorizationValue()
        }
        
        let parameters = "pickup_address=\(pickupAddress.address+","+pickupAddress.city+","+pickupAddress.state+","+pickupAddress.postalCode)&dropoff_address=\(dropOffAddress.address+","+dropOffAddress.city+","+dropOffAddress.state+","+dropOffAddress.postalCode)"
        
        let urlString = "\(BaseUrl)/customers/\(customer_id)/delivery_quotes"
        
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { print("Error encoding the url string"); return }
        
        let url = URL(string: encodedString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(encodedSandboxKey, forHTTPHeaderField: "Authorization")
        request.httpBody = parameters.data(using: String.Encoding.utf8)
        
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else { print("there was an error"); return }
            if response.statusCode != 200 {
                print("There was an error with your request")
                completion(false,nil, "There was an error with your request")
            }
            if let responseDict = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                if let responseDict = responseDict {
                    if responseDict["kind"] as! String == "error" {
                        completion(false,nil, responseDict["code"] as! String)
                    }else{
                        completion(true,responseDict,nil)
                    }
                }
                else { completion(false,nil, "Data Error") }
            }
            }.resume()
    }
    
    
    //Creates a delivery
    
    func createDelivery(pickupAddress:MFUserAddress,dropOffAddress:MFUserAddress,delivery_quoteid:String,itemDescription:String,pickUpPlaceName:String,pickUpPhone:String,pickUpNotes:String = "", dropOffPlaceName:String,dropOffPhone:String, dropOffNotes:String = "", completion:@escaping (_ response:[String:Any]?, _ errorMessage:String?)->Void){
        
        
        let parameters = "quote_id=\(delivery_quoteid)&manifest=\(itemDescription)&pickup_name=\(pickUpPlaceName)&pickup_address=\(pickupAddress.address+","+pickupAddress.city+","+pickupAddress.state+","+pickupAddress.postalCode)&pickup_phone_number=\(pickUpPhone)&pickup_notes=\(pickUpNotes)&dropoff_name=\(dropOffPlaceName)&dropoff_address=\(dropOffAddress.address+","+dropOffAddress.city+","+dropOffAddress.state+","+dropOffAddress.postalCode)&dropoff_phone_number=\(dropOffPhone)&dropoff_notes=\(dropOffNotes)"
        
//        print(parameters)
        
        
        let urlString = "\(BaseUrl)/customers/\(customer_id)/deliveries"
        
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { print("Error encoding the url string"); return }
        
        let url = URL(string: encodedString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(encodedSandboxKey, forHTTPHeaderField: "Authorization")
        request.httpBody = parameters.data(using: String.Encoding.utf8)
        
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else { print("there was an error"); return }
            print(response)
            if response.statusCode != 200 {
                print("There was an error with your request")
                completion(nil, error as? String)
            }
            if let responseDict = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                if let responseDict = responseDict {
                    completion(responseDict, nil)
                }
                else { completion(nil, "Data Error") }
            }
            }.resume()
    }
    
    //Get details of ongoing delivery
    func getDeliveryDetails(deliveryID:String, _ completion:@escaping (_ response:[String:Any]?, _ errorMessage:String?)->Void){
        
        let urlString = "\(BaseUrl)/customers/\(customer_id)/deliveries/\(deliveryID)"
        
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { print("Error encoding the url string"); return }
        
        let url = URL(string: encodedString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else { print("there was an error"); return }
            print(response)
            if response.statusCode != 200 {
                print("There was an error with your request")
                completion(nil, error as? String)
            }
            if let responseDict = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                if let responseDict = responseDict {
                    completion(responseDict, nil)
                }
                else { completion(nil, "Data Error") }
            }
            }.resume()
        
        
    }
    
}
