enum MFActivityType:String {
    case liked
    case bought
    case tipped
    case followed
    case started
    case none
}

struct MFActivity {
    var id: String!
    var name: String!
    var type: MFActivityType = .none
    
    init(id: String, name: String, type: MFActivityType) {
        self.id = id
        self.name = name
        self.type = type
    }
    
    init(from dictionary:[String:AnyObject]){
        self.id = dictionary["id"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        
        let type = dictionary["type"]  as? String ?? ""
        
        if let type = MFActivityType(rawValue:type){
            self.type  = type
        } else {
            self.type = .none
        }
        
    }
    
}
