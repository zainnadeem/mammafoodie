
import Foundation
import UIKit

class CommentsTableAdapter:NSObject, UITableViewDelegate,UITableViewDataSource, UITextViewDelegate {

    var commentsArray = [String]()
    var textViewHeightCons = NSLayoutConstraint()


    var commentsTableView:UITableView? {
        didSet{
            commentsTableView?.delegate = self
            commentsTableView?.dataSource = self
            commentsTableView?.rowHeight = UITableViewAutomaticDimension
            commentsTableView?.estimatedRowHeight = 160
        }
    }
    
    
    var commentsTextView:UITextView? {
        didSet{
            commentsTextView?.delegate = self
        }
    }
    
    
    func commentsData(comment:String) {
        self.commentsArray.append(comment)
        commentsTableView?.reloadData()
    }
    
    //TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CommentsListTableViewCell = commentsTableView!.dequeueReusableCell(withIdentifier: "commentsList") as! CommentsListTableViewCell
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.lineBreakMode = .byWordWrapping
        //        cell.textLabel?.text = commentsArray[indexPath.row].textContent
        cell.comments.text! = commentsArray[indexPath.row]
        return cell
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height <= 70   {
            if textView.text.characters.count == 15 {
                textViewHeightCons.constant = 25
            }else{
                textViewHeightCons.constant = textView.contentSize.height + 10
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            

            commentsTextView?.text = ""
            
            return false
        }
        return true
    }
    
    
    

    
}
