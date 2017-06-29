import Foundation
import UIKit

enum MFMediaType : String {
    case liveVideo = "liveVideo"
    case vidup = "vidup"
    case picture = "picture"
    case unknown = "unknown"
}

enum MediaAccessUserType {
    case owner
    case viewer
}

class MFMedia {
    var id: String!
    
//    var comments: [String:Bool] = [:] //MFComment id
//    var contentID: String!
//    var cover_large: String?
//    var cover_small: String?
//    var createdAt: String! //Date timestamp
//    var endedAt: String! //Date timestamp
    var dishID: String! //MFDish id
//    var likes: [String:Bool] = [:] //MFUser id
    
    var comments: [Date:MFComment] = [:]
    var contentId: String!
    var cover_large: URL?
    var cover_small: URL?
    var dealTime : Double = -1
    var createdAt: Date!
    var endedAt: Date?
    weak var dish: MFDish!
    var likes: [Date:MFUser] = [:]
    
    var numberOfViewers: UInt = 0
    var type: MFMediaType = .unknown
    var user: MFUser!
//    var dealTime:Double = -1
    var chefID: String! //MFUser id
    
    
    var accessMode: MediaAccessUserType = .viewer
    
    init() {
        
    }
    
    init(id: String, cover_large: String, cover_small: String, createdAt: Date, dishID: String, chefID: String, type: MFMediaType, numberOfViewers: UInt) {
        self.id = id
        self.cover_large = URL.init(string: cover_large)
        self.cover_small = URL.init(string: cover_small)
        self.createdAt = createdAt
        self.dishID = dishID
        self.chefID = chefID
        self.type = type
        self.numberOfViewers = numberOfViewers
    }
    
    
    init(from mediaDictionary:[String:AnyObject]) {
        
        self.id = mediaDictionary["id"] as? String ?? ""
        self.comments = mediaDictionary["comments"] as? [String:Bool] ?? [:]
        self.contentId = mediaDictionary["contentID"] as? String ?? ""
        self.cover_large = mediaDictionary["cover_large"] as? String ?? ""
        self.cover_small = mediaDictionary["cover_small"] as? String ?? ""
        self.createdAt = mediaDictionary["createdAt"] as? String ?? ""
        self.endedAt = mediaDictionary["endedAt"] as? String ?? ""
        self.dishID = mediaDictionary["dishID"] as? String ?? ""
        self.likes = mediaDictionary["likes"] as? [String:Bool] ?? [:]
        self.numberOfViewers = mediaDictionary["numberOfViewers"] as? UInt ?? 0
        
        let type = mediaDictionary["type"] as? String ?? ""
        
        if let type = MFMediaType(rawValue: type) {
            self.type = type
        } else {
            self.type = .unknown
        }
        
        self.chefID = mediaDictionary["chefID"] as? String ?? ""
    }
    
    class func createNewMedia(with type : MFMediaType) -> MFMedia {
        let media = MFMedia.init()
        media.accessMode = .owner
        media.type = type
        media.id = FirebaseReference.media.generateAutoID()
        media.cover_small = media.generateCoverThumbImageURL()
        media.cover_large = media.generateCoverImageURL()
        return media
    }
    
    func setCoverImage(_ image : UIImage, completion : @escaping (Error) -> Void) {
        let path = "/media/cover/\(self.id).jpg"
        DatabaseGateway.sharedInstance.save(image: image, at: path) { (downloadURL, error) in
            if let er = error {
                completion(er)
            }
        }
    }
    
    func generateCoverImageURL() -> URL {
        let urlencodedID : String = self.id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let string = "https://firebasestorage.googleapis.com/v0/b/mammafoodie-baf82.appspot.com/o/media%2Fcover%2F\(urlencodedID).jpg?alt=media"
        return URL.init(string: string)!
    }
    
    func generateCoverThumbImageURL() -> URL {
        let urlencodedID : String = self.id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let string = "https://firebasestorage.googleapis.com/v0/b/mammafoodie-baf82.appspot.com/o/media%2Fcover%2F\(urlencodedID)).jpg?alt=media"
        return URL.init(string: string)!
    }
    
    func save() {
        DatabaseGateway.sharedInstance.saveMedia(self) { (error) in
            print(error?.localizedDescription ?? "No Error")
        }
    }

}

extension MFMedia: Hashable {
    var hashValue: Int {
        return self.id.hashValue
    }
}

extension MFMedia: Equatable {
    static func ==(lhs: MFMedia, rhs: MFMedia) -> Bool {
        return lhs.id == rhs.id
    }
}
