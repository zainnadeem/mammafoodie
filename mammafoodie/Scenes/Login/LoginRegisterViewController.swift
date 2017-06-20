//
//  LoginRegisterViewController.swift
//  mammafoodie
//
//  Created by Sireesha V on 6/20/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class LoginRegisterViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var passImageView: UIImageView!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var nameImageView: UIImageView!
    @IBOutlet weak var nameTextFeild: UITextField!
    
    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var passTextFeild: UITextField!
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var nameViewBtn: UIView!
    @IBOutlet weak var userBtn: UIView!
    @IBOutlet weak var passwordBtn: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameViewBtn.layer.cornerRadius = 5
        nameViewBtn.layer.borderWidth = 1
        nameViewBtn.layer.borderColor = UIColor.clear.cgColor
        
        userBtn.layer.cornerRadius = 5
        userBtn.layer.borderWidth = 1
        userBtn.layer.borderColor = UIColor.clear.cgColor
        
        passwordBtn.layer.cornerRadius = 5
        passwordBtn.layer.borderWidth = 1
        passwordBtn.layer.borderColor = UIColor.clear.cgColor
        
        registerBtn.layer.cornerRadius = 23
        registerBtn.layer.borderWidth = 1
        registerBtn.layer.borderColor = UIColor.clear.cgColor
        registerBtn.clipsToBounds = true
        nameTextFeild.delegate = self
        passTextFeild.delegate = self
        emailTextFeild.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.registerBtn.applyGradient(colors: [gradientStartColor, gradientEndColor])
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if nameTextFeild == textField {
            nameImageView.image = UIImage(named: "nameclick")
        }
        if emailTextFeild == textField {
            emailImageView.image = UIImage(named: "selectuser")
        }
        if passTextFeild == textField {
        passImageView.image = UIImage(named: "passselect")
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

}
