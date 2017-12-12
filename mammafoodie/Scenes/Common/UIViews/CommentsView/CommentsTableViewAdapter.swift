import UIKit

class CommentsTableViewAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var dish: MFDish!
    var commentIdToHighlight: String?
    var comments: [MFComment] = []
    let worker: CommentsWorker = CommentsWorker()
    var openUserProfile: OpenUserProfile?
    
    func loadComments() {
        worker.load(for: self.dish) { (newComments) in
            let filtered = newComments.filter({ (comment) -> Bool in
                return !self.comments.contains(comment)
            })
            self.comments.append(contentsOf: filtered)
            print("Number of comments (for dish \(self.dish.id): \(self.comments.count)")
            
            self.reloadData()
            
//            if let commentIdToHighlight: String = self.commentIdToHighlight {
//                self.highlightComment(id: commentIdToHighlight)
//            }
        }
    }
    
//    private func highlightComment(id: String) {
//        var indexToHighlight: Int?
//        for (index, comment) in self.comments.enumerated() {
//            if comment.id == id {
//                indexToHighlight = index
//                break
//            }
//        }
//        if let indexToHighlight = indexToHighlight {
//            let indexPath: IndexPath = IndexPath(item: indexToHighlight, section: 0)
//            self.reloadData()
//        } else {
//            print("Comment not found in the list \(id)")
//        }
//    }
    
    func setup(with tableView: UITableView) {
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        
        let name: String = "CommentTblCell"
        self.tableView.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
        self.loadComments()
    }
    
    func reloadData() {
        self.tableView.reloadData()
        self.scrollToBottom()
    }
    
    func scrollToBottom() {
        if self.comments.count > 0 {
            self.tableView.scrollToRow(at: IndexPath.init(item: self.comments.count-1, section: 0), at: UITableViewScrollPosition.top, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentTblCell = tableView.dequeueReusableCell(withIdentifier: "CommentTblCell", for: indexPath) as! CommentTblCell
        cell.setup(with: self.comments[indexPath.item])
        cell.highlightCell(for: self.commentIdToHighlight)
        cell.openLink = self.openUserProfile
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
}
