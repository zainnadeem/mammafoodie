import UIKit
import Firebase
import JSQMessagesViewController



struct User {
     var id :String
     var name :String
}

class ChatViewController: JSQMessagesViewController {
    
    
    var model = MFConversation()
    var modelMsg = MFMessage(with: "", messagetext: "", senderId: "")

    
    var currentUser: User {
        return user1
    }

    
    // MARK: - Object lifecycle
    var messages = [MFMessage]()
    var avatarDict = [String: JSQMessagesAvatarImage]()
    
    //ChatUsers
    let user1 = User(id: "1", name: "Steve")
    let user2 = User(id: "2", name: "siri")
    

}



extension ChatViewController {
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        print(senderId)
        let message = MFMessage(with: senderDisplayName, messagetext: text, senderId: senderId)
        messages.append(message)
        // print(messages)
        finishSendingMessage()
        ChatAPI()
    }
    
    //senderbabbletable
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
       // print(messages)
        let message = messages[indexPath.row]
        let messageUsername = message.senderDisplayName
        return NSAttributedString(string: messageUsername)
    }

    
//    //Height of table
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
//        return 15
//    }
    
    //ImageData
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory(bubble: UIImage(named:"Bubble"), capInsets: UIEdgeInsetsMake(0, 0, 0, 0))
        
        let message = messages[indexPath.row]
        
        if currentUser.id == message.senderId {
            
            return bubbleFactory?.outgoingMessagesBubbleImage(with: .lightGray)
        
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: .gray)
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
    
  
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == currentUser.id {
            cell.textView?.textColor = UIColor.white
            
            let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
            let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [ colorTop, colorBottom]
            gradientLayer.locations = [ 0.0, 0.5]
            gradientLayer.frame = cell.bounds
            
            
            
            
            cell.clipsToBounds = true
            
            let path = UIBezierPath(roundedRect:cell.messageBubbleImageView.bounds,
                                    byRoundingCorners:[  .topLeft],
                                    cornerRadii: CGSize(width: 10, height:  10))
            
            let maskLayer = CAShapeLayer()
            
            maskLayer.path = path.cgPath
            cell.messageBubbleImageView.layer.mask = maskLayer
            
            
            cell.messageBubbleImageView.clipsToBounds = true
            cell.messageBubbleImageView.layer.insertSublayer(gradientLayer, at: 0)
            
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
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
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    }
    
    func ChatAPI() {
        
        callAPI { message in
            let response = Chat.Response(arrayOfLiveChat: message)
            print(response)
        }
    }
    
    func callAPI(completion: @escaping ([MFMessage]) -> Void) {
        
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
    
    func getMessages() -> [MFMessage] {
        var messages = [MFMessage]()
        
        let message1 = MFMessage(with: "Steve", messagetext: "Hey how are you?", senderId: "1")
        let message2 = MFMessage(with: "siri", messagetext: "Iam Fine.", senderId: "2")
       
        messages.append(message1)
        messages.append(message2)
//        print(messages)
        return messages
    }
}







