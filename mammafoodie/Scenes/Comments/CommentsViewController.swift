import UIKit

protocol CommentsViewControllerInput {
    func EnterComments(comment:String)

}

protocol CommentsViewControllerOutput {
    func EnterComments(comment:String)
}

class CommentsViewController: UIViewController, CommentsViewControllerInput,CommentsAdapterDelegate {
    
    var commentsString = ""
    lazy var commentsTableAdapter = CommentsTableAdapter()	

    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    @IBOutlet weak var heightTextView: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var commentsTxt: UITextView!
    
    var output: CommentsViewControllerOutput!
    var router: CommentsRouter!
    
//    var backImage = UIImage(named: "menuimage")
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CommentsConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTableAdapter.delegate = self
        self.commentsTableAdapter.commentsTableView = self.tableView
        // Do any additional setup after loading the view.
        
        commentsTableAdapter.textViewHeightCons = self.heightTextView
        commentsTableAdapter.commentsTextView = self.commentsTxt
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationItem.title = "Comments"
        let btnBack = UIButton(type: UIButtonType.system)
        btnBack.setImage(UIImage.init(named: "BackBtn")?.withRenderingMode(.alwaysOriginal), for: UIControlState())
        btnBack.frame = CGRect(x: 30, y: 0, width: 40, height: 24)
//        btnBack.addTarget(self, action: #selector(backButtonClicked), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItems = [customBarItem]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    func EnterComments(comment:String)
    {
        self.commentsTableAdapter.commentsData(comment: comment)
    }
    
    
    func enterComments(comment: String) {
        self.output.EnterComments(comment:self.commentsTxt.text!)
    }
    
    
}
