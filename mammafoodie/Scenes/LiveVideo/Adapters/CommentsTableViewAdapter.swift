import UIKit

class CommentsTableViewAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var comments: [MFComment] = []
    
    func createStaticData() {
        self.comments.append(MFComment(text: "Bravo!", username: "Zain", userId: "1"))
        self.comments.append(MFComment(text: "That looks delicious!!!", username: "Ram", userId: "2"))
        self.comments.append(MFComment(text: "You are amazing", username: "Nithin", userId: "3"))
        self.comments.append(MFComment(text: "This is amazing... I just love the way you speak.", username: "Joseph", userId: "5"))
        self.comments.append(MFComment(text: "Yummy!", username: "Zain", userId: "7"))
        self.comments.append(MFComment(text: "Wow! mouth watering!!", username: "Aishwarya", userId: "0"))
        self.comments.append(MFComment(text: "That looks delecious!!!", username: "Seerisha", userId: "13"))
        self.comments.append(MFComment(text: "Bravo!", username: "Zain", userId: "1"))
        self.comments.append(MFComment(text: "That looks delicious!!!", username: "Ram", userId: "2"))
        self.comments.append(MFComment(text: "You are amazing", username: "Nithin", userId: "3"))
        self.comments.append(MFComment(text: "This is amazing... I just love the way you speak.", username: "Joseph", userId: "5"))
        self.comments.append(MFComment(text: "Yummy!", username: "Zain", userId: "7"))
        self.comments.append(MFComment(text: "Wow! mouth watering!!", username: "Aishwarya", userId: "0"))
        self.comments.append(MFComment(text: "That looks delecious!!!", username: "Seerisha", userId: "13"))
    }
    
    func setup(with tableView: UITableView) {
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        
        let name: String = "CommentTblCell"
        self.tableView.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
        
        self.createStaticData()
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
