//
//  MFNotification.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 17/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation


struct MFNotification {
    var id: String!
    var participantUserID: String!
    var dishID:String?
    var activityID: String!
    var text: String!
    var attributedString: NSMutableAttributedString?
    var liked: [String:Bool] = [:] //MFUser id
    var comments: [String:Bool] = [:] //MFComments id
    
    init() {
        
    }
    
    init(id: String!, dishImageURLString: String? = nil, participantUserId: String, activity: MFActivity, text: String){
        self.id = id
//        self.actionUserID = actionUserId
        self.participantUserID = participantUserId
        self.text = text
//        self.activity = activity
    }
    
    init(from dictionary:[String:AnyObject]){
        
        self.id = dictionary["id"] as? String ?? ""
        self.participantUserID = dictionary["participantUserID"] as? String ?? ""
        self.dishID = dictionary["dishID"] as? String ?? nil
        self.activityID = dictionary["activityID"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        
        //Parse text and assign to attributed String
        //        self.attributedString =
        
        self.liked = dictionary["liked"] as? [String:Bool] ?? [:]
        self.comments = dictionary["comments"] as? [String:Bool] ?? [:]
        
        
    }
    
    
}

extension MFNotification: Hashable {
    var hashValue: Int {
        return self.id.hashValue
    }
}

extension MFNotification: Equatable {
    static func ==(lhs: MFNotification, rhs: MFNotification) -> Bool {
        return lhs.id == rhs.id
    }
}