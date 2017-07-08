//
//  SettingsViewController.swift
//  mammafoodie
//
//  Created by Sireesha V on 7/4/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var settingTblView: UITableView!
    
    var listArray =  ["Edit Profile","Rate Application","Terms and Condition","About Us", "Feedback","Logout"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTblView.delegate = self
        settingTblView.dataSource = self
        settingTblView.estimatedRowHeight = 60
        self.settingTblView.tableFooterView = UIView()

        let name: String = "SettingsTableViewCell"
        settingTblView.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
        
    }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsTableViewCell = settingTblView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
                cell.labelText.text! = self.listArray[indexPath.row] as String!
            return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
