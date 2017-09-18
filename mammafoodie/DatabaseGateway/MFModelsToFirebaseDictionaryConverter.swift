//
//  MFModelsToFirebaseDictionaryConverter.swift
//  Red5ProDemo
//
//  Created by Akshit Zaveri on 14/06/17.
//  Copyright © 2017 Akshit Zaveri. All rights reserved.
//

import Foundation

class MFModelsToFirebaseDictionaryConverter {
    
    typealias FirebaseDictionary = [String:AnyObject]
    
    class func dictionary(from order: MFOrder) -> FirebaseDictionary {
        var raw: FirebaseDictionary = [
            "id": order.id as AnyObject,
            "dish": [
                "id": order.dish.id,
                "name": order.dish.name,
                "createdBy": order.dish.user.name
                ] as AnyObject,
            "quantity": order.quantity as AnyObject,
            "boughtBy" : [
                "id": order.boughtBy.id,
                "name": order.boughtBy.name
                ] as AnyObject,
            "status": order.status.rawValue as AnyObject,
            "createdAt": order.createdAt.timeIntervalSinceReferenceDate as AnyObject,
            "shippingMethod": order.shippingMethod.rawValue as AnyObject,
            "shippingAddress": [
                "address": order.shippingAddress.description,
                "location": order.shippingAddress.location
                ] as AnyObject,
            "paymentMethod": order.paymentMethod.rawValue as AnyObject,
            "paymentDetails": [
                "id": order.paymentDetails.id,
                "totalCharge": order.paymentDetails.totalCharge,
                ] as AnyObject
        ]
        if let deliveryId = order.deliveryId {
            raw["deliveryId"] = deliveryId as AnyObject
        }
        if let delivery = order.deliveryOption {
            raw["deliveryOption"] = delivery.rawValue as AnyObject
        }
        return raw
    }
    
    class func dictionary(from newsFeed: MFNewsFeed) -> FirebaseDictionary {
        var raw: FirebaseDictionary = [
            "id" : newsFeed.id as AnyObject,
            "actionUserID": newsFeed.actionUser.id as AnyObject,
            "actionUserName": newsFeed.actionUser.name as AnyObject,
            "participantUserID" : newsFeed.participantUser.id as AnyObject,
            "participantUserName": newsFeed.participantUser.name as AnyObject,
            "redirectID": newsFeed.redirectID as AnyObject,
            "redirectPath": newsFeed.activity.path.rawValue as AnyObject,
            "activity": newsFeed.activity.rawValue as AnyObject,
            "text": "",
            "mediaURL": newsFeed.mediaURL?.absoluteString as AnyObject ?? "" as AnyObject,
            "likes": newsFeed.likes,
            "timestamp": newsFeed.createdAt.timeIntervalSinceReferenceDate
            ] as [String : AnyObject]
        var comments = [[String: AnyObject]]()
        for comment in newsFeed.comments {
            comments.append([comment.id: MFModelsToFirebaseDictionaryConverter.dictionary(from: comment)] as FirebaseDictionary)
        }
        if comments.count > 0 {
            raw["comments"] = comments as AnyObject
        }
        return raw
    }
    
    class func dictionary(from comment: MFComment) -> FirebaseDictionary {
        let raw: FirebaseDictionary = [
            "id": comment.id as AnyObject,
            "text": comment.text as AnyObject,
            "createdAt": comment.createdAt.timeIntervalSinceReferenceDate as AnyObject,
            "refrenceID": comment.refrenceID as AnyObject,
            "user": [
                "id": comment.user.id as AnyObject,
                "name": comment.user.name as AnyObject ] as AnyObject
        ]
        
        return raw
    }
    
    class func dictionary(from dish: MFDish) -> FirebaseDictionary {
        let createDate: Date = dish.createTimestamp ?? Date()
        var rawDish: FirebaseDictionary = [
            "id" : dish.id as AnyObject,
            "createTimestamp" : createDate.timeIntervalSinceReferenceDate as AnyObject,
            "user" : [
                "id" : dish.user.id as AnyObject,
                "name" : dish.user.name as AnyObject
                ] as AnyObject,
            "mediaType": dish.mediaType.rawValue as AnyObject,
            "name" : dish.name as AnyObject,
            "likesCount" : dish.likesCount as AnyObject,
            "commentsCount" : dish.commentsCount as AnyObject,
            "description" : dish.description as AnyObject,
            "mediaURL" : (dish.mediaURL?.absoluteString ?? "") as AnyObject,
            "coverPicURL": (dish.coverPicURL?.absoluteString ?? "") as AnyObject,
            "totalSlots" : dish.totalSlots as AnyObject,
            "pricePerSlot" : dish.pricePerSlot as AnyObject,
            "availableSlots" : dish.totalSlots as AnyObject,
            "dishType" : dish.dishType.rawValue as AnyObject,
            "preparationTime" : dish.preparationTime as AnyObject,
            "cuisine" : [
                "id" : dish.cuisine.id as AnyObject,
                "name" : dish.cuisine.name as AnyObject
                ] as AnyObject
        ]
        
