//
//  EditProfileViewController.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 18/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var btnEditPhoto: UIButton!
    
    @IBOutlet weak var txfName: UITextField!
    
    @IBOutlet weak var txfMobileNumber: UITextField!
    
    @IBOutlet weak var txfEmailID: UITextField!
    
    @IBOutlet weak var addressStackView: UIStackView!
    
    lazy var imagePicker = UIImagePickerController()
    
    var userID:String!
    
    var user:MFUser?
    
    var userAddresses = [MFUserAddress]()
    
    lazy var worker = EditProfileworker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        worker.getUserDataWith(userID: self.userID) { (user) in
//            self.user = user
//            self.txfName.text = user?.name
//            self.txfEmailID.text = user?.email
//            self.txfMobileNumber.text = user?.phone
//        }
//        
//        if let url = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: self.userID){
//            self.profilePicImageView.sd_setImage(with: url, placeholderImage: UIImage(named:"IconMammaFoodie"))
//        }
//        
//        
//        worker.getUserAddress(userID: self.userID) { (addressList) in
//            if let addresses = addressList {
//                self.userAddresses = addressList!
//                
//                for (i, address) in addresses.enumerated(){
//                    
//                    let addressView = UINib(nibName: "AddressDisplayView", bundle: nil).instantiate(withOwner: AddressDisplayView.self, options: nil).first as! AddressDisplayView
//                    addressView.tag = i
//                    
//                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.addressTapped(sender:)))
//                    addressView.addGestureRecognizer(tap)
//                    
//                    addressView.lblAddress.text = address.description
//                    self.addressStackView.addArrangedSubview(addressView)
//                    
//                }
//            }
//            
//        }
        
        for i in 0..<2 {
            
                                let addressView = UINib(nibName: "AddressDisplayView", bundle: nil).instantiate(withOwner: AddressDisplayView.self, options: nil).first as! AddressDisplayView
                                addressView.tag = i
            
                                let tap = UITapGestureRecognizer(target: self, action: #selector(self.addressTapped(sender:)))
                                addressView.addGestureRecognizer(tap)
            
                                addressView.lblAddress.text = i.description
                                self.addressStackView.addArrangedSubview(addressView)
                                
                            }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addressTapped(sender:UITapGestureRecognizer){
        
        let view = sender.view
        
        print(view?.tag)
        
    }
    

    @IBAction func addNewAddressTapped(_ sender: UIButton) {
        
    }
    
    
    @IBAction func changePasswordTapped(_ sender: UIButton) {
        
    }
    
    
    @IBAction func saveTapped(_ sender: UIButton) {
        
    }
    
    
    @IBAction func editPhotoTapped(_ sender: UIButton) {
        
        
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }

}
