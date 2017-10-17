//
//  StripeVerificationViewController.swift
//  mammafoodie
//
//  Created by Arjav Lad on 26/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import Firebase
import MBProgressHUD

typealias StripeVerificationCompletion = (Bool) -> Void

class StripeVerificationViewController: UIViewController {
    
    @IBOutlet weak var stackViewMain: UIStackView!
    @IBOutlet weak var lblVerificationDueDate: UILabel!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtAddressLine1: UITextField!
    @IBOutlet weak var txtAddressLine2: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtPostalCode: UITextField!
    @IBOutlet weak var txtSSN: UITextField!
    @IBOutlet weak var txtFullSSN: UITextField!
    
    @IBOutlet weak var stackViewBankAccount: UIStackView!
    @IBOutlet weak var txtAccountHolderName: UITextField!
    @IBOutlet weak var txtAccountNumber: UITextField!
    @IBOutlet weak var txtRoutingNumber: UITextField!
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnUploadDocument: UIButton!
    
    @IBOutlet var pickerDOB: UIDatePicker!
    
    @IBOutlet var allTextFields: [UITextField]!
    
    var completion : StripeVerificationCompletion?
    var imagePicker : UIImagePickerController = UIImagePickerController.init()
    var isDocumentUploaded : Bool = false
    var documentID : String?
    var documentImage: UIImage? = nil
    var hud: MBProgressHUD?
    
