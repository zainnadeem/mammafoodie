//
//  CommentsViewController.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 11/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {

    @IBOutlet weak var commentsView: CommentsView!
    
    var dish: MFDish?
    
    var user: MFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.commentsView.dish = self.dish
        self.commentsView.user = self.user
        self.commentsView.btnEmoji.isHidden = true
        self.commentsView.btnLike.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
