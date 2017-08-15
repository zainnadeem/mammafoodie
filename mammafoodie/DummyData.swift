import Foundation


class DummyData {
    
    static let sharedInstance = DummyData()
    
    
    var user1: MFUser!
    var user2: MFUser!
    var user3: MFUser!
    var user4: MFUser!
    var user5: MFUser!
    var user6: MFUser!
    var user7: MFUser!
    var user8: MFUser!
    var user9: MFUser!
    
    var profileUser: MFUser!
    
    private init() {
        self.createUserData()
    }
    
    func createUserData() {
        
        user1 = MFUser(id: "u1", name: "Johnny Jones", picture: "JohnnyJones", profileDescription: "")
        user2 = MFUser(id: "u2", name: "Alexa Grimes", picture: "AlexaGrimes", profileDescription: "")
        user3 = MFUser(id: "u3", name: "Bobby Love", picture: "BobbyLove", profileDescription: "")
        user4 = MFUser(id: "u4", name: "Hadid Shukar", picture: "HadidShukar", profileDescription: "")
        user5 = MFUser(id: "u5", name: "Sheena Johnson", picture: "SheenaJohnson", profileDescription: "")
        user6 = MFUser(id: "u6", name: "Jackie Lobo", picture: "JackieLoboLive", profileDescription: "")
        user7 = MFUser(id: "u7", name: "Lincoln Jean", picture: "LincolnJean", profileDescription: "")
        user8 = MFUser(id: "u8", name: "Kate Ferguson", picture: "KateFerguson", profileDescription: "")
        user9 = MFUser(id: "u9", name: "Laura Park", picture: "LauraPark", profileDescription: "")
        
        
        profileUser = MFUser(id: "u1", name: "Johnny Jones", picture: "JohnnyJones", profileDescription: "26/M/NYC My dishes are always made with ❤️ and Garlic")
    }
    
    
    
    func populateNewsfeed(completion: ([MFNewsFeed]) -> Void){
//        let newsText1  = combineAttributedStrings(left: self.addUnderline(text: self.user1.name + " liked"), right: self.bold(text: user2.name + "'s " + " dish"))
//        let newsText2  = combineAttributedStrings(left: self.addUnderline(text: self.user3.name + " started following"), right: self.bold(text: user4.name))
//        let newsText3  = combineAttributedStrings(left: self.addUnderline(text: self.user5.name + " is"), right: self.bold(text: "Live "))
//        let newsText4  = combineAttributedStrings(left: self.addUnderline(text: self.user7.name + " tipped"), right: self.bold(text: self.user8.name))
//        let newsText5  = combineAttributedStrings(left: self.addUnderline(text: self.user5.name + " bought"), right: self.bold(text: user6.name + "'s " + " dish"))
//        
//        let newsfeed1 = MFNewsFeed(id: "1", actionUserId: user1.id, participantUserId: user2.id, activity: .liked, text: newsText1)
//        let newsfeed2 = MFNewsFeed(id: "2", actionUserId: user3.id, participantUserId: user4.id, activity: .followed, text: newsText2)
//        let newsfeed3 = MFNewsFeed(id: "3", actionUserId: user5.id, participantUserId: user5.id, activity: .started, text: newsText3)
//        let newsfeed4 = MFNewsFeed(id: "4", actionUserId: user7.id, participantUserId: user8.id, activity: .tipped, text: newsText4)
//        let newsfeed5 = MFNewsFeed(id: "5", actionUserId: user9.id, participantUserId: user1.id, activity: .bought, text: newsText5)
        
        let newsfeedObjects = [MFNewsFeed]()
//        [newsfeed1, newsfeed2, newsfeed3, newsfeed4, newsfeed5]
        
//        for object in newsfeedObjects {
//            print(object.attributedString ?? "")
//        }
        
        completion(newsfeedObjects)
    }
    
    
    //Mark: - Attributed String Methods
    func combineAttributedStrings(left: NSMutableAttributedString, right: NSMutableAttributedString) -> NSMutableAttributedString
    {
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(NSAttributedString(string: " "))
        result.append(right)
        return result
    }
    
