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
import DZNEmptyDataSet

class WalletViewController: UIViewController {
    
    @IBOutlet var viewTableHeader: UIView!
    @IBOutlet weak var viewHeaderWrapper: UIView!
    @IBOutlet weak var btnAddToWallet: UIButton!
    @IBOutlet weak var btnSendMoneyToBank: UIButton!
    @IBOutlet weak var lblWalletBalanceTitle: UILabel!
    @IBOutlet weak var lblWalletBalance: UILabel!
    @IBOutlet weak var lblPendingBalance: UILabel!
    @IBOutlet weak var btnVerificationStatus: UIButton!
    
    @IBOutlet weak var tblTransactions: UITableView!
    
    var transactions: [MFTransaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "BackBtn")
        //        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "BackBtn")
        
        self.viewHeaderWrapper.layer.cornerRadius = 5.0
        self.viewHeaderWrapper.clipsToBounds = true
        self.tblTransactions.rowHeight = UITableViewAutomaticDimension
        self.tblTransactions.register(UINib(nibName: "WalletTransactionsTblCell", bundle: nil), forCellReuseIdentifier: "WalletTransactionsTblCell")
        self.tblTransactions.emptyDataSetSource = self
        self.tblTransactions.emptyDataSetDelegate = self
        self.setWalletAmount(0)
        self.btnAddToWallet.isHidden = true
        self.tblTransactions.reloadData()
        
        self.getCurrentBalance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let currentUser: MFUser = DatabaseGateway.sharedInstance.getLoggedInUser() {
            self.btnSendMoneyToBank.isSelected = true
            if currentUser.isStripeAccountVerified == true {
                self.btnSendMoneyToBank.isSelected = false
            } else if currentUser.submittedForStripeVerification == true {
                self.btnVerificationStatus.isSelected = true
            } else {
                self.btnVerificationStatus.setTitle("Click to verify", for: .normal)
                self.btnVerificationStatus.setTitleColor(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), for: .normal)
            }
        }
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
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = Locale.current
        self.lblWalletBalance.text = formatter.string(from: (amount/100) as NSNumber)
        self.lblPendingBalance.text = "Pending : \(formatter.string(from: (pending/100) as NSNumber) ?? "$0")"
    }
    
    func getCurrentBalance() {
        if let currentUser = Auth.auth().currentUser {
            FirebaseReference.stripeCustomers.classReference.child(currentUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let account = snapshot.value as? [String : Any] {
                    if let charges = account["charges"] as? [String : [String : Any]] {
                        for (_, value) in charges {
                            self.transactions.append(self.transaction(from: value))
                            //                            if let amount = value["amount"] as? Double {
                            //                                self.transactions.append("\(amount)")
                            //                            }
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
                                    self.setWalletAmount((jsonResponse["available"] as? Double) ?? 0, (jsonResponse["pending"] as? Double) ?? 0)
                                    print("Balance: \(jsonResponse)")
                                } else {
                                    print("Balance \(response)")
                                }
                            })
                        }
                    }
                }
            })
        }
    }
    
    func transaction(from raw: [String: Any]) -> MFTransaction {
        let transaction: MFTransaction = MFTransaction()
        
        transaction.amount = raw["amount"] as? Double ?? 0
        transaction.currency = "$"
        
        let paymentPurpose: PaymentPurpose = PaymentPurpose(rawValue: raw["paymentPurpose"] as? String ?? "unknown") ?? PaymentPurpose.unknown
        transaction.purpose = paymentPurpose
        
        transaction.fromUserId = raw["fromUserId"] as? String ?? ""
        transaction.fromUsername = raw["fromUsername"] as? String ?? ""
        
        transaction.toUserId = raw["toUserId"] as? String ?? ""
        transaction.toUsername = raw["toUsername"] as? String ?? ""
        
        transaction.dishId = raw["dishId"] as? String
        transaction.dishName = raw["dishName"] as? String
        
        return transaction
    }
    
    // MARK: - Actions
    
    @IBAction func onAddToWallet(_ sender: UIButton) {
        
    }
    
    @IBAction func onSendMoneyToBank(_ sender: UIButton) {
        if let currentUser: MFUser = DatabaseGateway.sharedInstance.getLoggedInUser() {
            if currentUser.isStripeAccountVerified == true {
                FirebaseReference.stripeCustomers.classReference.child(currentUser.id).observeSingleEvent(of: .value, with: { (snapshot) in
                    DispatchQueue.main.async {
                        if let snapshot = snapshot.value as? [String:Any] {
                            if (snapshot["externalAccounts"] as? [String:Any]) != nil {
                                self.createPayout()
                            } else {
                                BankDetailsViewController.presentAddAccount(on: self) { (bankDetails) in
                                    self.createPayout()
                                }
                            }
                        } else {
                            self.showAlert("Error", message: "Could not fetch s_customer")
                        }
                    }
                })
            } else if currentUser.submittedForStripeVerification == true {
                self.showInProgressMessage()
            } else {
                self.applyForVerification()
            }
        }
    }
    
    @IBAction func onVerifyAccountTap(_ sender: UIButton) {
        if let currentUser: MFUser = DatabaseGateway.sharedInstance.getLoggedInUser() {
            if currentUser.isStripeAccountVerified == true {
                self.showAlert("Verified", message: "You are already a verified user. No need to do anything!")
            } else if currentUser.isStripeAccountVerified == false && currentUser.submittedForStripeVerification == false {
                self.applyForVerification()
            } else if currentUser.isStripeAccountVerified == false && currentUser.submittedForStripeVerification == true {
                self.showInProgressMessage()
            }
        }
    }
    
    func showInProgressMessage() {
        self.showAlert("In progress", message: "Your account verification is in progress. We will inform you when the process is completed. Thank you for your patience.")
    }
    
    func applyForVerification() {
        guard let currentUser: MFUser = DatabaseGateway.sharedInstance.getLoggedInUser() else {
            return
        }
        
        StripeVerificationViewController.presentStripeVerification(on: self) { (stripeSubmitted) in
            if stripeSubmitted == true {
                BankDetailsViewController.presentAddAccount(on: self) { (bankSubmitted) in
                    if bankSubmitted == true {
                        if currentUser.isStripeAccountVerified == true {
                            self.createPayout()
                        } else {
                            self.showAlert("Success", message: "Your account verification is in progress. We will inform you when the process is completed. Thank you for your patience.")
                        }
                    }
                }
            }
        }
    }
    
    func createPayout() {
        
    }
}

extension WalletViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : WalletTransactionsTblCell = tableView.dequeueReusableCell(withIdentifier: "WalletTransactionsTblCell", for: indexPath) as! WalletTransactionsTblCell
        cell.set(transaction: self.transactions[indexPath.item])
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

extension WalletViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.init(string: "No transactions", attributes: [NSFontAttributeName: UIFont.MontserratLight(with: 15)!])
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return self.tblTransactions.sectionHeaderHeight + 10
    }
    
}

