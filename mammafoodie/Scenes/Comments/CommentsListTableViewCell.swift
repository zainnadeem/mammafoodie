//
//  CommentsListTableViewCell.swift
//  mammafoodie
//
//  Created by Sireesha V on 6/11/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class CommentsListTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userCommentDate: UILabel!
    @IBOutlet weak var comments: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
