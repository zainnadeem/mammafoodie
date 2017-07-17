//
//  NotificationViewController.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 14/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    
    @IBOutlet weak var notificationTableView:UITableView!
    
    let reuseIdentifier = "NotificationCell"
    
    lazy var worker = NotificationWorker()
    
    var userID:String!
    
    var notifications = [MFNotification](){
        didSet{
            notificationTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
         notificationTableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.worker.getNotificationForUser(userID: userID) { (notifications) in
            
            if let notifications = notifications{
                self.notifications = notifications
            }
            
        }
        
    }
    

    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension NotificationViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationTableViewCell
        
        let notif = notifications[indexPath.row]
        
        cell.setUp(notification: notif)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   
}
