enum MFActivityType {
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
}