        if let timeStamp = dish.endTimestamp {
            rawDish["endTimestamp"] = timeStamp.timeIntervalSinceReferenceDate as AnyObject
        }
        if let location = dish.location {
            rawDish["location"] = [
                "latitude" : location.latitude as AnyObject,
                "longitude" : location.longitude as AnyObject,
                "address" : dish.address as AnyObject
                ] as AnyObject
        }
        return rawDish
    }
    
    class func dictionary(from message: MFMessage) -> FirebaseDictionary {
        return  [
            "id": message.id as AnyObject,
            "messageText": message.messageText as AnyObject,
            //                "conversationId": message.conversationId as AnyObject,
            "senderId": message.senderId as AnyObject,
            "dateTime": message.dateTime as AnyObject,
            "senderDisplayName": message.senderDisplayName as AnyObject
            //                "receiverId": message.receiverId as AnyObject
            ] as FirebaseDictionary
    }
    
    class func dictionary(from user: MFUser) -> FirebaseDictionary {
        //        var userInfo: [String:AnyObject] = [
        //            :
        //            //                "socialAccountIDs"  : user.socialAccountIds as AnyObject,
        //            //                "userActivity"      : user.userActivity as AnyObject,
        //            //                "cookedDishes"      : user.cookedDishes as AnyObject,
        //            //                "boughtDishes"      : user.boughtDishes as AnyObject,
        //            //                "favouriteDishes"   : user.favouriteDishes as AnyObject,
        //            //                "likedDishes"       : user.likedDishes as AnyObject,
        //            //                "followers"         : user.followers as AnyObject,
        //            //                "following"         : user.following as AnyObject,
        //            //                "blocked"           : user.blocked as AnyObject
        //
        //        ]
        var userInfo = FirebaseDictionary()
        
        userInfo["id"] = user.id as AnyObject
        
        if let name = user.name {
            userInfo["name"] = name as AnyObject
        }
        
        if let email = user.email {
            userInfo["email"] = email as AnyObject
        }
        
        if let address = user.address {
            userInfo["address"] = address as AnyObject
        }
        
        if let addressDetailsTemp = user.addressDetails {
            var addressDetails: [String:AnyObject] = [:]
            addressDetails["address"] = addressDetailsTemp.address as AnyObject
            addressDetails["address_2"] = addressDetailsTemp.address_2 as AnyObject
            addressDetails["city"] = addressDetailsTemp.city as AnyObject
            addressDetails["state"] = addressDetailsTemp.state as AnyObject
            addressDetails["postalCode"] = addressDetailsTemp.postalCode as AnyObject
            addressDetails["latitude"] = addressDetailsTemp.latitude as AnyObject
            addressDetails["longitude"] = addressDetailsTemp.longitude as AnyObject
            
            userInfo["addressDetails"] = addressDetails as AnyObject
        }
        
        if let addressLocation = user.addressLocation {
            userInfo["addressLocation"] = addressLocation as AnyObject
        }
        
//        if let picture = user.picture {
//            userInfo["picture"] = picture as AnyObject
//        }
        
        userInfo["dishesSoldCount"] = user.dishesSoldCount as AnyObject
        
        if let profileDescription = user.profileDescription {
            userInfo["profileDescription"] = profileDescription as AnyObject
        }
        
        
        let phoneInfo: [String:Any] = [
            "countryCode": user.phone.countryCode,
            "phone": user.phone.phone
        ]
        userInfo["phone"] = phoneInfo as AnyObject
        
        return userInfo
    }
    
    class func dictionary(from address:MFUserAddress) -> FirebaseDictionary{
        return  [
            "id": address.id as AnyObject,
            "address": address.address as AnyObject,
            "address_2": address.address_2 as AnyObject,
            "city": address.city as AnyObject,
            "country": address.country  as AnyObject,
            "state": address.state as AnyObject,
            "postalCode": address.postalCode as AnyObject,
            "latitude": address.latitude as AnyObject,
            "longitude": address.longitude as AnyObject,
            "phone": address.phone as AnyObject ] as FirebaseDictionary
    }
}
