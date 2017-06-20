//
//  LoginNewViewController.swift
//  mammafoodie
//
//  Created by Sireesha V on 6/19/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

let gradientStartColor : UIColor = UIColor.init(red: 1.0, green: 0.55, blue: 0.17, alpha: 1.0)
let gradientEndColor : UIColor = UIColor.init(red: 1.0, green: 0.39, blue: 0.13, alpha: 1.0)

class LoginNewViewController: UIViewController {
    
    @IBOutlet weak var userView: UIView!
    
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var loginButn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        self.loginButn.layer.cornerRadius = 22
        self.loginButn.clipsToBounds = true
        userView.layer.cornerRadius = 5
        userView.layer.borderWidth = 1
        userView.layer.borderColor = UIColor.clear.cgColor
        
        passwordView.layer.cornerRadius = 5
        passwordView.layer.borderWidth = 1
        passwordView.layer.borderColor = UIColor.clear.cgColor
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.loginButn.applyGradient(colors: [gradientStartColor, gradientEndColor])
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
