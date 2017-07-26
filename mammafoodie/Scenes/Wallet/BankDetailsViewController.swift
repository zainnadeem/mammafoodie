
//
//  BankDetailsViewController.swift
//  mammafoodie
//
//  Created by Arjav Lad on 25/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

typealias BankDetailsViewControllerCompletion = (BankDetails?) -> Void

class BankDetailsViewController: UIViewController {
    
    @IBOutlet weak var txtAccountHolderName: UITextField!
    @IBOutlet weak var txtAccountNumber: UITextField!
    @IBOutlet weak var txtRoutingNumber: UITextField!
    
    @IBOutlet weak var btnAddAccount: UIButton!
    
    var completion : BankDetailsViewControllerCompletion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        self.modalPresentationCapturesStatusBarAppearance = true
        
        self.btnAddAccount.layer.cornerRadius = 5.0
        self.btnAddAccount.clipsToBounds = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.btnAddAccount.applyGradient(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func presentAddAccount(on vc : UIViewController, completion : @escaping BankDetailsViewControllerCompletion) {
        let story = UIStoryboard.init(name: "Wallet", bundle: nil)
        if let bankDetailsVC = story.instantiateViewController(withIdentifier: "BankDetailsViewController") as? BankDetailsViewController {
            bankDetailsVC.completion = completion
            bankDetailsVC.modalPresentationStyle = .overFullScreen
            bankDetailsVC.modalPresentationCapturesStatusBarAppearance = true
            bankDetailsVC.modalTransitionStyle = .crossDissolve
            vc.present(bankDetailsVC, animated: true, completion: {
                
            })
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func onAddAccountTap(_ sender: UIButton) {
        self.completion?(nil)
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func onCancelTap(_ sender: UIButton) {
        self.completion?(nil)
        self.dismiss(animated: true) {
            
        }
    }
}

struct BankDetails {
    let accountNumber : String
    let accountHolderName : String
    let routingNumber : String
}
