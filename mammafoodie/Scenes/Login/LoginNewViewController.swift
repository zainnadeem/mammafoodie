//
//  LoginNewViewController.swift
//  mammafoodie
//
//  Created by Sireesha V on 6/19/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class LoginNewViewController: UIViewController {

    @IBOutlet weak var userView: UIView!
    
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var loginButn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

        loginButn.layer.cornerRadius = 20
        loginButn.layer.borderWidth = 1
        loginButn.layer.borderColor = UIColor.clear.cgColor
        

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
    
//    override func viewWillAppear(_ animated : Bool) {
//        super.viewWillAppear(animated)
//        let colour1 =  UIColor(red: 255, green: 140, blue: 43, alpha: 1.0)
//        let colour2 =  UIColor(red: 255, green: 99, blue: 34, alpha: 1.0)
//
//        loginButn.applyGradient(colors: [colour1,colour2])
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
