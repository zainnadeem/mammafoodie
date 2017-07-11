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
    
    var dish:MFDish?
    
    var user:MFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        commentsView.dish = self.dish
        commentsView.user = self.user
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func dismissTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
   

}
