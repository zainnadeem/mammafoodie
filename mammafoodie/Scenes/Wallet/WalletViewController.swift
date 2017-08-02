//
//  WalletViewController.swift
//  mammafoodie
//
//  Created by Arjav Lad on 25/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class WalletViewController: UIViewController {
    
    @IBOutlet var viewTableHeader: UIView!
    @IBOutlet weak var viewHeaderWrapper: UIView!
    @IBOutlet weak var btnAddToWallet: UIButton!
    @IBOutlet weak var btnSendMoneyToBank: UIButton!
    @IBOutlet weak var lblWalletBalanceTitle: UILabel!
    @IBOutlet weak var lblWalletBalance: UILabel!
    @IBOutlet weak var lblPendingBalance: UILabel!
    
    @IBOutlet weak var tblTransactions: UITableView!
    
    var transactions : [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "BackBtn")
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "BackBtn")
    
        self.viewHeaderWrapper.layer.cornerRadius = 5.0
        self.viewHeaderWrapper.clipsToBounds = true
        self.tblTransactions.rowHeight = 64
        self.tblTransactions.register(UINib.init(nibName: "WalletTransactionsTblCell", bundle: nil), forCellReuseIdentifier: "WalletTransactionsTblCell")
        self.setWalletAmount(0)
        self.btnAddToWallet.isHidden = true
        self.tblTransactions.reloadData()
        
        self.getCurrentBalance()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.viewHeaderWrapper.applyGradient(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func setWalletAmount(_ amount : Double, _ pending : Double = 0 ) {
        let formatter = NumberFormatter.init()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        self.lblWalletBalance.text = formatter.string(from: amount as NSNumber)
        self.lblPendingBalance.text = "Pending : \(formatter.string(from: amount as NSNumber) ?? "$0")"
    }
    
    func getCurrentBalance() {
        if let currentUser = Auth.auth().currentUser {
            FirebaseReference.stripeCustomers.classReference.child(currentUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let account = snapshot.value as? [String : Any] {
                    if let charges = account["charges"] as? [String : [String : Any]] {
                        for (_, value) in charges {
                            if let amount = value["amount"] as? Double {
                                self.transactions.append("\(amount)")
                            }
                        }
                        DispatchQueue.main.async {
                            self.tblTransactions.reloadData()
                        }
                    }
                    
                    if let accountID = account["account_id"] as? String {
                        if let url = URL.init(string: "https://us-central1-mammafoodie-baf82.cloudfunctions.net/retreiveBalance") {
                            let params : Parameters = ["accountId" : accountID]
                            Alamofire.request(url, method: .get, parameters: params).responseJSON(completionHandler: { (response) in
                                if let jsonResponse = response.result.value as? [String : Any] {
                                    if let available = jsonResponse["available"] as? Double {
                                        self.setWalletAmount(available, (jsonResponse["pending"] as? Double) ?? 0)
                                    }
                                    print(jsonResponse)
                                } else {
                                    print(response)
                                }
                            })
                        }
                    }
                }
            })
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onAddToWallet(_ sender: UIButton) {
        
    }
    
    @IBAction func onSendMoneyToBank(_ sender: UIButton) {
        if let currentUser = Auth.auth().currentUser {
            FirebaseReference.stripeCustomers.classReference.child(currentUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let stripeAccount = snapshot.value as? [String : Any] {
                    if let externalAccounts = stripeAccount["externalAccounts"] {
                        
                    } else {
                        DispatchQueue.main.async {
                            StripeVerificationViewController.presentStripeVerification(on: self) { (verified) in
//                                DispatchQueue.main.async {
//                                    BankDetailsViewController.presentAddAccount(on: self) { (bankDetails) in
//                                        
//                                    }
//                                }
                            }
                        }
                    }
                }
            })
        }
    }
    
}

extension WalletViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : WalletTransactionsTblCell = tableView.dequeueReusableCell(withIdentifier: "WalletTransactionsTblCell", for: indexPath) as! WalletTransactionsTblCell
        cell.lblAction.text = "Amount : \(self.transactions[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init()
        header.backgroundColor = .white
        var frame = tableView.frame
        frame.origin = CGPoint.init(x: 0, y: 0)
        frame.size.height = 44
        header.frame = frame
        
        let label = UILabel.init(frame: frame)
        label.frame.origin.x = 20
        label.text = "Transactions"
        label.font = UIFont.MontserratSemiBold(with: 14)
        label.textColor = #colorLiteral(red: 0.3725490196, green: 0.3647058824, blue: 0.4392156863, alpha: 1)
        header.addSubview(label)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
}
