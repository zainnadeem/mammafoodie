//
//  NearbyChefsSearchAdapter.swift
//  mammafoodie
//
//  Created by Arjav Lad on 08/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation
import UIKit

typealias NearbyChefsSearchAdapterResult = ([MFDish]) -> Void

class NearbyChefsSearchAdapter : NSObject, UITextFieldDelegate {
    
    var results : [MFDish] = [MFDish]()
    var adapterResult : NearbyChefsSearchAdapterResult?
    var currentLocation : CLLocationCoordinate2D?
    
    var textField : UITextField!
    
    override init() {
        
    }
    
    func prepare(with textField : UITextField) {
        self.textField = textField
        self.textField.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchText = textField.text {
            if !searchText.isEmpty {
                self.searchText(searchText, { (searchResult) in
                    if let resultFound = searchResult {
                        self.adapterResult?(resultFound)
                    }
                })
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func searchText(_ text : String!, _ completion : @escaping ([MFDish]?) -> Void ) {
        DatabaseGateway.sharedInstance.getAllDish { (dishes) in
            let filtered = dishes.filter({ (dish) -> Bool in
                return dish.name.contains(text)
            })
            completion(filtered)
        }
    }
    
}
