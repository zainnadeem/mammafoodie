
//
//  BankDetailsViewController.swift
//  mammafoodie
//
//  Created by Arjav Lad on 25/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import MBProgressHUD

typealias BankDetailsViewControllerCompletion = (Bool) -> Void
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
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        if let url = URL.init(string: "https://us-central1-mammafoodie-baf82.cloudfunctions.net/addExternalBankAccount") {
            if let currentUser = Auth.auth().currentUser {
                let parameters : Parameters = [
                    "accountHolderName" : self.txtAccountHolderName.text!,
                    "routingNumber" : self.txtRoutingNumber.text!,
                    "accountNumber" : self.txtAccountNumber.text!,
                    "userId": currentUser.uid
                ]
                Alamofire.request(url, method: .post, parameters: parameters).response(completionHandler: { (response) in
                    if let responseData = response.data {
                        let resp = String.init(data: responseData, encoding: String.Encoding.utf8)
                        DispatchQueue.main.async {
                            hud.hide(animated: true)
                            if resp?.lowercased() == "success" {
                                self.close(true)
//                                self.showAlert("Successful!", message: "")
                            } else {
                                self.close(false)
                                self.showAlert("Failed", message: "Please try again.")
                            }
                        }
                        print(resp ?? "No Response")
                    } else {
                        hud.hide(animated: true)
                        self.close(false)
                        self.showAlert("Failed", message: "Please try again.")
                    }
                })
            }
        } else {
            hud.hide(animated: true)
            self.close(false)
        }
    }
    
    func close(_ a: Bool) {
        self.dismiss(animated: true) {
            self.completion?(a)
        }
    }
    
    @IBAction func onCancelTap(_ sender: UIButton) {
        self.close(false)
    }
}
