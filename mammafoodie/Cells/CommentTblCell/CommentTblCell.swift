//
//  CommentTblCell.swift
//  mammafoodie
//
//  Created by Akshit Zaveri on 21/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class CommentTblCell: UITableViewCell {
    
    var comment: MFComment!
    
    @IBOutlet weak var lblDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(with comment: MFComment) {
        self.comment = comment
        let username: String = comment.user.name
        let commentText: String = comment.text
        
        let usernameFont: UIFont = UIFont(name: "Montserrat-Regular", size: 11.5)!
        let usernameFormatAttributes: [String:Any] = [NSFontAttributeName: usernameFont, NSForegroundColorAttributeName: #colorLiteral(red: 0, green: 0.8117647059, blue: 0.8666666667, alpha: 1) ]
        let formattedUsername: NSMutableAttributedString = NSMutableAttributedString(string: username, attributes: usernameFormatAttributes)
        
        let commentFont: UIFont = UIFont(name: "Montserrat-Light", size: 11.5)!
        let commentFormatAttributes: [String:Any] = [NSFontAttributeName: commentFont, NSForegroundColorAttributeName: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) ]
        let formattedComment: NSMutableAttributedString = NSMutableAttributedString(string: commentText, attributes: commentFormatAttributes)
        
        let commentAttributedString: NSMutableAttributedString = NSMutableAttributedString()
        commentAttributedString.append(formattedUsername)
        commentAttributedString.append(NSAttributedString(string: " "))
        commentAttributedString.append(formattedComment)
        self.lblDetails.attributedText = commentAttributedString
    }
    
    func highlightCell(for commentId: String?) {
        if self.comment.id == commentId {
            self.backgroundColor = UIColor.gray
        } else {
            self.backgroundColor = UIColor.clear
        }
    }
    
}
