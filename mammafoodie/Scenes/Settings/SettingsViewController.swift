//
//  SettingsViewController.swift
//  mammafoodie
//
//  Created by Sireesha V on 7/4/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingTblView: UITableView!
    
    var listArray : [SettingsItem] = [SettingsItem.init(id : 0, title: "Edit Profile"),
                                      SettingsItem.init(id : 1, title: "My Wallet"),
                                      SettingsItem.init(id : 2, title: "Rate Application"),
                                      SettingsItem.init(id: 3, title: "Terms and Conditions"),
                                      SettingsItem.init(id: 4, title: "About Us"),
                                      SettingsItem.init(id: 5, title: "Logout")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settingTblView.delegate = self
        self.settingTblView.dataSource = self
        self.settingTblView.rowHeight = 60
        self.settingTblView.tableFooterView = UIView()
        
        self.settingTblView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
    }
    
    @IBAction func onBackTap(_ sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: {
            
        })
    }
}

extension SettingsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsTableViewCell = settingTblView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        
        cell.labelText.text = self.listArray[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.listArray[indexPath.row].id {
        case 0:
            break
            
        case 1:
            self.performSegue(withIdentifier: "segueShowWalletViewController", sender: self)
            
        case 5:
            AppDelegate.shared().setLoginViewController()
            let worker = FirebaseLoginWorker()
            worker.signOut { (errorMessage) in
                
            }
            
        default:
            break
        }
    }
}


struct SettingsItem {
    let id : Int
    let title : String
}