    func addUnderline(text: String)-> NSMutableAttributedString {
        
        let attributed = NSMutableAttributedString(string: text, attributes: [NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue])
        return attributed
        
    }
    
    func addNormal(text: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text)
    }
    
    func bold(text : String) -> NSMutableAttributedString {
        
        let attributed = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)])
        return attributed
    }
    
    func addColor(text: String) -> NSMutableAttributedString {
        let attributed = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)])
        return attributed
    }
    
    
    
    func populateMenu(_ completion: ([MFDish]) -> Void){
        
        let cuisine: MFCuisine = MFCuisine()
        cuisine.id = "1"
        cuisine.name = "Indian"
        
        let dish1 = MFDish(id: "d1", user: user1, description: "", name: "The Beef Tower🍖", cuisine: cuisine)
        dish1.mediaURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/mammafoodie-baf82.appspot.com/o/dishes%2FBeefTower.jpg?alt=media")!
        //        let media1 = MFMedia(id: "m1", cover_large: "BeefTower", cover_small: "BeefTower", createdAt: Date.init(), dish: dish1, user: user1, type: .picture, numberOfViewers: 236)
        
        let dish2 = MFDish(id: "d2", user: user2, description: "", name: "Coleslaw Burger!🍔🥒", cuisine: cuisine)
        dish2.mediaURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/mammafoodie-baf82.appspot.com/o/dishes%2FcoleslawBurger.jpg?alt=media")!
        //        let media2 = MFMedia(id: "m2", cover_large: "coleslawBurger", cover_small: "coleslawBurger", createdAt: Date.init(), dish: dish2, user: user2, type: .picture, numberOfViewers: 144)
        
        
        let dish3 = MFDish(id: "d3", user: user3, description: "", name: "The Best Crab Cakes", cuisine: cuisine)
        dish3.mediaURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/mammafoodie-baf82.appspot.com/o/dishes%2FCrabcakes.jpg?alt=media")!
        //        let media3 = MFMedia(id: "m3", cover_large: "Crabcakes", cover_small: "Crabcakes", createdAt: Date.init(), dish: dish3, user: user3, type: .picture, numberOfViewers: 966)
        
        
        let dish4 = MFDish(id: "d4", user: user4, description: "", name: "Goatcheese Canape🐐🧀!!", cuisine: cuisine)
        dish4.mediaURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/mammafoodie-baf82.appspot.com/o/dishes%2FGoatCheeseCanape.jpg?alt=media")!
        //        let media4 = MFMedia(id: "m4", cover_large: "GoatCheeseCanape", cover_small: "HadidShakurLive", createdAt: Date.init(), dish: dish4, user: user4, type: .picture, numberOfViewers: 533)
        
        
        let dish5 = MFDish(id: "d5", user: user5, description: "", name: "Go To Guac & Chips🥑", cuisine: cuisine)
        dish5.mediaURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/mammafoodie-baf82.appspot.com/o/dishes%2Fguac&chips.jpg?alt=media")!
        //        let media5 = MFMedia(id: "m5", cover_large: "guac&chips", cover_small: "guac&chips", createdAt: Date.init(), dish: dish5, user: user5, type: .picture, numberOfViewers: 128)
        
        
        let dish6 = MFDish(id: "d6", user: user6, description: "", name: "Pineapple Cakes", cuisine: cuisine)
        dish6.mediaURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/mammafoodie-baf82.appspot.com/o/dishes%2FPineappleCakes.jpg?alt=media")!
        //        let media6 = MFMedia(id: "m6", cover_large: "PineappleCakes", cover_small: "PineappleCakes", createdAt: Date.init(), dish: dish6, user: user6, type: .picture, numberOfViewers: 95)
        
        let dish7 = MFDish(id: "d7", user: user7, description: "", name: "JUMBO Jambalaya🌶", cuisine: cuisine)
        dish7.mediaURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/mammafoodie-baf82.appspot.com/o/dishes%2Fjambalaya.jpg?alt=media")!
        //        let media7 = MFMedia(id: "m7", cover_large: "jambalaya", cover_small: "jambalaya", createdAt: Date.init(), dish: dish7, user: user7, type: .picture, numberOfViewers: 95)
        
        
        let dish8 = MFDish(id: "d8", user: user8, description: "", name: "Tangy Tacos!!🌮", cuisine: cuisine)
        dish8.mediaURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/mammafoodie-baf82.appspot.com/o/dishes%2Ftacos.jpg?alt=media")!
        //        let media8 = MFMedia(id: "m8", cover_large: "tacos", cover_small: "tacos", createdAt: Date.init(), dish: dish8, user: user8, type: .picture, numberOfViewers: 433)
        
        let dish9 = MFDish(id: "d9", user: user9, description: "", name: "Salmon🐠", cuisine: cuisine)
        dish9.mediaURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/mammafoodie-baf82.appspot.com/o/dishes%2FSalmon.jpg?alt=media")!
        //        let media9 = MFMedia(id: "m9", cover_large: "Salmon", cover_small: "Salmon", createdAt: Date.init(), dish: dish9, user: user9, type: .picture, numberOfViewers: 222)
        
        let menu: [MFDish] = [dish1, dish2, dish3, dish4, dish5, dish6, dish7, dish8, dish9]
        completion(menu.shuffled())
    }
    
    
    //    func getUserForProfilePage()-> MFUser{
    //
    //
    //        let dish1 = MFDish(id: "d1", user: profileUser, description: "", name: "The Beef Tower🍖")
    //        let media1 = MFMedia(id: "m1", cover_large: "BeefTower", cover_small: "BeefTower", createdAt: Date.init(), dish: dish1, user: profileUser, type: .vidup, numberOfViewers: 236)
    //
    //        let dish2 = MFDish(id: "d2", user: profileUser, description: "", name: "Coleslaw Burger!🍔🥒")
    //        let media2 = MFMedia(id: "m2", cover_large: "coleslawBurger", cover_small: "coleslawBurger", createdAt: Date.init(), dish: dish2, user: profileUser, type: .vidup, numberOfViewers: 144)
    //
    //        let dish3 = MFDish(id: "d3", user: profileUser, description: "", name: "The Best Crab Cakes")
    //        let media3 = MFMedia(id: "m3", cover_large: "Crabcakes", cover_small: "Crabcakes", createdAt: Date.init(), dish: dish3, user: profileUser, type: .vidup, numberOfViewers: 966)
    //
    //        let dish4 = MFDish(id: "d4", user: profileUser, description: "", name: "Goatcheese Canape🐐🧀!!")
    //        let media4 = MFMedia(id: "m4", cover_large: "GoatCheeseCanape", cover_small: "HadidShakurLive", createdAt: Date.init(), dish: dish4, user: profileUser, type: .vidup, numberOfViewers: 533)
    //
    //        let dish5 = MFDish(id: "d5", user: profileUser, description: "", name: "Go To Guac & Chips🥑")
    //        let media5 = MFMedia(id: "m5", cover_large: "guac&chips", cover_small: "guac&chips", createdAt: Date.init(), dish: dish5, user: profileUser, type: .vidup, numberOfViewers: 128)
    //
    //        let dish6 = MFDish(id: "d6", user: profileUser, description: "", name: "Pineapple Cakes")
    //        let media6 = MFMedia(id: "m6", cover_large: "PineappleCakes", cover_small: "PineappleCakes", createdAt: Date.init(), dish: dish6, user: profileUser, type: .vidup, numberOfViewers: 95)
    //
    //        let dish7 = MFDish(id: "d7", user: profileUser, description: "", name: "JUMBO Jambalaya🌶")
    //        let media7 = MFMedia(id: "m7", cover_large: "jambalaya", cover_small: "jambalaya", createdAt: Date.init(), dish: dish7, user: profileUser, type: .vidup, numberOfViewers: 95)
    //
    //        let dish8 = MFDish(id: "d8", user: profileUser, description: "", name: "Tangy Tacos!!🌮")
    //        let media8 = MFMedia(id: "m8", cover_large: "tacos", cover_small: "tacos", createdAt: Date.init(), dish: dish8, user: profileUser, type: .vidup, numberOfViewers: 433)
    //
    //        let dish9 = MFDish(id: "d9", user: profileUser, description: "", name: "Salmon🐠")
    //        let media9 = MFMedia(id: "m9", cover_large: "Salmon", cover_small: "Salmon", createdAt: Date.init(), dish: dish9, user: profileUser, type: .vidup, numberOfViewers: 222)
    //
    //        profileUser.cookedDishes = [ media1 : Date.init(),
    //                                     media2 : Date.init(),
    //                                     media3 : Date.init(),
    //                                     media4 : Date.init(),
    //                                     media5 : Date.init(),
    //                                     media6 : Date.init(),
    //                                     media7 : Date.init(),
    //                                     media8 : Date.init(),
    //                                     media9 : Date.init()
    //        ]
    //
    //        profileUser.boughtDishes =  [ media9 : Date.init(),
    //                                      media8 : Date.init(),
    //                                      media7 : Date.init(),
    //                                      media6 : Date.init(),
    //                                      media5 : Date.init(),
    //                                      media4 : Date.init(),
    //                                      media3 : Date.init(),
    //                                      media2 : Date.init(),
    //                                      media1 : Date.init()
    //        ]
    //
    //
    //
    //        let newsText1  = combineAttributedStrings(left: self.addUnderline(text: self.profileUser.name + " liked"), right: self.bold(text: user2.name + "'s " + "dish"))
    //        let newsText2  = combineAttributedStrings(left: self.addUnderline(text: self.profileUser.name + " started following"), right: self.bold(text: user4.name))
    //        let newsText3  = combineAttributedStrings(left: self.addUnderline(text: self.profileUser.name + " is"), right: self.bold(text: "Live "))
    //        let newsText4  = combineAttributedStrings(left: self.addUnderline(text: self.profileUser.name + " tipped"), right: self.bold(text: self.user8.name))
    //        let newsText5  = combineAttributedStrings(left: self.addUnderline(text: self.profileUser.name + " bought"), right: self.bold(text: user6.name + "'s " + " dish"))
    //
    //        let newsfeed1 = MFNewsFeed(id: "n1", actionUserId: profileUser, participantUserId: user2, activity: MFActivity(id:"", name:"",type:.liked), text: newsText1)
    //        let newsfeed2 = MFNewsFeed(id: "n2", actionUserId: profileUser, participantUserId: user4, activity: MFActivity(id:"", name:"",type:.started), text: newsText2)
    //        let newsfeed3 = MFNewsFeed(id: "n3", actionUserId: profileUser, participantUserId: profileUser, activity: MFActivity(id:"", name:"",type:.none), text: newsText3)
    //        let newsfeed4 = MFNewsFeed(id: "n4", actionUserId: profileUser, participantUserId: user8, activity: MFActivity(id:"", name:"",type:.tipped), text: newsText4)
    //        let newsfeed5 = MFNewsFeed(id: "n5", actionUserId: profileUser, participantUserId: user1, activity: MFActivity(id:"", name:"",type:.bought), text: newsText5)
    //
    //        profileUser.userActivity =  [ newsfeed1 : Date.init(),
    //                                      newsfeed2 : Date.init(),
    //                                      newsfeed3 : Date.init(),
    //                                      newsfeed4 : Date.init(),
    //                                      newsfeed5 : Date.init(),
    //        ]
    //
    //        for activity in profileUser.userActivity {
    //            print(activity.key.attributedString)
    //        }
    //
    //
    //        return profileUser
    //    }
    
}


extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
