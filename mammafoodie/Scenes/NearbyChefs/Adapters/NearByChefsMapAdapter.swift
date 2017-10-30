//
//  NearByChefsMapAdapter.swift
//  mammafoodie
//
//  Created by Arjav Lad on 16/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation

extension NearbyChefsViewController : GMUClusterManagerDelegate, GMSMapViewDelegate, GMUClusterRendererDelegate {

    func prepareMap() {
        self.mapView.isMultipleTouchEnabled = true
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        
        searchRadius = 1000
        
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: self.mapView, clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        self.clusterManager = GMUClusterManager(map: self.mapView, algorithm: algorithm, renderer: renderer)
        self.clusterManager.setDelegate(self, mapDelegate: self)
        
        if let jsonPathURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
            print("path: \(String(describing: jsonPathURL))")
            do {
                self.mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: jsonPathURL)
            } catch {
                print("failed to load. \(error)")
            }
        }
    }
    
    func reloadSearchData() {
        var markers = [Marker]()
        for (index, dish) in self.searchResults.enumerated() {
            //            dish.location = CLLocationCoordinate2D.init(latitude: 40, longitude: 12 + (Double(index) * 0.12))
            if let location = dish.location {
                let marker = Marker.marker(with: dish.address, at: location, with: index)
                marker.dishID = dish.id
                markers.append(marker)
            }
        }
        self.showMarkers(markers: markers)
    }
    
    func showMarkers(markers: [Marker]) {
        print("showing marker at location: \(String(describing: markers.first?.position))")
        self.allMarks.removeAll()
        self.allMarks.append(contentsOf: markers)
        self.clusterManager.clearItems()
        self.clusterManager.add(markers)
        self.clusterManager.cluster()
        print("Total Pins: \(self.clusterManager.algorithm.allItems().count)")
        let bounds = markers.reduce(GMSCoordinateBounds()) {
            $0.includingCoordinate($1.position)
        }
        self.mapView.animate(with: .fit(bounds, withPadding: 50.0))
    }
    
    func showCurrentLocation(_ location: CLLocation?) {
        if let currentLocation = location {
            kCameraLatitude = currentLocation.coordinate.latitude
            kCameraLongitude = currentLocation.coordinate.longitude
            let camera = GMSCameraPosition.camera(withLatitude: kCameraLatitude, longitude: kCameraLongitude, zoom: 12)
            self.mapView.animate(to: camera)
        } else {
            print("Location not found")
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let markerData = marker.userData as? Marker {
            if markerData.dishID != "" {
                self.openDish(with: markerData.dishID)
            }
        } else {
            let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude, longitude: marker.position.longitude, zoom: 12)
            self.mapView.animate(to: camera)
        }
        
        return true
    }

    func openDish(with id: String) {
        _ = DatabaseGateway.sharedInstance.getDishWith(dishID: id) { (dish) in
            if let dish = dish {
                self.openDishDetails(dish)
            }
        }
    }

    func openDishDetails(_ dish: MFDish) {
        if dish.user.id == DatabaseGateway.sharedInstance.getLoggedInUser()?.id {
            dish.accessMode = .owner
        } else {
            dish.accessMode = .viewer
        }

        if dish.endTimestamp?.timeIntervalSinceReferenceDate ?? 0 > Date().timeIntervalSinceReferenceDate {
            if dish.mediaType == .liveVideo &&
                dish.endTimestamp == nil {
                self.performSegue(withIdentifier: "segueShowLiveVideoDetails", sender: dish)
            } else if dish.mediaType == .vidup ||
                dish.mediaType == .picture {
                self.performSegue(withIdentifier: "segueShowDealDetails", sender: dish)
            }
        } else {
            self.openDishPageWith(dishID: dish.id)
        }
    }

    func openDishPageWith(dishID: String) {
        //Initiate segue and pass it to router in prepare for segue
        let dishVC: DishDetailViewController = UIStoryboard(name:"DishDetail",bundle:nil).instantiateViewController(withIdentifier: "DishDetailViewController") as! DishDetailViewController
        dishVC.dishID = dishID
        let navController: MFNavigationController = MFNavigationController(rootViewController: dishVC)
        navController.navigationBar.tintColor = navigationBarTintColor
        self.present(navController, animated: true, completion: nil)
    }
    
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        marker.icon = #imageLiteral(resourceName: "iconMarkerPin")
    }
    
    //    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    //        kCameraLatitude = position.target.latitude
    //        kCameraLongitude = position.target.longitude
    //        self.output.loadMarkers(at: position.target)
    //        print("idle At: \(position.target)")
    //    }
}
