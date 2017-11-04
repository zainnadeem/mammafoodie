//
//  EditProfileViewController.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 18/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import KLCPopup
import MBProgressHUD

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
    var userID: String!
    var user: MFUser?
    var userAddresses = [MFUserAddress]()
    lazy var worker = EditProfileworker()
    var addingNewAddress: Bool!
    var KLCforgotPasswordPopup: KLCPopup?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = DatabaseGateway.sharedInstance.getLoggedInUser() {
            self.userID = user.id
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        self.profilePicImageView.contentMode = .scaleAspectFit
        self.worker.getUserDataWith(userID: self.userID) { (user) in
            self.user = user
            self.txfName.text = user?.name
            self.txfEmailID.text = user?.email
            self.txfMobileNumber.text = user?.phone.phone
            self.txvProfileDescription.text = user?.profileDescription
        }

        self.profilePicImageView.sd_setImage(with: DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: self.userID), placeholderImage: #imageLiteral(resourceName: "IconMammaFoodie"))
        
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "BackBtn")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "BackBtn")
        
        self.getUserAddress()
        self.btnSave.layer.cornerRadius = btnSave.frame.size.height/2
        self.btnSave.clipsToBounds = true
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
    func getUserAddress() {
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
    
    func addressTapped(sender: UITapGestureRecognizer) {
        let viewTag = sender.view!.tag
        self.addingNewAddress = false
        let address = self.userAddresses[viewTag]
        let addressEditVC = UIStoryboard(name: "Siri", bundle: nil).instantiateViewController(withIdentifier: "EditAddressViewController") as! EditAddressViewController
        addressEditVC.address = address
        addressEditVC.delegate = self
        self.navigationController?.pushViewController(addressEditVC, animated: true)
        
    }
    
    //Edit address delegate
    func editedAddress(address:MFUserAddress?) {
        if let address = address {
            self.user?.phone.phone = address.phone
            self.user?.phone.countryCode = "+1"
            self.user?.addressDetails = address
            DatabaseGateway.sharedInstance.updateUserEntity(with: self.user!, { (error) in
                for subview in self.addressStackView.subviews where subview.tag != -1 {
                    self.addressStackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                }
                self.getUserAddress()
            })
        }
    }
    
    func addAddressView(with Tag:Int, address:MFUserAddress) {
        let addressView = UINib(nibName: "AddressDisplayView", bundle: nil).instantiate(withOwner: AddressDisplayView.self, options: nil).first as! AddressDisplayView
        addressView.tag = Tag
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.addressTapped(sender:)))
        addressView.addGestureRecognizer(tap)
        addressView.lblAddress.text = address.description
        self.addressStackView.addArrangedSubview(addressView)
    }
    
    //MARK: - Change Password
    @IBAction func addNewAddressTapped(_ sender: UIButton) {
        self.addingNewAddress = true
        let addressEditVC = UIStoryboard(name: "Siri", bundle: nil).instantiateViewController(withIdentifier: "EditAddressViewController") as! EditAddressViewController
        addressEditVC.delegate = self
        self.navigationController?.pushViewController(addressEditVC, animated: true)
        
    }
    
    @IBAction func changePasswordTapped(_ sender: UIButton) {
        let resetPasswordVC = self.resetPasswordView
        resetPasswordVC?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width - 40, height: 270)
        KLCforgotPasswordPopup = KLCPopup.init(contentView: resetPasswordVC, showType: .bounceInFromTop , dismissType: .bounceOutToTop , maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        KLCforgotPasswordPopup?.show(atCenter:CGPoint(x: self.view.center.x, y: self.view.center.y - 135) , in: self.view)
        
    }
    
    @IBAction func resetPasswordSaveButtonTapped(_ sender: UIButton) {
        guard txfNewPassword.text == txfConfirmPassword.text else {
            KLCforgotPasswordPopup?.dismiss(true)
            self.showAlert(message: "Confirm password did not match with the new password.")
            return
        }
        guard txfConfirmPassword.text!.count >= 6  else {
            KLCforgotPasswordPopup?.dismiss(true)
            self.showAlert(message: "A minimum of 6 characters is required for the password.")
            return
        }
        
        self.showActivityIndicator()
        let worker = FirebaseLoginWorker()
        let credential = Login.Credentials(email: "", password: txfConfirmPassword.text!)
        worker.updatePassword(with: credential) { (errorMessage) in
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                self.KLCforgotPasswordPopup?.dismiss(true)
                if errorMessage != nil {
                    self.showAlert(message: errorMessage!)
                }
            }
        }
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.user?.name = self.txfName.text
        self.user?.email = self.txfEmailID.text
        self.user?.phone.countryCode = "+1"
        self.user?.phone.phone = self.txfMobileNumber.text ?? ""
        self.user?.profileDescription = self.txvProfileDescription.text
        self.worker.updateUser(user: self.user!) { (status) in
            DispatchQueue.main.async {
                hud.hide(animated: true)
                if status {
                    self.showAlert("Profile Updated!", message: "")
                } else {
                    self.showAlert("Error!", message: "Something went wrong. Please try again.")
                }
            }
        }
    }
    
    //MARK: - Edit photo
    @IBAction func editPhotoTapped(_ sender: UIButton) {
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = false
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        alert.popoverPresentationController?.sourceView = sender
        alert.popoverPresentationController?.sourceRect = sender.bounds
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.imagePicker.allowsEditing = true
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func changeImage(_ image: UIImage) {
        let hud = MBProgressHUD.showAdded(to: self.profilePicImageView, animated: true)
        self.profilePicImageView.image = image
        self.worker.uploadProfileImage(userID: self.userID, image: image) { (status) in
            DispatchQueue.main.async {
                hud.hide(animated: true)
                if !status {
                    self.showAlert("Error!", message: "Profile Image upload failed!")
                }
            }
        }
    }
    
    //MARK: - Picker delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.changeImage(editedImage)
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.changeImage(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
