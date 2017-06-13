//
//  NearbyChefsSearchAdapter.swift
//  mammafoodie
//
//  Created by Arjav Lad on 08/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

protocol NearbyChefsSearchAdapterResult {
    func didSelect(cusine: CuisineLocation)
}

class NearbyChefsSearchAdapter : NSObject, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    var searchConrtoller : UISearchController!
    var viewContainer : UIView!
    
    var resultsController = UITableViewController.init(style: .plain)
    var results = [CuisineLocation]()
    
    var adapterResult : NearbyChefsSearchAdapterResult
    
    var currentLocation : CLLocationCoordinate2D?
    
    init(with result: NearbyChefsSearchAdapterResult) {
        self.adapterResult = result
    }
    
    func setupSearchBar(in view: UIView) {
        self.viewContainer = view
        
        self.searchConrtoller = UISearchController.init(searchResultsController: self.resultsController)
        self.searchConrtoller.delegate = self
        self.searchConrtoller.dimsBackgroundDuringPresentation = true
        self.searchConrtoller.searchBar.placeholder = "Search Here..."
        self.searchConrtoller.searchResultsUpdater = self
        self.searchConrtoller.isActive = true
        
        self.resultsController.tableView.delegate = self
        self.resultsController.tableView.dataSource = self
        
        self.viewContainer.addSubview(self.searchConrtoller.searchBar)
        
        results.append(CuisineLocation.init(name: "Indian", coordinate: CLLocationCoordinate2D.init(latitude: 122.1, longitude: 21212.1)))
        results.append(CuisineLocation.init(name: "Italian", coordinate: CLLocationCoordinate2D.init(latitude: 122.13, longitude: 21212.1)))
        results.append(CuisineLocation.init(name: "Chinese", coordinate: CLLocationCoordinate2D.init(latitude: 122.11221, longitude: 21212.1)))
        results.append(CuisineLocation.init(name: "Arabic", coordinate: CLLocationCoordinate2D.init(latitude: 122.11221, longitude: 21212.1)))
        results.append(CuisineLocation.init(name: "Afghani", coordinate: CLLocationCoordinate2D.init(latitude: 122.11221, longitude: 21212.1)))
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text {
            if !searchString.isEmpty {
                self.searchFor(cuisineName: searchString)
            }
        }
    }
    
    func searchFor(cuisineName: String) {
        print("searching \(String(describing: cuisineName))")
    }
}

extension NearbyChefsSearchAdapter : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "CuisineLocationResultCell")
        let cuisine = self.results[indexPath.row]
        cell.textLabel?.text = cuisine.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchConrtoller.searchBar.resignFirstResponder()
        let cuisine = self.results[indexPath.row]
        self.searchConrtoller.searchBar.text = ""
        self.adapterResult.didSelect(cusine: cuisine)
        self.searchConrtoller.dismiss(animated: true) {
            print("selected cuisine is : \(cuisine.name)")
        }
    }
}

struct CuisineLocation {
    let name: String
    let coordinate : CLLocationCoordinate2D
    
}
