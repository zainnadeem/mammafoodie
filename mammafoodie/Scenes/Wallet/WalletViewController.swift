//
//  WalletViewController.swift
//  mammafoodie
//
//  Created by Arjav Lad on 25/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {
    
    @IBOutlet var viewTableHeader: UIView!
    @IBOutlet weak var viewHeaderWrapper: UIView!
    @IBOutlet weak var btnAddToWallet: UIButton!
    @IBOutlet weak var btnSendMoneyToBank: UIButton!
    @IBOutlet weak var lblWalletBalanceTitle: UILabel!
    @IBOutlet weak var lblWalletBalance: UILabel!
    
    @IBOutlet weak var tblTransactions: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        self.tblTransactions.tableHeaderView = self.viewTableHeader
        self.viewHeaderWrapper.layer.cornerRadius = 5.0
        self.viewHeaderWrapper.clipsToBounds = true
        self.tblTransactions.rowHeight = 64
        self.tblTransactions.register(UINib.init(nibName: "WalletTransactionsTblCell", bundle: nil), forCellReuseIdentifier: "WalletTransactionsTblCell")
        self.setWalletAmount(0)
        self.btnAddToWallet.isHidden = true
        self.tblTransactions.reloadData()
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
    
    func setWalletAmount(_ amount : Double) {
        let formatter = NumberFormatter.init()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        self.lblWalletBalance.text = formatter.string(from: amount as NSNumber)
    }
    
    // MARK: - Actions
    
    @IBAction func onAddToWallet(_ sender: UIButton) {
        
    }
    
    @IBAction func onSendMoneyToBank(_ sender: UIButton) {
        StripeVerificationViewController.presentStripeVerification(on: self) { (verified) in
            
        }
//        BankDetailsViewController.presentAddAccount(on: self) { (bankDetails) in
//            
//        }
    }
    
    @IBAction func onBackTap(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension WalletViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : WalletTransactionsTblCell = tableView.dequeueReusableCell(withIdentifier: "WalletTransactionsTblCell", for: indexPath) as! WalletTransactionsTblCell
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
