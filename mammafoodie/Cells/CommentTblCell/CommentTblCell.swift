//
//  CommentTblCell.swift
//  mammafoodie
//
//  Created by Akshit Zaveri on 21/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import TTTAttributedLabel

typealias OpenUserProfile = (String)->Void

class CommentTblCell: UITableViewCell, TTTAttributedLabelDelegate {
    
    var comment: MFComment!
    var openLink: OpenUserProfile?
    
    @IBOutlet weak var lblDetails: TTTAttributedLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblDetails.delegate = self
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
        
        let rangeUsername = (self.lblDetails.attributedText.string as NSString).range(of: formattedUsername.string)
        self.lblDetails.addLink(to: URL.init(string: "\(FirebaseReference.users.rawValue)://\(comment.user.id)")!, with: rangeUsername)
    }
    
    func highlightCell(for commentId: String?) {
        if self.comment.id == commentId {
            self.backgroundColor = UIColor.gray
        } else {
            self.backgroundColor = UIColor.clear
        }
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if let id = url.host {
            self.openLink?(id)
        } else {
            print("Incorrect URL: \(url.absoluteString)")
        }
    }
}
