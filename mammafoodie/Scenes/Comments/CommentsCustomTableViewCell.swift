//
//  CommentsCustomTableViewCell.swift
//  mammafoodie
//
//  Created by Sireesha V on 6/28/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class CommentsCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var commentsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        textLabel?.numberOfLines = 3
        textLabel?.lineBreakMode = .byWordWrapping
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
