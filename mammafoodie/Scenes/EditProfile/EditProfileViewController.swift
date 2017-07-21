//
//  EditProfileViewController.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 18/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import KLCPopup

class EditProfileViewController: UIViewController, EditAddressDelegate, HUDRenderer , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var btnEditPhoto: UIButton!
    
    @IBOutlet weak var txfName: UITextField!
    
    @IBOutlet weak var txfMobileNumber: UITextField!
    
    @IBOutlet weak var txfEmailID: UITextField!
    
    @IBOutlet weak var addressStackView: UIStackView!
    
    
    @IBOutlet var resetPasswordView: UIView!
    
    @IBOutlet weak var btnResetPasswordSave: UIButton!
    
    @IBOutlet weak var txfNewPassword: UITextField!
    
    @IBOutlet weak var txfConfirmPassword: UITextField!
    
    @IBOutlet weak var txvProfileDescription: UITextView!
    
    @IBOutlet weak var btnSave: UIButton!
    
    
    lazy var imagePicker = UIImagePickerController()
    
    var userID:String!
    
    var user:MFUser?
    
    var userAddresses = [MFUserAddress]()
    
    lazy var worker = EditProfileworker()
    
    var addingNewAddress:Bool!
    
    var KLCforgotPasswordPopup:KLCPopup?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userID = AppDelegate.shared().currentUserFirebase?.uid
        
        worker.getUserDataWith(userID: self.userID) { (user) in
            self.user = user
            self.txfName.text = user?.name
            self.txfEmailID.text = user?.email
            self.txfMobileNumber.text = user?.phone
            self.txvProfileDescription.text = user?.profileDescription
        }
        
        if let url = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: self.userID){
            self.profilePicImageView.sd_setImage(with: url, placeholderImage: UIImage(named:"IconMammaFoodie"))
        }
        

        //SetBack button image
        let backImage = UIImage(named:"BackBtn")?.withRenderingMode(.alwaysOriginal)
        
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        
        getUserAddress()
        
        
        self.btnSave.layer.cornerRadius = btnSave.frame.size.height/2
        btnSave.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let color1 = UIColor(red: 1, green: 0.55, blue: 0.17, alpha: 1)
        let color2 = UIColor(red: 1, green: 0.39, blue: 0.13, alpha: 1)
        btnSave.applyGradient(colors: [color1,color2])
        btnResetPasswordSave.layer.cornerRadius = btnResetPasswordSave.frame.size.height/2
        btnResetPasswordSave.applyGradient(colors: [color1,color2])
        btnResetPasswordSave.clipsToBounds = true
    }
    
    //MARK: - Change Address
    func getUserAddress(){
        showActivityIndicator()
        worker.getUserAddress(userID: self.userID) { (addressList) in
            
            self.hideActivityIndicator()
            if let addresses = addressList {
                self.userAddresses = addressList!
                
                for (i, address) in addresses.enumerated(){
                    
                    self.addAddressView(with: i, address: address)
                    
                }
            }
            
        }
    }
    
    func addressTapped(sender:UITapGestureRecognizer){
        
        let viewTag = sender.view!.tag
        
        addingNewAddress = false
        
        let address = self.userAddresses[viewTag]
        
        let addressEditVC = UIStoryboard(name: "Siri", bundle: nil).instantiateViewController(withIdentifier: "EditAddressViewController") as! EditAddressViewController
        addressEditVC.address = address
        addressEditVC.delegate = self
        
        self.navigationController?.pushViewController(addressEditVC, animated: true)
        
    }
    

    @IBAction func addNewAddressTapped(_ sender: UIButton) {
        
        
        addingNewAddress = true
        
        let addressEditVC = UIStoryboard(name: "Siri", bundle: nil).instantiateViewController(withIdentifier: "EditAddressViewController") as! EditAddressViewController
        addressEditVC.delegate = self
        
        self.navigationController?.pushViewController(addressEditVC, animated: true)

    }
    
    //Edit address delegate
    func editedAddress(address:MFUserAddress?){
        
        if let address = address {
            
            if addingNewAddress { //New address being added
                
                worker.createAddressForUser(userID: self.userID, address: address) { (status) in
                    
                //Remove all stackviews except its header
                    for subview in self.addressStackView.subviews where subview.tag != -1{
                        self.addressStackView.removeArrangedSubview(subview)
                        subview.removeFromSuperview()
                    }
                    self.getUserAddress()
                }
                
            } else { // edit existing address

                
                worker.updateAddress(addressID: address.id, address: address, { (status) in
                    for subview in self.addressStackView.subviews where subview.tag != -1 {
                        self.addressStackView.removeArrangedSubview(subview)
                        subview.removeFromSuperview()
                    }
                    self.getUserAddress()
                })
                
            }
        }
    }
    
    
    func addAddressView(with Tag:Int, address:MFUserAddress){
        
        let addressView = UINib(nibName: "AddressDisplayView", bundle: nil).instantiate(withOwner: AddressDisplayView.self, options: nil).first as! AddressDisplayView
        addressView.tag = Tag
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.addressTapped(sender:)))
        addressView.addGestureRecognizer(tap)
        
        addressView.lblAddress.text = address.description
        self.addressStackView.addArrangedSubview(addressView)
    }
    
    //MARK: - Change Password
    @IBAction func changePasswordTapped(_ sender: UIButton) {
        
        let resetPasswordVC = self.resetPasswordView
        resetPasswordVC?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width - 40, height: 270)
        
        
        KLCforgotPasswordPopup = KLCPopup.init(contentView: resetPasswordVC, showType: .bounceInFromTop , dismissType: .bounceOutToTop , maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        
        KLCforgotPasswordPopup?.show(atCenter:CGPoint(x: self.view.center.x, y: self.view.center.y - 135) , in: self.view)
        
        
//        txfForgotPassword.text = txtEmail.text
//        txfForgotPassword.becomeFirstResponder()
        
    }
    
    
    
    @IBAction func resetPasswordSaveButtonTapped(_ sender: UIButton) {
        
        
        
        guard txfNewPassword.text == txfConfirmPassword.text else {
            KLCforgotPasswordPopup?.dismiss(true)
            showAlert(message: "Confirm password did not match with the new password.")
            return
        }
        
        guard txfConfirmPassword.text!.characters.count >= 6  else {
            KLCforgotPasswordPopup?.dismiss(true)
            showAlert(message: "A minimum of 6 characters is required for the password.")
            return
        }
        
        showActivityIndicator()
        
        let worker = FirebaseLoginWorker()
        let credential = Login.Credentials(email: "", password: txfConfirmPassword.text!)
        
        worker.updatePassword(with: credential) { (errorMessage) in
            
           self.hideActivityIndicator()
            self.KLCforgotPasswordPopup?.dismiss(true)
            
            if errorMessage != nil {
                self.showAlert(message: errorMessage!)
            }
        }
        
        
    }
    
    
    @IBAction func saveTapped(_ sender: UIButton) {
        
        
        showActivityIndicator()
        
         user?.name = self.txfName.text
         user?.email = self.txfEmailID.text
         user?.phone = self.txfMobileNumber.text!
         user?.profileDescription = self.txvProfileDescription.text
        
        
        worker.updateUser(user: self.user!) { (status) in
            self.hideActivityIndicator()
            
            if status {
                self.showAlert(message: "Profile updated successfully")
            } else {
                self.showAlert(message: "Something went wrong. Please try again.")
            }
            
        }
        
        
    }
    
    //MARK: - Edit photo
    @IBAction func editPhotoTapped(_ sender: UIButton) {
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
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
    
    //MARK: - Picker delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.profilePicImageView.image = image
        
        worker.uploadProfileImage(userID: self.userID, image: image) { (status) in
            print(status)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

}
