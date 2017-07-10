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

    var model = MFConversation1()
    var modelMsg = MFMessage1(with: "", messagetext: "", senderId: "")

    
    var currentUser: UserChat {
        return user1
    }

    
    // MARK: - Object lifecycle
    var messages = [MFMessage1]()
    var avatarDict = [String: JSQMessagesAvatarImage]()
    
    //ChatUsers
    let user1 = UserChat(id: "1", name: "Steve")
    let user2 = UserChat(id: "2", name: "siri")
       
}



extension ChatViewController {
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        print(senderId)
        let message = MFMessage1(with: senderDisplayName, messagetext: text, senderId: senderId)
        messages.append(message)
        // print(messages)
        finishSendingMessage()
        ChatAPI()
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
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        if defaults.bool(forKey: Setting.removeSenderDisplayName.rawValue) {
            return 0.0
        }
        let currentMessage = self.messages[indexPath.item]
        
        if currentMessage.senderId == self.senderId {
            return 0.0
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.senderId == currentMessage.senderId {
                return 0.0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    //ImageData
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return getAvatar()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell

        // messages to show
        let msg = messages[indexPath.row]
            if msg.senderId == senderId {
                cell.textView.textColor = UIColor.white
            }else{
                cell.textView.textColor = UIColor.black
            }
            cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor ?? UIColor.white]
            cell.textView.font = UIFont(name: "Montserrat", size: 12)
            cell.textView.textAlignment = .center

        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        let message = messages[indexPath.row]
        
        if currentUser.id == message.senderId {
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
        self.senderId = currentUser.id
       // print(senderId)
        //print(currentUser.id)
        self.senderDisplayName = currentUser.name
        self.messages = getMessages()
       
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
        DatabaseGateway.sharedInstance.createConversation(with:model) {newModel in
            print(self.model)
        }
        DatabaseGateway.sharedInstance.createMessage(with: modelMsg) {_ in
            //print(self.modelMsg)
            completion([self.modelMsg])
            
        }
    }

}


extension ChatViewController {
    
    func getMessages() -> [MFMessage1] {
        var messages = [MFMessage1]()
        
        let message1 = MFMessage1(with: "Steve", messagetext: "Hey how are you?", senderId: "1")
        let message2 = MFMessage1(with: "siri", messagetext: "Iam Fine.", senderId: "2")
       
        messages.append(message1)
        messages.append(message2)
//        print(messages)
        return messages
    }
}







