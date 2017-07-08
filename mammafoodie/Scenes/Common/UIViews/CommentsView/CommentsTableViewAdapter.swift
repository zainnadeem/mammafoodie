import UIKit

class CommentsTableViewAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var dish: MFDish!
    var comments: [MFComment] = []
    let worker: CommentsWorker = CommentsWorker()
    
    //    func createStaticData() {
    //        self.comments.append(MFComment(text: "Bravo!", username: "Zain", userId: "1"))
    //        self.comments.append(MFComment(text: "That looks delicious!!!", username: "Ram", userId: "2"))
    //        self.comments.append(MFComment(text: "You are amazing", username: "Nithin", userId: "3"))
    //        self.comments.append(MFComment(text: "This is amazing... I just love the way you speak.", username: "Joseph", userId: "5"))
    //        self.comments.append(MFComment(text: "Yummy!", username: "Zain", userId: "7"))
    //        self.comments.append(MFComment(text: "Wow! mouth watering!!", username: "Aishwarya", userId: "0"))
    //        self.comments.append(MFComment(text: "That looks delecious!!!", username: "Seerisha", userId: "13"))
    //        self.comments.append(MFComment(text: "Bravo!", username: "Zain", userId: "1"))
    //        self.comments.append(MFComment(text: "That looks delicious!!!", username: "Ram", userId: "2"))
    //        self.comments.append(MFComment(text: "You are amazing", username: "Nithin", userId: "3"))
    //        self.comments.append(MFComment(text: "This is amazing... I just love the way you speak.", username: "Joseph", userId: "5"))
    //        self.comments.append(MFComment(text: "Yummy!", username: "Zain", userId: "7"))
    //        self.comments.append(MFComment(text: "Wow! mouth watering!!", username: "Aishwarya", userId: "0"))
    //        self.comments.append(MFComment(text: "That looks delecious!!!", username: "Seerisha", userId: "13"))
    //    }
    
    func loadComments() {
        worker.load(for: self.dish) { (comments) in
            self.comments = comments
            self.reloadData()
        }
    }
    
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
        self.tableView.scrollToRow(at: IndexPath.init(item: self.comments.count-1, section: 0), at: UITableViewScrollPosition.top, animated: true)
//        self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentSize.height-self.tableView.frame.height), animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentTblCell = tableView.dequeueReusableCell(withIdentifier: "CommentTblCell", for: indexPath) as! CommentTblCell
        cell.setup(with: self.comments[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
}
