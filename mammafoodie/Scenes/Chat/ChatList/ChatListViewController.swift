import UIKit

protocol ChatListViewControllerInput {
    
}

protocol ChatListViewControllerOutput {
    
}

class ChatListViewController: UIViewController, ChatListViewControllerInput,ChatListViewAdapterDelegate {
    
    var output: ChatListViewControllerOutput!
    var router: ChatListRouter!
    lazy var chatListTableAdapter = ChatListAdapter()

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
    }
    
    func chatListPage(View:UIViewController)
    {
        self.navigationController?.pushViewController(View, animated: true)
    }
    
}
