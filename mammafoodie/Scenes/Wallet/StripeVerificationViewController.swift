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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.txtDOB.inputView = self.pickerDOB
        self.txtSSN.delegate = self
        self.btnSubmit.layer.cornerRadius = 5.0
        self.btnSubmit.clipsToBounds = true
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
        self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        if let documentImage = self.documentImage {
            self.uploadDocumentToStripe(documentImage, completion: { (fileID) in
                DispatchQueue.main.async {
                    self.isDocumentUploaded = (fileID != nil)
                    self.documentID = fileID
                    self.submitVerificationDetails()
                }
            })
        }
    }
    
    func submitVerificationDetails() {
        if self.isDocumentUploaded  {
            if let docID = self.documentID,
                let currentUser = Auth.auth().currentUser {
                if let url = URL.init(string: "https://us-central1-mammafoodie-baf82.cloudfunctions.net/verifyStripeAccount") {
                    let date = self.pickerDOB.date
                    let parameters : Parameters = [
                        "dob_day" : date.component(.day) ?? 0,
                        "dob_month" : date.component(.month) ?? 0,
                        "dob_year" : date.component(.year) ?? 0,
                        "first_name" : self.txtFirstName.text!,
                        "last_name" : self.txtLastName.text!,
                        "city" : self.txtCity.text!,
                        "line1" : self.txtAddressLine1.text!,
                        "line2" : self.txtAddressLine2.text!,
                        "postal_code" : self.txtPostalCode.text!,
                        "state" : self.txtState.text!,
                        "ssn_last_4" : self.txtSSN.text!,
                        "userId": currentUser.uid,
                        "documentId": docID
                    ]
                    Alamofire.request(url, method: .post, parameters: parameters).response(completionHandler: { (response) in
                        if let responseData = response.data {
                            let resp = String.init(data: responseData, encoding: String.Encoding.utf8)
                            DispatchQueue.main.async {
                                self.hud?.hide(animated: true)
                                if resp?.lowercased() == "success" {
                                    self.finished(true)
                                    self.showAlert("Verification successful!", message: "")
                                } else {
                                    self.finished(false)
                                    self.showAlert("Verification Failed!", message: "")
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
            } else {
                self.hud?.hide(animated: true)
                self.showAlert("Error!", message: "File uploading failed!!")
            }
        } else {
            self.hud?.hide(animated: true)
            self.showAlert("Upload Document first!", message: "")
        }
    }
    
    @IBAction func onDOBChnage(_ sender: UIDatePicker) {
        self.setDate()
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
