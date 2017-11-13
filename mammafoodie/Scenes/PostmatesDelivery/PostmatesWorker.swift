import UIKit
import Foundation

struct PostmatesDeliveryQuote {
    /*
     {
     "kind": "delivery_quote",
     "fee": 1175,
     "created": "2017-08-21T06:57:43Z",
     "expires": "2017-08-21T07:02:43Z",
     "currency": "usd",
     "duration": 35,
     "dropoff_eta": "2017-08-21T07:37:43Z",
     "id": "dqt_LOe3OpDk1TZ4Tk"
     }
     */
    var kind: String?
    var fees: Double = 0
    var created: Date?
    var expires: Date?
    var currency: String?
    var duration: Int = 0
    var dropoffETA: Date?
    var id: String?
}

class PostmatesWorker {
    
    let BaseUrl = "https://api.postmates.com/v1"
    let customer_id = "cus_LJ3POZGLqcA4SF"
    let API_Key = "57beb930-8b5d-4f55-a896-69a047f93f6b"
    
    var encodedSandboxKey:String?
    
    
    class func dateConversion(with date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateString = dateFormatter.string(from:date)
        return dateString
    }
    
    class func date(from string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: string)
    }
    
    //MARK:- Get Authorization Key value
    
    func authorizationValue()-> String {
        let userPasswordString = "\(API_Key):\("")"
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        let encodedSandboxKey = userPasswordData?.base64EncodedString()
        let authString = "Basic \(encodedSandboxKey!)"
        return authString
    }
    
    
    //MARK: - CheckforDelivery
    
    func checkforDeliveryAndQuote(pickupAddress:MFUserAddress,
                                  dropOffAddress:MFUserAddress,
                                  completion:@escaping (_ status:Bool,_ quote: PostmatesDeliveryQuote?, _ errorMessage:String?)->Void) {
        
        if encodedSandboxKey == nil || encodedSandboxKey == ""{
            encodedSandboxKey = authorizationValue()
        }
        
        let parameters = "pickup_address=\(pickupAddress.description)&dropoff_address=\(dropOffAddress.description)"
        
        //        let parameters = "pickup_address=\(pickupAddress.address+","+pickupAddress.city+","+pickupAddress.state+","+pickupAddress.postalCode)&dropoff_address=\(dropOffAddress.address+","+dropOffAddress.city+","+dropOffAddress.state+","+dropOffAddress.postalCode)"
        //
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
        session.dataTask(with: request) { (data, rawResponse, error) in
            guard let response = rawResponse as? HTTPURLResponse else {
                print("there was an error \(error?.localizedDescription ?? "N.A")")
                return
            }
            if response.statusCode != 200 {
                print("There was an error with your request")
                completion(false, nil, "There was an error with your request")
            }
            if let responseDict = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                if let responseDict = responseDict {
                    if responseDict["kind"] as! String == "error" {
                        completion(false, nil, responseDict["code"] as? String)
                    } else {
                        let kind: String = responseDict["kind"] as? String ?? ""
                        let fees: Double = (responseDict["fee"] as? Double ?? 0)/100
                        let created: Date? = PostmatesWorker.date(from: responseDict["created"] as? String ?? "")
                        let expires: Date? = PostmatesWorker.date(from: responseDict["expires"] as? String ?? "")
                        let currency: String = responseDict["currency"] as? String ?? ""
                        let duration: Int = responseDict["duration"] as? Int ?? 0
                        let dropoffETA: Date? = PostmatesWorker.date(from: responseDict["dropoff_eta"] as? String ?? "")
                        let id: String = responseDict["id"] as? String ?? ""
                        
                        let quote: PostmatesDeliveryQuote = PostmatesDeliveryQuote(kind: kind, fees: fees, created: created, expires: expires, currency: currency, duration: duration, dropoffETA: dropoffETA, id: id)
                        completion(true, quote, nil)
                    }
                }
                else {
                    completion(false, nil, "Data Error")
                }
            }
            
            }.resume()
    }
    
    
    //Creates a delivery
    
    func createDelivery(pickupAddress:MFUserAddress,
                        dropOffAddress:MFUserAddress,
                        delivery_quoteid:String,
                        itemDescription:String,
                        pickUpPlaceName:String,
                        pickUpPhone:String,
                        pickUpNotes:String = "",
                        dropOffPlaceName:String,
                        dropOffPhone:String,
                        dropOffNotes:String = "",
                        completion:@escaping (_ deliveryId:String?, _ errorMessage:String?)->Void){
        
        
        let parameters = "quote_id=\(delivery_quoteid)&manifest=\(itemDescription)&pickup_name=\(pickUpPlaceName)&pickup_address=\(pickupAddress.description)&pickup_phone_number=\(pickUpPhone)&pickup_notes=\(pickUpNotes)&dropoff_name=\(dropOffPlaceName)&dropoff_address=\(dropOffAddress.description)&dropoff_phone_number=\(dropOffPhone)&dropoff_notes=\(dropOffNotes)"
        
        //        let parameters = "quote_id=\(delivery_quoteid)&manifest=\(itemDescription)&pickup_name=\(pickUpPlaceName)&pickup_address=\(pickupAddress.address+","+pickupAddress.city+","+pickupAddress.state+","+pickupAddress.postalCode)&pickup_phone_number=\(pickUpPhone)&pickup_notes=\(pickUpNotes)&dropoff_name=\(dropOffPlaceName)&dropoff_address=\(dropOffAddress.address+","+dropOffAddress.city+","+dropOffAddress.state+","+dropOffAddress.postalCode)&dropoff_phone_number=\(dropOffPhone)&dropoff_notes=\(dropOffNotes)"
        //
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
            guard let response = response as? HTTPURLResponse else {
                print("there was an error")
                return
            }
            print(response)
            if response.statusCode != 200 {
                print("There was an error with your request")
                completion(nil, error as? String)
            }
            if let responseDict = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                if let responseDict = responseDict {
                    completion(responseDict["id"] as? String, nil)
                }
                else {
                    completion(nil, "Data Error")
                }
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
