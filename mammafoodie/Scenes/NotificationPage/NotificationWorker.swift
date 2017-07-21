//
//  NotificationWorker.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 17/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation

class NotificationWorker {
    
    var notificationResponseCount = 0
    
    func getNotificationForUser(userID:String, _ completion:@escaping ([MFNotification]?)->()){
        
        notificationResponseCount = 0
        
        DatabaseGateway.sharedInstance.getNotificationsForUser(userID:userID){ notifications in
            
            guard let notificationData = notifications as? [String:AnyObject] else {
                
                completion([])
                return
            }
            
            var notifications = [MFNotification]()
            
            for key in notificationData.keys{
                
                
                DatabaseGateway.sharedInstance.getNotification(notificationID:key){
                    notification in
                    
                    
                    self.notificationResponseCount += 1
                    
                    if notification != nil {
                        notifications.append(notification!)
                    }
                    
                    if self.notificationResponseCount == notificationData.keys.count{
                        self.notificationResponseCount = 0
                        completion(notifications)
                    }
                
                }
                
                
            }
         
        }
        
    }
    
    
    
    
    
    
    
    
    
    
}