    @IBOutlet weak var viewFirstName: UIView!
    @IBOutlet weak var viewLastName: UIView!
    @IBOutlet weak var viewDOB: UIView!
    @IBOutlet weak var viewAddress1: UIView!
    @IBOutlet weak var viewAddress2: UIView!
    @IBOutlet weak var viewCity: UIView!
    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var viewCountry: UIView!
    @IBOutlet weak var viewPostalCode: UIView!
    @IBOutlet weak var viewSSN: UIView!
    @IBOutlet weak var viewSSNFull: UIView!
    @IBOutlet weak var viewDocument: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.txtDOB.inputView = self.pickerDOB
        self.txtSSN.delegate = self
        self.btnSubmit.layer.cornerRadius = 5.0
        self.btnSubmit.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let stripeVerification: StripeVerification = AppDelegate.shared().currentUser?.stripeVerification {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            self.stackViewMain.isHidden = true
            self.isBalanceMoreThanZero({ (isBalanceMoreThanZero) in
                hud.hide(animated: true)
                self.lblVerificationDueDate.text = "Verification due by: \(stripeVerification.dueBy?.toString(dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none) ?? "N.A")"
                
                let fields_needed: [String] = stripeVerification.fields_needed
                self.viewFirstName.isHidden = !fields_needed.contains(StripeVerification.VerificationFields.firstName.rawValue)
                self.viewLastName.isHidden = !fields_needed.contains(StripeVerification.VerificationFields.lastName.rawValue)
                self.viewDOB.isHidden = !fields_needed.contains(StripeVerification.VerificationFields.dobDay.rawValue)
                self.viewAddress1.isHidden = !fields_needed.contains(StripeVerification.VerificationFields.address.rawValue)
                self.viewAddress2.isHidden = !fields_needed.contains(StripeVerification.VerificationFields.address.rawValue)
                self.viewCity.isHidden = !fields_needed.contains(StripeVerification.VerificationFields.city.rawValue)
                self.viewState.isHidden = !fields_needed.contains(StripeVerification.VerificationFields.state.rawValue)
                self.viewCountry.isHidden = true // We have the country fixed as US for now
                self.viewPostalCode.isHidden = !fields_needed.contains(StripeVerification.VerificationFields.postal.rawValue)
                self.viewSSN.isHidden = !fields_needed.contains(StripeVerification.VerificationFields.ssnLast4.rawValue)
                self.viewSSNFull.isHidden = !fields_needed.contains(StripeVerification.VerificationFields.ssnFull.rawValue)
                self.viewDocument.isHidden = !fields_needed.contains(StripeVerification.VerificationFields.document.rawValue)
                self.stackViewBankAccount.isHidden = !(isBalanceMoreThanZero == true && fields_needed.contains(StripeVerification.VerificationFields.externalAccount.rawValue))
                
                self.stackViewMain.isHidden = false
            })
        }
    }
    
    func isBalanceMoreThanZero(_ completion: @escaping (Bool)->Void) {
        if let currentUser = Auth.auth().currentUser {
            FirebaseReference.stripeCustomers.classReference.child(currentUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let account = snapshot.value as? [String : Any] {
                    if let accountID = account["account_id"] as? String {
                        if let url = URL.init(string: "https://us-central1-mammafoodie-baf82.cloudfunctions.net/retreiveBalance") {
                            let params : Parameters = ["accountId" : accountID]
                            Alamofire.request(url, method: .get, parameters: params).responseJSON(completionHandler: { (response) in
                                DispatchQueue.main.async {
                                    if let jsonResponse = response.result.value as? [String : Any] {
                                        let available = jsonResponse["available"] as? Double ?? 0
                                        let pending = jsonResponse["pending"] as? Double ?? 0
                                        if available > 0 || pending > 0 {
                                            completion(true)
                                        } else {
                                            completion(false)
                                        }
                                    } else {
                                        completion(false)
                                    }
                                }
                            })
                        }
                    }
                }
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.btnSubmit.applyGradient(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight)
        self.btnUploadDocument.addGradienBorder(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight, borderWidth: 1, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func presentStripeVerification(on vc : UIViewController, completion : @escaping StripeVerificationCompletion) {
        let story = UIStoryboard.init(name: "Wallet", bundle: nil)
        if let stripeVerificationVC = story.instantiateViewController(withIdentifier: "StripeVerificationViewController") as? StripeVerificationViewController {
            stripeVerificationVC.completion = completion
            stripeVerificationVC.modalPresentationStyle = .overFullScreen
            stripeVerificationVC.modalPresentationCapturesStatusBarAppearance = true
            stripeVerificationVC.modalTransitionStyle = .crossDissolve
            vc.present(stripeVerificationVC, animated: true, completion: {
                
            })
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
    
    func uploadDocumentToStripe(_ documentImage : UIImage, completion : @escaping (String?) -> Void) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.isDocumentUploaded = false
        let headers: HTTPHeaders = ["Authorization" : "Bearer sk_test_ILoBhJpbX4bmuygd0NQs23V5"]
        if let url = URL.init(string: "https://uploads.stripe.com/v1/files"),
            let imageData = UIImageJPEGRepresentation(documentImage, 0.5),
            let purpose = "identity_document".data(using: String.Encoding.utf8) {
            Alamofire.upload(multipartFormData: { (formData) in
                formData.append(purpose, withName: "purpose")
                formData.append(imageData, withName: "file", fileName: "image", mimeType: "image/png")
            }, to: url, headers : headers) { (result) in
                DispatchQueue.main.async {
                    hud.hide(animated: true)
                    switch result {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            print(response.result)
                            if let jsonResponse = response.result.value as? [String : Any] {
                                completion((jsonResponse["id"] as? String) ?? nil)
                            } else {
                                completion(nil)
                            }
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        completion(nil)
                    }
                }
            }
        } else {
            hud.hide(animated: true)
            completion(nil)
            print("This should not happen")
        }
    }
    
    func finished(_ finished : Bool) {
        self.dismiss(animated: true) {
            self.completion?(finished)
        }
    }
    
    func setDate() {
        let date = self.pickerDOB.date
        let formatter = DateFormatter.init()
        formatter.dateFormat = "MM/dd/yyyy"
        self.txtDOB.text = formatter.string(from: date)
    }
    
    @IBAction func onUploadDocumentTap(_ sender: UIButton) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.mediaTypes = [kUTTypeImage as String]
        self.imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePicker.sourceType = .camera
        } else {
            self.imagePicker.sourceType = .photoLibrary
        }
        self.present(self.imagePicker, animated: true) {
            
        }
    }
    
    @IBAction func onCancelTap(_ sender: UIButton) {
        self.finished(false)
    }
    
    @IBAction func onSubmiTap(_ sender: UIButton) {

        let validationResult = self.areFieldsValid()
        if validationResult.0 == true {
            self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            if !self.viewDocument.isHidden {
                if let documentImage = self.documentImage {
                    self.uploadDocumentToStripe(documentImage, completion: { (fileID) in
                        DispatchQueue.main.async {
                            self.isDocumentUploaded = (fileID != nil)
                            self.documentID = fileID
                            if self.isDocumentUploaded {
                                self.submitVerificationDetails()
                            } else {
                                self.showAlert("Error", message: "Document upload failed. Please try again.")
                            }
                        }
                    })
                }
            } else {
                self.submitVerificationDetails()
            }
        } else {
            self.showAlert("Error", message: validationResult.1)
        }
    }
    
    func areFieldsValid() -> (Bool, String) {
        
        if !self.viewFirstName.isHidden {
            if self.txtFirstName.text?.characters.count ?? 0 == 0 {
                return (false, "Please enter first name.")
            }
        }
        
        if !self.viewLastName.isHidden {
            if self.txtLastName.text?.characters.count ?? 0 == 0 {
                return (false, "Please enter last name.")
            }
        }
        
        if !self.viewDOB.isHidden {
            if self.txtDOB.text?.characters.count ?? 0 == 0 {
                return (false, "Please select your birthday.")
            }
        }
        
        if !self.viewAddress1.isHidden {
            if self.txtAddressLine1.text?.characters.count ?? 0 == 0 {
                return (false, "Please enter your address.")
            }
        }
        
        if !self.viewAddress2.isHidden {
            // Optional
        }
        
        if !self.viewCity.isHidden {
            if self.txtCity.text?.characters.count ?? 0 == 0 {
                return (false, "Please enter your city.")
            }
        }
        
        if !self.viewState.isHidden {
            if self.txtState.text?.characters.count ?? 0 == 0 {
                return (false, "Please enter your state.")
            }
        }
        
        if !self.viewCountry.isHidden {
            // Fixed - US
        }
        
        if !self.viewPostalCode.isHidden {
            if self.txtPostalCode.text?.characters.count ?? 0 == 0 {
                return (false, "Please enter postal code.")
            }
        }
        
        if !self.viewSSN.isHidden {
            if self.txtSSN.text?.characters.count ?? 0 == 0 {
                return (false, "Please enter last 4 digits of SSN.")
            }
        }
        
        if !self.viewSSNFull.isHidden {
            if self.txtFullSSN.text?.characters.count ?? 0 == 0 {
                return (false, "Please enter your SSN.")
            }
        }
        
        if !self.viewDocument.isHidden {
            return (self.isDocumentUploaded, "Please upload the verification document.")
        }
        
//        if !self.stackViewBankAccount.isHidden {
//            if self.txtAccountHolderName.text?.characters.count ?? 0 == 0 {
//                return (false, "Please enter bank account holder name.")
//            }
//            if self.txtAccountNumber.text?.characters.count ?? 0 == 0 {
//                return (false, "Please enter your bank account number.")
//            }
//            if self.txtRoutingNumber.text?.characters.count ?? 0 == 0 {
//                return (false, "Please enter bank routing number.")
//            }
//        }
        
        if Auth.auth().currentUser == nil {
           return (false, "You are not logged in.")
        }
        
        return (true, "")
    }
    
    func submitVerificationDetails() {
        if let url = URL.init(string: "https://us-central1-mammafoodie-baf82.cloudfunctions.net/verifyStripeAccount") {
            let parameters : Parameters = self.getParametersToSubmitForVerification()
            Alamofire.request(url, method: .post, parameters: parameters).response(completionHandler: { (response) in
                if let responseData = response.data {
                    let resp = String.init(data: responseData, encoding: String.Encoding.utf8)
                    DispatchQueue.main.async {
                        self.hud?.hide(animated: true)
                        if resp?.lowercased() == "success" {
                            AppDelegate.shared().removeNotificationForStripeVerificationReminder()
                            self.finished(true)
                            self.showAlert("Thank you", message: "Your details are submitted for verification.")
                        } else {
                            self.finished(false)
                            self.showAlert("Sorry", message: "Your request could not be submitted. Please try again.")
                        }
                    }
                    print(resp ?? "No Response")
                } else {
                    self.hud?.hide(animated: true)
                    self.finished(false)
                    self.showAlert("Verification Failed!", message: "")
                }
            })
        } else {
            self.hud?.hide(animated: true)
        }
    }
    
    func getParametersToSubmitForVerification() -> Parameters {
        
        var details: [String:Any] = [:]

        if let currentUser = Auth.auth().currentUser {
            details["userId"] = currentUser.uid
        }
        
        if !self.viewFirstName.isHidden {
            details["first_name"] = self.txtFirstName.text ?? ""
        }
        
        if !self.viewLastName.isHidden {
            details["last_name"] = self.txtLastName.text ?? ""
        }
        
        if !self.viewDOB.isHidden {
            let date = self.pickerDOB.date
            details["dob_day"] = date.component(.day) ?? 0
            details["dob_month"] = date.component(.month) ?? 0
            details["dob_year"] = date.component(.year) ?? 0
        }
        
        if !self.viewAddress1.isHidden {
            details["line1"] = self.txtAddressLine1.text ?? ""
        }
        
        if !self.viewAddress2.isHidden {
            details["line2"] = self.txtAddressLine2.text ?? ""
        }
        
        if !self.viewCity.isHidden {
            details["city"] = self.txtCity.text ?? ""
        }
        
        if !self.viewState.isHidden {
            details["state"] = self.txtState.text ?? ""
        }
        
        if !self.viewCountry.isHidden {
            // Fixed from Firebase function - US
        }
        
        if !self.viewPostalCode.isHidden {
            details["postal_code"] = self.txtPostalCode.text ?? ""
        }
        
        if !self.viewSSN.isHidden {
            details["ssn_last_4"] = self.txtSSN.text ?? ""
        }
        
        if !self.viewSSNFull.isHidden {
            details["ssn"] = self.txtFullSSN.text ?? ""
        }
        
        if !self.viewDocument.isHidden {
            details["documentId"] = self.documentID ?? ""
        }
        
        if !self.stackViewBankAccount.isHidden {
            if self.txtAccountHolderName.text?.characters.count ?? 0 > 0 && self.txtAccountNumber.text?.characters.count ?? 0 > 0 && self.txtRoutingNumber.text?.characters.count ?? 0 > 0 {
                details["accountHolderName"] = self.txtAccountHolderName.text!
                details["accountNumber"] = self.txtAccountNumber.text!
                details["routingNumber"] = self.txtRoutingNumber.text!
            }
        }
        
        return details
    }
    
    @IBAction func onDOBChnage(_ sender: UIDatePicker) {
        self.setDate()
    }
    
    @IBAction func onReadTermsOfServiceTap(_ sender: UIButton) {
        
    }
}

extension StripeVerificationViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.documentImage = originalImage
            //            if let data: Data = UIImageJPEGRepresentation(originalImage, 0.5) {
            //                let bcf = ByteCountFormatter()
            //                bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
            //                bcf.countStyle = .file
            //                let string = bcf.string(fromByteCount: Int64(data.count))
            //                print("Length of the image: \(string)")
            //            }
        }
        picker.dismiss(animated: true) {
            
        }
    }
}

extension StripeVerificationViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtDOB {
            self.setDate()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtSSN {
            if let text = textField.text {
                let final = (text as NSString).replacingCharacters(in: range, with: string)
                if final.characters.count > 4 {
                    return false
                }
            }
            return true
        }
        return true
    }
}
