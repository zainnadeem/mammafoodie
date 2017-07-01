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
    var comments: [Date:MFComment] = [:]
    var contentId: String!
    var cover_large: URL?
    var cover_small: URL?
    var createdAt: Date!
    var endedAt: Date?
    weak var dish: MFDish!
    var likes: [Date:MFUser] = [:]
    var numberOfViewers: UInt = 0
    var type: MFMediaType = .unknown
    var user: MFUser!
    var mediaURL : URL!
    
    var accessMode: MediaAccessUserType = .viewer
    
    init() {
        
    }
    
    init(id: String, cover_large: String, cover_small: String, createdAt: Date, dish: MFDish, user: MFUser, type: MFMediaType, numberOfViewers: UInt) {
        self.id = id
        self.cover_large = URL.init(string: cover_large)
        self.cover_small = URL.init(string: cover_small)
        self.createdAt = createdAt
        self.dish = dish
        self.user = user
        self.type = type
        self.numberOfViewers = numberOfViewers
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
        let urlencodedID : String! = (self.id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!
        let string = "https://firebasestorage.googleapis.com/v0/b/mammafoodie-baf82.appspot.com/o/media%2Fcover%2F\(urlencodedID!).jpg?alt=media"
        return URL.init(string: string)!
    }
    
    func generateCoverThumbImageURL() -> URL {
        let urlencodedID : String! = (self.id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!
        let string = "https://firebasestorage.googleapis.com/v0/b/mammafoodie-baf82.appspot.com/o/media%2Fcover%2F\(urlencodedID!)).jpg?alt=media"
        return URL.init(string: string)!
    }
    
    func save(_ completion : @escaping (Error?) -> Void ) {
        DatabaseGateway.sharedInstance.saveMedia(self) { (error) in
            completion(error)
        }
    }
    
    func getStoragePath() -> String {
        var urlencodedID : String! = ""
        if self.type == .picture {
            urlencodedID = "\((self.id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!).jpg"
        } else if self.type == .vidup {
            urlencodedID = "\((self.id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!).mp4"
        }
        return "/media/\(urlencodedID)"
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
