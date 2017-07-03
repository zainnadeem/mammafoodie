import Foundation
import UIKit

class MFCuisine : Equatable {
    var id: String
    var name: String
    var isSelected: Bool = false
    var imageURL : URL?
    var selectedImage : UIImage?
    var unselectedImage : UIImage?
    
    init(with rawDict : [String : AnyObject]) {
        self.id = rawDict["id"] as! String
        self.name = rawDict["name"] as! String
        if let url = rawDict["selectedImageURL"] as? String {
            self.imageURL = URL.init(string: url)
        }
    }
    
    init(id: String!, name: String!, isSelected: Bool) {
        self.id = id
        self.name = name
        self.isSelected = isSelected
    }
    
    init(id: String!, name: String!, isSelected: Bool, selectedImage : UIImage?, unselectedImage : UIImage?) {
        self.id = id
        self.name = name
        self.isSelected = isSelected
        self.selectedImage = selectedImage
        self.unselectedImage = unselectedImage
    }
    
    static func ==(lhs: MFCuisine, rhs : MFCuisine) -> Bool {
        return lhs.id == rhs.id
    }
    
    func generateImageURL(for cuisine : Cuisine) -> String! {
        let urlencodedID : String! = (cuisine.id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!
        let string = "https://firebasestorage.googleapis.com/v0/b/mammafoodie-baf82.appspot.com/o/cuisines%2F\(urlencodedID!).png?alt=media"
        return string
    }
    
    func getStoragePath(for cuisine : Cuisine) -> String! {
        var urlencodedID : String! = ""
        if let idEncoded = cuisine.id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            urlencodedID = "\(idEncoded).png"
        }
        return "/cuisines/\(urlencodedID!)"
    }
    
    func createCuisines() {
        var array = [Cuisine]()
        let american = UIImage.init(named: "american.png")!
        array.append(Cuisine.init(name: "American", id: FirebaseReference.cuisines.generateAutoID(), selectedImage: american, unselectedImage: nil))
        
        let Italian = UIImage.init(named: "italian.png")!
        array.append(Cuisine.init(name: "Italian", id: FirebaseReference.cuisines.generateAutoID(), selectedImage: Italian, unselectedImage: nil))
        
        let Mexican = UIImage.init(named: "mexican.png")!
        array.append(Cuisine.init(name: "Mexican", id: FirebaseReference.cuisines.generateAutoID(), selectedImage: Mexican, unselectedImage: nil))
        
        let Indian = UIImage.init(named: "indian.png")!
        array.append(Cuisine.init(name: "Indian", id: FirebaseReference.cuisines.generateAutoID(), selectedImage: Indian, unselectedImage: nil))
        
        let Chinese = UIImage.init(named: "chinese.png")!
        array.append(Cuisine.init(name: "Chinese", id: FirebaseReference.cuisines.generateAutoID(), selectedImage: Chinese, unselectedImage: nil))
        
        let Japanese = UIImage.init(named: "japanese.png")!
        array.append(Cuisine.init(name: "Japanese", id: FirebaseReference.cuisines.generateAutoID(), selectedImage: Japanese, unselectedImage: nil))
        
        let Jamaican = UIImage.init(named: "jamaican.png")!
        array.append(Cuisine.init(name: "Jamaican", id: FirebaseReference.cuisines.generateAutoID(), selectedImage: Jamaican, unselectedImage: nil))
        for cuisine in array {
            let dict : [String : AnyObject] = [
                cuisine.id : [
                    "id" : cuisine.id,
                    "name" : cuisine.name,
                    "selectedImageURL" : self.generateImageURL(for: cuisine)
                    ] as AnyObject]
            if let image = cuisine.selectedImage {
                if let data = UIImagePNGRepresentation(image) {
                    DatabaseGateway.sharedInstance.save(data: data, at: self.getStoragePath(for: cuisine), completion: { (downloadURL, error) in
                        print(error?.localizedDescription ?? "")
                        print("Download URL \(String(describing: downloadURL))")
                        DispatchQueue.main.async {
                            FirebaseReference.cuisines.classReference.updateChildValues(dict, withCompletionBlock: { (error, ref) in
                                print(error?.localizedDescription ?? "No Error")
                            })
                        }
                    })
                }
            }
        }
    }
    
}
