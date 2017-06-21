//
//  LoginNewViewController.swift
//  mammafoodie
//
//  Created by Sireesha V on 6/19/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

let gradientStartColor : UIColor = UIColor.init(red: 1.0, green: 0.39, blue: 0.13, alpha: 1.0)
let gradientEndColor : UIColor = UIColor.init(red: 1.0, green: 0.55, blue: 0.17, alpha: 1.0)

class LoginNewViewController: UIViewController, UITextFieldDelegate {
    
    var shapeLayer: CAShapeLayer!

    @IBOutlet weak var passImageView: UIImageView!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userView: UIView!
    
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var loginButn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        self.loginButn.layer.cornerRadius = 23
        self.loginButn.clipsToBounds = true
        userView.layer.cornerRadius = 5
        userView.layer.borderWidth = 1
        userView.layer.borderColor = UIColor.clear.cgColor
        
        passwordView.layer.cornerRadius = 5
        passwordView.layer.borderWidth = 1
        passwordView.layer.borderColor = UIColor.clear.cgColor
        passwordTextField.delegate = self
        emailTextField.delegate = self
    }
    
    
    func updateShadow() {
        if self.shapeLayer == nil {
            self.self.loginButn.superview?.layoutIfNeeded()
            self.shapeLayer = CAShapeLayer()
            self.shapeLayer.shadowColor = #colorLiteral(red: 1, green: 0.7725490196, blue: 0.6, alpha: 0.7041212248).cgColor
            self.shapeLayer.shadowOpacity = 70.0
            self.shapeLayer.shadowRadius = 7
            
            var shadowFrame: CGRect = self.loginButn.frame
            shadowFrame.origin.x -= -30
            shadowFrame.origin.y += 17
            shadowFrame.size.width += -60
            shadowFrame.size.height -= 8
            
            self.shapeLayer.shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: self.loginButn.layer.cornerRadius).cgPath
            self.shapeLayer.shadowOffset = CGSize(width: 0, height: 1)
            
            self.loginButn.superview?.layer.insertSublayer(self.shapeLayer, at: 0)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateShadow()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.loginButn.applyGradient(colors: [gradientStartColor, gradientEndColor])
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if emailTextField == textField {
            emailImageView.image = UIImage(named: "selectuser")
        }
        if passwordTextField == textField {
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


