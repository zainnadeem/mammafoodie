//
//  LocationSearchAdapter.swift
//  CleanSwiftLocationSearch
//
//  Created by Shreeram on 14/06/17.
//  Copyright © 2017 sreeram. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import GoogleMaps

class LocationSearchAdapter: NSObject,UISearchControllerDelegate,UISearchResultsUpdating {
    
    var viewContainer : UIView!
    var searchConrtoller : UISearchController!
    
    var resultsController = UITableViewController.init(style: .plain)
    
    var results = [Location]()
    var  placesClient : GMSPlacesClient!
    var customMapView:GMSMapView?
    
    var storedLongitude = CLLocationDegrees()
    var storedLatitude = CLLocationDegrees()
    
    
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
        
    }
    
    
    public func updateSearchResults(for searchController: UISearchController){
        if let searchString = searchController.searchBar.text {
            if !searchString.isEmpty {
                print("searching \(String(describing: searchString))")
                self.GetSearchedLoaction(searchText: searchString)
            }
        }
    }
    
    
    
    //MARK: - Local Function
    
    // AutoComplete the Search Bar
    func GetSearchedLoaction(searchText:String){
        
        placesClient = GMSPlacesClient()
        
        self.results.removeAll()
        
        placesClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error) in
            if error != nil{
                print (error?.localizedDescription)
            }
            for result in results!{
                if let result = result as? GMSAutocompletePrediction{
                    self.results.append(Location.init(placeId: result.placeID!, address: result.attributedFullText.string))
                }
            }
            self.resultsController.tableView.reloadData()
            
            
        }
    }
    
    // Get Details Based on Place ID
     func getplaceid(placeID:String){
        
        let placesClient = GMSPlacesClient()
                
        placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details for \(placeID)")
                return
            }
            
            print("Place name \(place.name)")
            print("Place address \(place.formattedAddress!)")
            print("Place placeID \(place.placeID)")
            
            // Center the camera on Vancouver, Canada
            let selectedcoordinates = place.coordinate
            let selectedcoordinatesCam = GMSCameraUpdate.setTarget(selectedcoordinates)
            self.customMapView?.animate(with: selectedcoordinatesCam)
            
        })
    }
    
    
    // Get Device Current Loction and add map View to the Screen.
    func getcurrentLocation(in view: UIView) {
        
        self.viewContainer = view
        
        let placesClient = GMSPlacesClient()
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.storedLongitude = place.coordinate.longitude
                    self.storedLatitude = place.coordinate.latitude
                    
                    //Add Map View
                    self.customMapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 50, width: self.viewContainer.frame.width, height: self.viewContainer.frame.height-50), camera:GMSCameraPosition.camera(withLatitude: self.storedLatitude, longitude: self.storedLongitude, zoom: 15) )
                    
                    self.viewContainer.addSubview(self.customMapView!)
                    
                    self.customMapView?.delegate = self
                    self.customMapView?.settings.myLocationButton = true
                    self.customMapView?.isMyLocationEnabled = true
                    
                    let pinIcon = UIImageView(image: UIImage(named: "GoogleMapPin")!)
                    pinIcon.center = (self.customMapView?.center)!
                    pinIcon.center.y -= pinIcon.frame.size.height/2
                    pinIcon.sizeToFit()
                    self.customMapView?.addSubview(pinIcon)
                    
                }
            }
        })
        
    }
    
    
}

extension LocationSearchAdapter : UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - TableView Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let location = self.results[indexPath.row]
        cell.textLabel?.text = location.address
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchConrtoller.searchBar.resignFirstResponder()
        let location = self.results[indexPath.row]
        self.searchConrtoller.searchBar.text = ""
        //        self.adapterResult.adapterCompleted(with: location)
        self.searchConrtoller.dismiss(animated: true) {
            print("selected location is : \(location.address)")
        }
    }
}

extension LocationSearchAdapter : GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.storedLongitude = position.target.longitude
        self.storedLatitude = position.target.latitude
        self.reverseGeocodeCoordinate(coordinate: position.target)
    }
    
    //Reverse geocoding for getting address from coordinates...Complete Address, city, state, Country
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if error != nil {
                print(error?.localizedDescription ?? "error")
                return
            }
            
            print(response?.firstResult() ?? "response")
        }
    }
    
    
}

struct Location {
    let placeId : String
    let address: String
    //    let coordinate : CLLocationCoordinate2D
}


