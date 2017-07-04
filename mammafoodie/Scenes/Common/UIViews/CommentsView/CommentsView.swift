import UIKit

class CommentsView: UIView {
    
    var view: UIView!
    var list: [MFComment] = []
    var tableViewAdapter: CommentsTableViewAdapter = CommentsTableViewAdapter()
    var initialHeightOfTextView: CGFloat = 0
    var dish: MFDish!
    var user: MFUser!
    let maxAllowedHeightOfTextView: CGFloat = 100
    
    var requestingToPostNewComment: ((MFComment)->Void)?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var constraintHeightTextView: NSLayoutConstraint!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnEmoji: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnLike.imageView?.contentMode = .scaleAspectFit
        self.btnEmoji.imageView?.contentMode = .scaleAspectFit
        self.initialHeightOfTextView = self.constraintHeightTextView.constant
        self.textView.contentInset = UIEdgeInsets.zero
        self.textView.delegate = self
        
        //        self.dish = MFDish()
        //        self.dish.id = "-KnmktPfRQq61M1iswq5"
        
        // For demo only
        self.user = MFUser()
        self.user.id = "-Ko25iOEH_Erg-7B3UQb"
        self.user.name = "Arjav"
    }
    
    func load() {
        self.tableViewAdapter.dish = self.dish
        self.tableViewAdapter.comments = self.list
        self.tableViewAdapter.setup(with: self.tableView)
    }
    
    func showLatestComment() {
        self.tableViewAdapter.scrollToBottom()
    }
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        // 2. call super.init(frame:)
        super.init(frame: frame)
        // 3. Setup view from .xib file
        self.xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        // 3. Setup view from .xib file
        self.xibSetup()
    }
    
    func xibSetup() {
        self.view = loadViewFromNib()
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        self.addSubview(self.view)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        // align self.view from the left and right
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.view]));
        
        // align self.view from the top and bottom
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.view]));
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CommentsView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner:self, options: nil)[0] as! UIView
        return view
    }
}

extension CommentsView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Comment"
            textView.textColor = UIColor.lightGray
        }
    }
    
    //MARK: - TextView Delegate
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height <= self.initialHeightOfTextView {
            self.setInitialHeightForTextView()
        } else if textView.contentSize.height <= self.maxAllowedHeightOfTextView   {
            self.constraintHeightTextView.constant = textView.contentSize.height
        }
    }
    
    func setInitialHeightForTextView() {
        self.constraintHeightTextView.constant = self.initialHeightOfTextView
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.tableView.backgroundView = nil
            self.textView.resignFirstResponder()
            
            guard textView.hasText else {
                print("Cannot send an empty message.")
                return false
            }
            
            let comment: MFComment = MFComment()
            comment.text = textView.text!
            comment.createdAt = Date()
            comment.user = self.user
            //            self.list.append(comment)
            //            self.requestingToPostNewComment?(comment)
            
            let worker = CommentsWorker()
            worker.post(comment, on: self.dish, {
                print("Comment posted")
                //                self.tableViewAdapter.reloadData()
            })
            
            self.textView.text = ""
            self.tableView.reloadData()
            self.setInitialHeightForTextView()
            
            return false
        }
        return true
    }
}
