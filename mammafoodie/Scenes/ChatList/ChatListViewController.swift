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
    
    var currentUser:MFUser!
    
    var createChatWithUser:MFUser?

    // MARK: - Object lifecycle
    @IBOutlet weak var chatListTableview: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ChatListConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatListTableAdapter.chatTableView = self.chatListTableview
        chatListTableview?.reloadData()
        chatListTableAdapter.delegate = self
        chatListTableAdapter.currentUser = self.currentUser.id
        
        self.title = "Chat List"
        
   
        
        
        if let newChatUser = createChatWithUser{
            worker.createConversation(createdAt:Date.timeIntervalSinceReferenceDate.description, user1: self.currentUser.id, user2: newChatUser.id, user1Name: self.currentUser.name, user2Name: newChatUser.name){  status in
                print(status)
            }
        }
        
        
        worker.getConversations(forUser: self.currentUser.id) { (conversation) in
            if conversation != nil{
                self.chatListTableAdapter.chatListArray.append(conversation!)
            }
            
            self.chatListTableview.reloadData()
        }
        
        
        //SetBack button image
        let backImage = UIImage(named:"BackBtn")?.withRenderingMode(.alwaysOriginal)
        
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
    }
    
 
    
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.chatListTableAdapter.chatListArray.removeAll()
        worker.stopObserving()
        self.dismiss(animated: true, completion: nil)
    }
    
    func chatListPage(conversation:MFConversation)
    {
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Siri",bundle: nil)
        let destViewController = mainStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        destViewController.conversation = conversation
        destViewController.currentUser = self.currentUser
        self.navigationController?.pushViewController(destViewController, animated: true)
    }
    
}
