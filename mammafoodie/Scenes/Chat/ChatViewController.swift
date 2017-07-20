import UIKit
import Firebase
import JSQMessagesViewController



struct UserChat {
     var id :String
     var name :String
}

class ChatViewController: JSQMessagesViewController {
    
    let gradientStartColor : UIColor = UIColor.init(red: 1.0, green: 0.39, blue: 0.13, alpha: 1.0)
    let gradientEndColor : UIColor = UIColor.init(red: 1.0, green: 0.55, blue: 0.17, alpha: 1.0)
    let defaults = UserDefaults.standard

    var otherUserID:String!
    var otherUserImage:UIImage!

    
    var threadID:String!
    
    // MARK: - Object lifecycle
    var messages = [MFMessage1]()

    var currentUser:MFUser!
    
    let bubbleFactory = JSQMessagesBubbleImageFactory(bubble: UIImage(named:"Bubble"), capInsets:UIEdgeInsetsMake(0, 0, 0, 0))
    
    let color1 = UIColor(red: 1, green: 0.55, blue: 0.17, alpha: 1)
    let color2 = UIColor(red: 1, green: 0.39, blue: 0.13, alpha: 1)
    
}



extension ChatViewController {
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        //Call api
        
        let message = MFMessage1(with: senderDisplayName, messagetext: text, senderId: senderId)
        messages.append(message)
        
        print(message)
        
        DatabaseGateway.sharedInstance.createMessage(with: message, conversationID: "-KpV9qbi0Nekw9YTCwV2") { (status) in
            print(status)
        }
        
        
        finishSendingMessage()
//        ChatAPI()
    }
    
    //senderbabbletable
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
       // print(messages)
        
        if defaults.bool(forKey: Setting.removeSenderDisplayName.rawValue) {
            return nil
        }
        
        let message = messages[indexPath.row]
        let messageUsername = message.senderDisplayName
        return NSAttributedString(string: messageUsername)
    }

    
    //Height of table
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
//        if defaults.bool(forKey: Setting.removeSenderDisplayName.rawValue) {
//            return 0.0
//        }
//        let currentMessage = self.messages[indexPath.item]
//        
//        if currentMessage.senderId == self.senderId {
//            return 0.0
//        }
//        
//        if indexPath.item - 1 > 0 {
//            let previousMessage = self.messages[indexPath.item - 1]
//            if previousMessage.senderId == currentMessage.senderId {
//                return 0.0
//            }
//        }
//        
//        return kJSQMessagesCollectionViewCellLabelHeightDefault
//    }
    
    //ImageData
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        if messages[indexPath.item].senderId == self.senderId{
            return nil //No Avatar image for current user
        } else {
            return getAvatar()
        }
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell

        // messages to show
        let msg = messages[indexPath.row]
            if msg.senderId == senderId {
                cell.textView.textColor = UIColor.white
                
                cell.messageBubbleImageView.applyGradient(colors: [color1, color2], direction: .leftToRight)
                
                
            }else{
                cell.textView.textColor = UIColor.black
            }
            cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor ?? UIColor.white]
            cell.textView.font = UIFont(name: "Montserrat", size: 12)
            cell.textView.textAlignment = .center

        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        
        let message = messages[indexPath.row]
        
        if self.senderId == message.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor(red: 255/255, green: 99/255, blue: 34/255, alpha: 1.0))
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0))
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        
        let mfMessageData = messages[indexPath.row]
        
        let jsqMessageData = JSQMessage(senderId: mfMessageData.senderId, displayName: mfMessageData.senderDisplayName, text: mfMessageData.messageText )
        
        return jsqMessageData
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        if (indexPath.item % 3 == 0) {
            let currentDate = Date()
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: currentDate)
        }
        return nil
    }
    

    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0.0
    }
   
  }

extension ChatViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // tell JSQMessagesViewController
        // who is the current user
        
        if let currentUser = AppDelegate.shared().currentUser {
            self.currentUser = currentUser
            self.senderId = currentUser.id
            self.senderDisplayName = currentUser.name
        }
        
        self.senderId = "Ki1ChCPqXuTBlMA485OPVAbjK6C2"
        self.senderDisplayName = "Test"
        
        let user2 = "-Ko7jcz0kX1Kb1OValue"
        
        
        DatabaseGateway.sharedInstance.createConversation(dateTime: Date.timeIntervalSinceReferenceDate.description, user1: self.senderId, user2: user2) { (status) in
            print(status)
        }
        
        
        //Hiding avatar image for current user
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
//        self.messages = getMessages()
       
        //Hiding attach Image
        self.inputToolbar.contentView.leftBarButtonItem = nil
    }
    
    func ChatAPI() {
        
        callAPI { message in
            let response = Chat.Response(arrayOfLiveChat: message)
            print(response)
        }
    }
    
    func callAPI(completion: @escaping ([MFMessage1]) -> Void) {
        
        //        let video = Message(name: "1")
//        DatabaseGateway.sharedInstance.createConversation(with:model) {newModel in
//            print(self.model)
//        }
//        DatabaseGateway.sharedInstance.createMessage(with: modelMsg) {_ in
//            //print(self.modelMsg)
//            completion([self.modelMsg])
//            
//        }
    }

}


extension ChatViewController {
    
    func getMessages(forConversation conversationID:String) -> [MFMessage1] {
        var messages = [MFMessage1]()
        
        
       
        //get messages for threadID

        return messages
    }
}







