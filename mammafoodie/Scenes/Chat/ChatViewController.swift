import UIKit
import Firebase
import JSQMessagesViewController


protocol ChatViewControllerInput {
    
}

protocol ChatViewControllerOutput {
   func chatWorkerInfo()
}

struct User {
     var id :String
     var name :String
}

class ChatViewController: JSQMessagesViewController, ChatViewControllerInput {
    
    var currentUser: User {
        return user1
    }

    var output: ChatViewControllerOutput!
    var router: ChatRouter!
    
    // MARK: - Object lifecycle
//    var messages = [JSQMessage]()
    var messages = [MFMessage]()
    var avatarDict = [String: JSQMessagesAvatarImage]()
    
    //ChatUsers
    let user1 = User(id: "1", name: "Steve")
    let user2 = User(id: "2", name: "siri")
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ChatConfigurator.sharedInstance.configure(viewController: self)
    }
    
}



extension ChatViewController {
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        print(senderId)
        let message = MFMessage(with: senderDisplayName, messagetext: text, senderId: senderId)
        messages.append(message)
         print(messages)
        finishSendingMessage()
        self.output.chatWorkerInfo()

    }
    
    
    
    //senderbabbletable
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
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
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        let message = messages[indexPath.row]
        
        if currentUser.id == message.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: .green)
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: .blue)
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
        print(senderId)
        print(currentUser.id)
        self.senderDisplayName = currentUser.name
        self.messages = getMessages()

    }
}

extension ChatViewController {
//    func getMessages() -> [JSQMessage] {
//        var messages = [JSQMessage]()
//        
//        let message2 = JSQMessage(senderId: "2", displayName: "siri", text: "Helo.")
//        messages.append(message2!)
//        
//        return messages
//    }
    
    func getMessages() -> [MFMessage] {
        var messages = [MFMessage]()
        
        let message1 = MFMessage(with: "Steve", messagetext: "Hey Tim how are you?", senderId: "1")
        let message2 = MFMessage(with: "siri", messagetext: "Helo.", senderId: "2")
       
        messages.append(message1)
        messages.append(message2)
        
        return messages
    }
}

extension ChatViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let picture = info[UIImagePickerControllerOriginalImage] as? UIImage
        _ = JSQPhotoMediaItem(image: picture)
//        messages.append(MFMessage(senderId:senderId, displayName:"steve", text:photo))
        self.dismiss(animated: true, completion: nil)
        self.collectionView.reloadData()
    }
}






