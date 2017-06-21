
import Foundation
import UIKit

protocol CommentsAdapterDelegate {
    func enterComments(comment:String)
}

class CommentsTableAdapter:NSObject, UITableViewDelegate,UITableViewDataSource, UITextViewDelegate {

    var commentsArray = [String]()
    var textViewHeightCons = NSLayoutConstraint()
    
    var delegate:CommentsAdapterDelegate?


    var commentsTableView:UITableView? {
        didSet{
            commentsTableView?.delegate = self
            commentsTableView?.dataSource = self
            commentsTableView?.rowHeight = UITableViewAutomaticDimension
            commentsTableView?.estimatedRowHeight = 160
            if commentsArray.count == 0 {
                let label = UILabel()
                label.text = "No comments."
                label.textColor = UIColor.lightGray
                label.sizeToFit()
                label.textAlignment = .center
                label.center = (commentsTableView?.center)!
                commentsTableView?.backgroundView = label
            } else {
                commentsTableView?.backgroundView = nil
            }
        }
    }
    
    
    var commentsTextView:UITextView? {
        didSet{
            commentsTextView?.delegate = self
            commentsTextView?.text = "Type your comment here..."
            commentsTextView?.textColor = UIColor.lightGray
        }
    }
    
    
    func commentsData(comment:String) {
        self.commentsArray.append(comment)
        commentsTableView?.reloadData()
    }
    
    //MARK: - TableView DataSource and Delegate
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
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }


    //MARK: - TextView Delegate
    
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
            guard textView.hasText else{
                print("Cannot send an empty message.")
                return false
            }
            commentsTableView?.backgroundView = nil
            delegate?.enterComments(comment:textView.text)
            commentsTextView?.text = ""
            commentsTableView?.reloadData()
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type your comment here..."
            textView.textColor = UIColor.lightGray
        }
    }
    
}
