import UIKit

protocol CommentsViewControllerInput {
    func EnterComments(comment:String)

}

protocol CommentsViewControllerOutput {
    func EnterComments(comment:String)
}

class CommentsViewController: UIViewController, CommentsViewControllerInput, UITextViewDelegate {
    
    var commentsString = ""
    lazy var commentsTableAdapter = CommentsTableAdapter()	

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var commentsTxt: UITextView!
    
    var output: CommentsViewControllerOutput!
    var router: CommentsRouter!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CommentsConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commentsTableAdapter.commentsTableView = self.tableView
        // Do any additional setup after loading the view.
        self.commentsTxt.delegate = self
    }
    
    
    @IBAction func commentsButton(_ sender: Any) {
        if self.commentsTxt.text.isEmpty {
            return
        }
        self.output.EnterComments(comment:self.commentsTxt.text!)
    }
    
    
    func EnterComments(comment:String)
    {
        self.commentsTableAdapter.commentsData(comment: comment)
    }

}
