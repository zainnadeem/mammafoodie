//
//  MFNavigationController.swift
//  mammafoodie
//
//  Created by Akshit Zaveri on 17/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class MFNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.layer.borderWidth = 0
    }
}
