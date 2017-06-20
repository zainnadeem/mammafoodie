import UIKit
import Firebase
import JSQMessagesViewController



struct User {
     var id :String
     var name :String
}

class ChatViewController: JSQMessagesViewController {
    
    
    var model = MFConversation1()
    var modelMsg = MFMessage1(with: "", messagetext: "", senderId: "")

    
    var currentUser: User {
        return user1
    }

    
    // MARK: - Object lifecycle
    var messages = [MFMessage1]()
    var avatarDict = [String: JSQMessagesAvatarImage]()
    
    //ChatUsers
    let user1 = User(id: "1", name: "Steve")
    let user2 = User(id: "2", name: "siri")
       
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
        let message = messages[indexPath.row]
        let messageUsername = message.senderDisplayName
        return NSAttributedString(string: messageUsername)
    }

    
    //Height of table
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
    
    //ImageData
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        let message = messages[indexPath.row]
        
        if currentUser.id == message.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: .green)
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: .lightGray)
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







