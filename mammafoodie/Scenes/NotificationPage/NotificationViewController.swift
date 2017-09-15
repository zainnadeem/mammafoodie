//
//  NotificationViewController.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 14/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var notificationTableView: UITableView!
    
    let reuseIdentifier = "NotificationCell"
    var userID: String!
    var notifications = [MFNotification]() {
        didSet {
            self.notificationTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.notificationTableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        self.notificationTableView.delegate = self
        self.notificationTableView.dataSource = self
        self.notificationTableView.rowHeight = UITableViewAutomaticDimension
        self.notificationTableView.estimatedRowHeight = 60
        self.notificationTableView.emptyDataSetDelegate = self
        self.notificationTableView.emptyDataSetSource = self


        if let user = DatabaseGateway.sharedInstance.getLoggedInUser() {
            self.userID = user.id
            DatabaseGateway.sharedInstance.getNotificationsForUser(userID:"fYK04phVGPRpszYixlO2ort6gyF3") { (nots) in
                DispatchQueue.main.async {
                    self.notifications = nots
                }
            }
        } else {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension NotificationViewController: UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationTableViewCell
        let notif = self.notifications[indexPath.row]
        cell.setUp(notification: notif)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.init(string: "No notification", attributes: [NSFontAttributeName: UIFont.MontserratLight(with: 15)!])
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 0
    }
}
