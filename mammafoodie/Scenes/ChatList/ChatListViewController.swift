import UIKit

protocol ChatListViewControllerInput {
    
}

protocol ChatListViewControllerOutput {
    
}

class ChatListViewController: UIViewController, ChatListViewControllerInput,ChatListViewAdapterDelegate {
    
    var output: ChatListViewControllerOutput!
    var router: ChatListRouter!
    lazy var chatListTableAdapter = ChatListAdapter()
    lazy var worker = ChatListWorker()
    var currentUser: MFUser!
    
    @IBOutlet weak var chatListTableview: UITableView!
    
    // MARK: - Object lifecycle
    
    // MARK: - View lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        ChatListConfigurator.sharedInstance.configure(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatListTableAdapter.chatTableView = self.chatListTableview
        self.chatListTableview?.reloadData()
        self.chatListTableAdapter.delegate = self
        self.chatListTableAdapter.currentUser = self.currentUser.id
        
        self.title = "Chat List"
        
        self.worker.getConversations(forUser: self.currentUser.id) { (conversation) in
            if let conversation = conversation {
                self.chatListTableAdapter.chatListArray.append(conversation)
            }
            self.chatListTableview.reloadData()
        }
        
        //SetBack button image
        let backImage = #imageLiteral(resourceName: "BackBtn").withRenderingMode(.alwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.chatListTableAdapter.chatListArray.removeAll()
        worker.stopObserving()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAddTap(_ sender: UIBarButtonItem) {
        let nav = FollowersListViewController.showChatUserSelection { (chatUser) in
            self.worker.createConversation(user1: self.currentUser, user2: chatUser, { (status) in
                if status {
                    
                } else {
                    self.showAlert("Error!", message: "Failed start new conversation")
                }
            })
        }
        if let nav = nav {
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    func chatListPage(conversation: MFConversation) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Siri",bundle: nil)
        let destViewController = mainStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        destViewController.conversation = conversation
        destViewController.currentUser = self.currentUser
        self.navigationController?.pushViewController(destViewController, animated: true)
        
    }
    
}
