//
//  CommentsAdapter.swift
//  mammafoodie
//
//  Created by Sireesha V on 6/12/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation
import UIKit

class CommentsTableAdapter:NSObject, UITableViewDelegate,UITableViewDataSource {

    var commentsArray = [String]()

    var commentsTableView:UITableView? {
        didSet{
            commentsTableView?.delegate = self
            commentsTableView?.dataSource = self
            commentsTableView?.rowHeight = UITableViewAutomaticDimension
            commentsTableView?.estimatedRowHeight = 44
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentsList", for: indexPath)
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.lineBreakMode = .byWordWrapping
        //        cell.textLabel?.text = commentsArray[indexPath.row].textContent
        cell.textLabel?.text = commentsArray[indexPath.row]
        return cell
    }
    
}
