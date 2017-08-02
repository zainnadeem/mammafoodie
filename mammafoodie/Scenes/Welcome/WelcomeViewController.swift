
//
//  WelcomeViewController.swift
//  mammafoodie
//
//  Created by Arjav Lad on 01/08/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import SafariServices

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLearnMore: UIButton!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var stackViewButtonContainer: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageViewMammaFoodie: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var collectionViewImages: UICollectionView!
    
    var infiniteCollectionViewAdapter: InfiniteCollectionViewAdapter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.btnLearnMore.layer.cornerRadius = 5.0
        self.btnLearnMore.clipsToBounds = true
        
        self.btnLogin.layer.cornerRadius = 5.0
        self.btnRegister.layer.cornerRadius = 5.0
        
        self.infiniteCollectionViewAdapter = InfiniteCollectionViewAdapter.init(with: self.collectionViewImages)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.btnLearnMore.applyGradient(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.infiniteCollectionViewAdapter.startScrolling()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.infiniteCollectionViewAdapter.stopScrolling()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.btnLogin.addGradienBorder(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight, borderWidth: 1.0, animated: true, animationDuration: 1.0)
        self.btnRegister.addGradienBorder(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight, borderWidth: 1.0, animated: true, animationDuration: 1.0)
        
        self.viewContainer.layer.shadowColor = UIColor.white.cgColor
        self.viewContainer.layer.shadowRadius = 4.0
        self.viewContainer.layer.shadowOffset = CGSize(width: 1, height: -20)
        self.viewContainer.layer.shadowOpacity = 1.0
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func openLink(_ link: String) {
        if let url = URL.init(string: link) {
            let safariVC = SFSafariViewController.init(url: url, entersReaderIfAvailable: false)
            safariVC.preferredBarTintColor = .white
            safariVC.preferredControlTintColor = #colorLiteral(red: 1, green: 0.4745098039, blue: 0.1529411765, alpha: 1)
            self.present(safariVC, animated: true, completion: { 
                
            })
        } else {
            assert(false, "URL \"\(link)\" is invalid")
        }
    }
    
    @IBAction func onLearnMoreTap(_ sender: UIButton) {
        self.openLink("http://mammafoodie.com")
    }
    
    @IBAction func onLoginTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "seguePresentLogin", sender: self)
    }
    
    @IBAction func onRegisterTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "seguePresentRegister", sender: self)
    }
    
    @IBAction func onTermsTap(_ sender: UIButton) {
        self.openLink("http://mammafoodie.com")
    }
}
