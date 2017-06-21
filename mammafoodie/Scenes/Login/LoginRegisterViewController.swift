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
    @IBOutlet weak var viewNameIcon: UIView!
    
    @IBOutlet weak var viewPasswordIcon: UIView!
    @IBOutlet weak var viewEmailIcon: UIView!
    
    
    var shapeLayer: CAShapeLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
        
        nameTextFeild.layer.cornerRadius = 5
        nameTextFeild.layer.borderWidth = 1
        nameTextFeild.layer.borderColor = UIColor.clear.cgColor
        
        // let color: UIColor = #colorLiteral(red: 0.428863733, green: 0.6729379252, blue: 0.6100127551, alpha: 1)
        
        emailTextFeild.layer.cornerRadius = 5
        emailTextFeild.layer.borderWidth = 1
        emailTextFeild.layer.borderColor = UIColor.clear.cgColor
        
        passTextFeild.layer.cornerRadius = 5
        passTextFeild.layer.borderWidth = 1
        passTextFeild.layer.borderColor = UIColor.clear.cgColor
        
        
        registerBtn.layer.cornerRadius = 23
        registerBtn.layer.borderWidth = 1
        registerBtn.layer.borderColor = UIColor.clear.cgColor
        registerBtn.clipsToBounds = true
        
        nameTextFeild.delegate = self
        passTextFeild.delegate = self
        emailTextFeild.delegate = self
        
        self.nameTextFeild.leftView = self.viewNameIcon
        self.nameTextFeild.leftViewMode = .always
        
        self.emailTextFeild.leftView = self.viewEmailIcon
        self.emailTextFeild.leftViewMode = .always
        
        self.passTextFeild.leftView = self.viewPasswordIcon
        self.passTextFeild.leftViewMode = .always
        
        
        
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
    
    
    func updateShadow() {
        if self.shapeLayer == nil {
            self.self.registerBtn.superview?.layoutIfNeeded()
            self.shapeLayer = CAShapeLayer()
            self.shapeLayer.shadowColor = #colorLiteral(red: 1, green: 0.7725490196, blue: 0.6, alpha: 0.7041212248).cgColor
            self.shapeLayer.shadowOpacity = 70.0
            self.shapeLayer.shadowRadius = 7
            
            var shadowFrame: CGRect = self.registerBtn.frame
            shadowFrame.origin.x -= -35
            shadowFrame.origin.y += 17
            shadowFrame.size.width += -65
            shadowFrame.size.height -= 8
            
            self.shapeLayer.shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: self.registerBtn.layer.cornerRadius).cgPath
            self.shapeLayer.shadowOffset = CGSize(width: 0, height: 1)
            
            self.registerBtn.superview?.layer.insertSublayer(self.shapeLayer, at: 0)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateShadow()
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
