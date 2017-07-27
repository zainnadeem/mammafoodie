//
//  EditAddressViewController.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 19/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import CoreLocation

protocol EditAddressDelegate{
    func editedAddress(address:MFUserAddress?)
   
}


class EditAddressViewController: UIViewController , CLLocationManagerDelegate, HUDRenderer{
    
    
    @IBOutlet weak var txfAddressLine1: UITextField!
    
    @IBOutlet weak var txfAddressLine2: UITextField!
    
    @IBOutlet weak var txfCity: UITextField!
    
    @IBOutlet weak var txfState: UITextField!
    
    @IBOutlet weak var txfCountry: UITextField!
    
    @IBOutlet weak var txfPhoneNumber: UITextField!
    
    @IBOutlet weak var txfLocation: UITextField!

    @IBOutlet weak var txfPostalCode: UITextField!
    
    @IBOutlet weak var btnDone: UIButton!
    
    
    var delegate:EditAddressDelegate!
    
    var address:MFUserAddress?
    
    lazy var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.txfCountry.isEnabled = false
        self.txfLocation.isEnabled = false
        
        self.title = "Edit Address"
        
        //Populate address for editing if any
        if let address = self.address {
            
            self.txfAddressLine1.text = address.address
            self.txfAddressLine2.text = address.address_2
            self.txfCity.text = address.city
            self.txfState.text = address.state
            self.txfPhoneNumber.text = address.phone
            self.txfPostalCode.text = address.postalCode
            
            if address.latitude != "" && address.longitude != "" {
                self.txfLocation.text = "Current Location"
            }
        } else {
            self.address = MFUserAddress()
        }
        
        self.btnDone.layer.cornerRadius = btnDone.frame.size.height/2
        btnDone.clipsToBounds = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let color1 = UIColor(red: 1, green: 0.55, blue: 0.17, alpha: 1)
        let color2 = UIColor(red: 1, green: 0.39, blue: 0.13, alpha: 1)
        btnDone.applyGradient(colors: [color1,color2])
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func currentLocationTapped(_ sender: UIButton) {
        
        self.txfLocation.text = ""
         locationManager.delegate = self
        locationManager.requestLocation()
       
        self.showActivityIndicator()
        
    }

    
    @IBAction func doneTapped(_ sender: UIButton) {
        
        guard txfAddressLine1.text != "" && txfAddressLine2.text != "" && txfLocation.text != "" && txfPhoneNumber.text != "" && txfCity.text != "" && txfPostalCode.text != "" && txfState.text != ""    &&     txfAddressLine1.text != nil && txfAddressLine2.text != nil && txfLocation.text != nil && txfPhoneNumber.text != nil && txfCity.text != nil && txfPostalCode.text != nil && txfState.text != nil else {
            showAlert(message: "Please enter all the fields")
            return
        }
        
        self.address?.address = txfAddressLine1.text!
        self.address?.address_2 = txfAddressLine2.text!
        self.address?.city = txfCity.text!
        self.address?.state = txfState.text!
        self.address?.phone = txfPhoneNumber.text!
        self.address?.postalCode = txfPostalCode.text!
        self.address?.country = txfCountry.text!
        
        delegate.editedAddress(address: self.address)
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
   
    //MARK: - location manager delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.hideActivityIndicator()
        if let location = locations.first {
            
            self.address?.latitude = location.coordinate.latitude.description
            self.address?.longitude = location.coordinate.longitude.description
            
            self.txfLocation.text = "Current Location"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.hideActivityIndicator()
        showAlert(message: "Could not get your current location. Please try again.")
    }

}
