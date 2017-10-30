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
    var cuisineFilter : MFCuisine?
    var adapterResult : NearbyChefsSearchAdapterResult?
    var currentLocation : CLLocationCoordinate2D?
    
    var textField : UITextField!
    
    override init() {
        
    }
    
    func filter(for cuisine : MFCuisine?) {
        self.cuisineFilter = cuisine
        if let searctText = self.textField.text {
            if !searctText.isEmpty {
                self.searchText(searctText, { (dishes) in
                    DispatchQueue.main.async {
                        if let resultFound = dishes {
                            self.results = resultFound
                            self.adapterResult?(resultFound)
                        } else {
                            self.results.removeAll()
                            self.adapterResult?(self.results)
                        }
                    }
                })
            } else {
                if let filter = self.cuisineFilter {
                    DatabaseGateway.sharedInstance.getAllDish { (dishes) in
                        DispatchQueue.main.async {
                            if let filtered = self.filter(dishes: dishes, by: filter) {
                                self.results = filtered
                                self.adapterResult?(self.results)
                            } else {
                                self.results.removeAll()
                                self.adapterResult?(self.results)
                            }
                        }
                    }
                } else {
                    self.results.removeAll()
                    self.adapterResult?(self.results)
                }
            }
        }
    }
    
    func prepare(with textField : UITextField) {
        self.textField = textField
        self.textField.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let searchText = textField.text {
            if !searchText.isEmpty {
                self.searchText(searchText, { (searchResult) in
                    DispatchQueue.main.async {
                        if let resultFound = searchResult {
                            self.results = resultFound
                            self.adapterResult?(resultFound)
                        } else {
                            self.results.removeAll()
                            self.adapterResult?(self.results)
                        }
                    }
                })
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func filter(dishes : [MFDish], by text : String!) -> [MFDish]? {
        let filtered = dishes.filter({ (dish) -> Bool in
            return (dish.name.lowercased().range(of:text.lowercased()) != nil)
        })
        
        return filtered
    }
    
    func filter(dishes : [MFDish], by cuisine : MFCuisine) -> [MFDish]? {
        let filtered = dishes.filter({ (dish) -> Bool in
            return dish.cuisine == cuisine
        })
        return filtered
    }
    
    func searchText(_ text : String!, _ completion : @escaping ([MFDish]?) -> Void ) {
        DatabaseGateway.sharedInstance.searchDish(with: text) { (dishes) in
            if let filtered = self.filter(dishes: dishes, by: text) {
                if let filter = self.cuisineFilter {
                    if let filteredCuisine = self.filter(dishes: filtered, by: filter) {
                        completion(filteredCuisine)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(filtered)
                }
            } else {
                completion(nil)
            }
        }
        
    }
    
}
