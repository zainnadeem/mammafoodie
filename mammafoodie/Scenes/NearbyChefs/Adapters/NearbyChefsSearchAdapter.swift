//
//  NearbyChefsSearchAdapter.swift
//  mammafoodie
//
//  Created by Arjav Lad on 08/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation
import UIKit

typealias NearbyChefsSearchAdapterResult = ([MFDish], [MFUser]) -> Void

class NearbyChefsSearchAdapter : NSObject, UITextFieldDelegate {
    
//    var results: [MFDish] = [MFDish]()
    var results: ([MFDish], [MFUser]) = ([MFDish](), [MFUser]())
    var cuisineFilter: MFCuisine?
    var adapterResult: NearbyChefsSearchAdapterResult?
    var currentLocation : CLLocationCoordinate2D?
    
    var textField : UITextField!
    
    override init() {
        
    }
    
    func filter(for cuisine : MFCuisine?) {
        self.cuisineFilter = cuisine
        if let searctText = self.textField.text {
            if !searctText.isEmpty {
                self.searchText(searctText, { (foundDishes, foundUsers) in
                    self.prepareResult(withDishes: foundDishes, users: foundUsers)
                })
            } else {
                if let filter = self.cuisineFilter {
                    DatabaseGateway.sharedInstance.searchDish(withCuisine: filter, { (dishes) in
                        if let filtered = self.filter(dishes: dishes, by: filter) {
                            self.prepareResult(withDishes: filtered, users: nil)
                        }
                    })
                } else {
                    self.prepareResult(withDishes: nil, users: nil)
                }
            }
        }
    }
    
    func prepareResult(withDishes dishes: [MFDish]?, users: [MFUser]?) {
        if let dishes = dishes,
            dishes.count > 0 {
            self.results.0 = dishes
        } else {
            self.results.0.removeAll()
        }
        
        if let users = users,
            users.count > 0 {
            self.results.1 = users
        } else {
            self.results.1.removeAll()
        }
        
        self.adapterResult?(self.results.0, self.results.1)
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
                self.searchText(searchText, { (searchResult, resultUsers) in
                    self.prepareResult(withDishes: searchResult, users: resultUsers)
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
    
    func searchText(_ text : String!, _ completion : @escaping ([MFDish], [MFUser]) -> Void ) {
        var foundDishes: [MFDish] = [MFDish]()
        var foundUsers: [MFUser] = [MFUser]()
        let group = DispatchGroup.init()
        group.enter()
        DatabaseGateway.sharedInstance.searchDish(with: text) { (dishes) in
            if let filter = self.cuisineFilter {
                if let filteredCuisine = self.filter(dishes: dishes, by: filter) {
                    foundDishes = filteredCuisine
                } else {
                }
            } else {
                foundDishes = dishes
            }
            group.leave()
        }
        
        group.enter()
        DatabaseGateway.sharedInstance.searchUser(with: text) { (users) in
            foundUsers = users
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            completion(foundDishes, foundUsers)
        }
    }
}
