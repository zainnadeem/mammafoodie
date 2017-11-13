import Foundation
import UIKit

protocol ChatListViewAdapterDelegate{
    
    func chatListPage(View:UIViewController)
    
}


class ChatListAdapter:NSObject, UITableViewDelegate,UITableViewDataSource {
    
    var chatListArray = ["Siri","Steve","Sony"]
    
    var chatTableView:UITableView? {
        didSet{
            chatTableView?.delegate = self
            chatTableView?.dataSource = self
            chatTableView?.rowHeight = UITableViewAutomaticDimension
            chatTableView?.estimatedRowHeight = 44
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatlist", for: indexPath)
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.lineBreakMode = .byWordWrapping
        //        cell.textLabel?.text = commentsArray[indexPath.row].textContent
        cell.textLabel?.text = chatListArray[indexPath.row]
       // cell.imageView?.image =
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {

        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Siri",bundle: nil)
        let destViewController = mainStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        delegate?.chatListPage(View: destViewController)
    }
}
