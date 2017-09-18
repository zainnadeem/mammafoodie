import UIKit
import Firebase
import JSQMessagesViewController
import SDWebImage

class ChatViewController: JSQMessagesViewController {
    
    let gradientStartColor : UIColor = UIColor.init(red: 1.0, green: 0.39, blue: 0.13, alpha: 1.0)
    let gradientEndColor : UIColor = UIColor.init(red: 1.0, green: 0.55, blue: 0.17, alpha: 1.0)
    let defaults = UserDefaults.standard

    var conversation:MFConversation!
    
    // MARK: - Object lifecycle
    var messages = [MFMessage]() {
        didSet{
            finishSendingMessage()
        }
    }

    var currentUser:MFUser!
    
    lazy var worker = ChatWorker()
    
    let bubbleFactory = JSQMessagesBubbleImageFactory(bubble: UIImage(named:"Bubble"), capInsets:UIEdgeInsetsMake(0, 0, 0, 0))
    
    let color1 = UIColor(red: 1, green: 0.55, blue: 0.17, alpha: 1)
    let color2 = UIColor(red: 1, green: 0.39, blue: 0.13, alpha: 1)
    
    var OtherUserProfileImage:UIImage? {
        didSet{
            collectionView.reloadData()
        }
    }
    
}



extension ChatViewController {
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        //Call api
        
        let message = MFMessage(with: senderDisplayName, messagetext: text, senderId: senderId)
        
        
        worker.createMessage(with: message, conversationID: self.conversation.id, { status in
            print(status)
        })
        
        
        

    }
    
    //senderbabbletable
    /*
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
       // print(messages)
        
        if defaults.bool(forKey: Setting.removeSenderDisplayName.rawValue) {
            return nil
        }
        
        let message = messages[indexPath.row]
        let messageUsername = message.senderDisplayName
        return NSAttributedString(string: messageUsername)
    }
*/
    
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
        
        if messages[indexPath.item].senderId == self.senderId{
            return nil //No Avatar image for current user
        } else {
            return JSQMessagesAvatarImageFactory.avatarImage(with: self.OtherUserProfileImage ?? UIImage(named: "IconMammaFoodie")!, diameter: 20)
        
        }
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell

        // messages to show
        let msg = messages[indexPath.row]
            if msg.senderId == senderId {
                cell.textView.textColor = UIColor.white
                
                //cell.messageBubbleImageView.applyGradient(colors: [color1, color2], direction: .leftToRight)
                
                
            }else{
                cell.textView.textColor = UIColor.black
            }
            cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor ?? UIColor.white]
            cell.textView.font = UIFont(name: "Montserrat", size: 14)
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
            let messageDate = messages[indexPath.item].dateTime
            
            if let interval = Double(messageDate){
                let currentDate = Date(timeIntervalSinceReferenceDate: interval)
                return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: currentDate)
            } else {
                return nil
            }
            
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

        
        if let currentUser = AppDelegate.shared().currentUser {
            self.currentUser = currentUser
            self.senderId = currentUser.id
            self.senderDisplayName = currentUser.name
        }
        
        //Hiding avatar image for current user
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        //Hiding attach Image
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        var url: URL!
        
        if conversation.user1 == self.currentUser.id{
            url = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: conversation.user2)
            self.title = conversation.user2Name
        } else {
            url = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: conversation.user1)
            self.title = conversation.user1Name
        }
        
        //download avatar image
        SDWebImageDownloader.shared().downloadImage(with: url, options: SDWebImageDownloaderOptions(rawValue: 0), progress: { (_, _) in }, completed: { (image, _, _, finished) in
        
        if finished {
            self.OtherUserProfileImage = image ?? UIImage(named: "IconMammaFoodie")!
        }
            
        })
        
        
        
        getMessages(forConversation: self.conversation.id)
    }
    

    func getMessages(forConversation conversationID:String){
        
        
        
        worker.getMessages(forConversation: conversationID, { message in
            
            if message != nil {
                self.messages.append(message!)

            }
            
        })

    }
}







