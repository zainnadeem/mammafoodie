//
//  CommentsView.swift
//  mammafoodie
//
//  Created by Sireesha V on 6/28/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class CommentsView: UIView, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    var view: UIView!
    var myMutableString: NSMutableAttributedString?

    @IBOutlet weak var commentsTable: UITableView!
    
    @IBOutlet weak var commentsTextView: UITextView!
    
    @IBOutlet weak var textViewHeightCons: NSLayoutConstraint!
   
    
    var commentsData = [MFComment](){
        didSet{
            CommentData()
            commentsTable?.reloadData()
        }
    }
    var attrStringArray = [NSMutableAttributedString]()
//    var commentsAttribute = [NSMutableAttributedString]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentsTable?.delegate = self
        commentsTable?.dataSource = self
        commentsTextView?.delegate = self
        commentsTable?.rowHeight = UITableViewAutomaticDimension
        commentsTable?.estimatedRowHeight = 160
        
        self.commentsTable.register(UINib(nibName: "CommentsCustomTableViewCell", bundle: nil),forCellReuseIdentifier: "commentscell")
        CommentData()
        
    }
    
    func CommentData() {
        myMutableString = NSMutableAttributedString(
            string: "Siri",
            attributes: [:])
        
        myMutableString?.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor.blue,
            range: NSRange(
                location:0,
                length:4))
    }
    
    //MARK: - TableView DataSource and Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CommentsCustomTableViewCell = commentsTable!.dequeueReusableCell(withIdentifier: "commentscell") as! CommentsCustomTableViewCell
        cell.commentsLabel.attributedText = attrStringArray[indexPath.row]
        return cell
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
            commentsTable?.backgroundView = nil
            let comment = MFComment(text: commentsTextView.text!, username: "Siri", userId: "")
            self.commentsData.append(comment)
            myMutableString = NSMutableAttributedString(
                string: "Siri",
                attributes: [:])
            myMutableString?.append(NSMutableAttributedString(string:  "  " + comment.text))
            myMutableString?.addAttribute(
                NSForegroundColorAttributeName,
                value: UIColor.blue,
                range: NSRange(
                    location:0,
                    length:4))
            attrStringArray.append(myMutableString!)
            commentsTextView?.text = ""
            commentsTable?.reloadData()
            textView.resignFirstResponder()
            textViewHeightCons.constant = 25
            return false
        }
        return true
    }
    
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        // 2. call super.init(frame:)
        super.init(frame: frame)
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CommentsView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner:self, options: nil)[0] as! UIView
        return view
    }
    
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
    

    


}
