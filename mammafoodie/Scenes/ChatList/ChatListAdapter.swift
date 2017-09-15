import Foundation
import UIKit
import DZNEmptyDataSet

protocol ChatListViewAdapterDelegate{
    
    func chatListPage(conversation:MFConversation)
    
}


class ChatListAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var chatListArray = [MFConversation](){
        didSet{
            chatTableView?.reloadData()
        }
    }
    var currentUser: String!
    
    var chatTableView: UITableView? {
        didSet {
            self.chatTableView?.delegate = self
            self.chatTableView?.dataSource = self
            //chatTableView?.rowHeight = UITableViewAutomaticDimension
            self.chatTableView?.estimatedRowHeight = 44
            self.chatTableView?.emptyDataSetSource = self
            self.chatTableView?.emptyDataSetDelegate = self
        }
    }
    
    var delegate:ChatListViewAdapterDelegate?

    //TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatListArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatListTableViewCell
    
        let conversation = chatListArray[indexPath.row]
        
        cell.setup(conversation:conversation, currentUserID: self.currentUser)
        
        /*
        if conversation.user1 == self.currentUser {
            cell.textLabel!.text = conversation.user2Name
            let url = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: conversation.user2)
            if let url = url{
                cell.imageView!.sd_setImage(with: url, placeholderImage: UIImage(named:"IconMammaFoodie")!)
            }
        } else {
            cell.textLabel!.text = conversation.user1Name
            let url = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: conversation.user1)
            if let url = url{
                cell.imageView!.sd_setImage(with: url, placeholderImage: UIImage(named:"IconMammaFoodie")!)
            }
        }

 */
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {

        
        delegate?.chatListPage(conversation:chatListArray[indexPath.row])
    }
}

extension ChatListAdapter: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.init(string: "No conversations", attributes: [NSFontAttributeName: UIFont.MontserratLight(with: 15)!])
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 0
    }

}

