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
        var indexCounter = 0
        for (_, dish) in self.searchResults.0.enumerated() {
            if let location = dish.location {
                let marker = Marker.marker(withTitle: dish.name, atLocation: location, withIndex: indexCounter, withID: dish.id, isDish: true)
                marker.title = dish.name
                marker.snippet = dish.description
                markers.append(marker)
                indexCounter += indexCounter
            }
        }
        let extent = 10.9
        for (_, user) in self.searchResults.1.enumerated() {
            if let lattStr = user.addressDetails?.latitude,
                let longiStr = user.addressDetails?.longitude,
                let latt = Double(lattStr),
                let longi = Double(longiStr) {
                let location = CLLocationCoordinate2D.init(latitude: latt, longitude: longi)
                let marker = Marker.marker(withTitle: user.name, atLocation: location, withIndex: indexCounter, withID: user.id, isDish: false)
                marker.title = user.name
                marker.snippet = user.profileDescription
                markers.append(marker)
            } else {
                let location = CLLocationCoordinate2D.init(latitude: kCameraLatitude + extent * randomScale(), longitude: kCameraLongitude + extent * randomScale())
                let marker = Marker.marker(withTitle: user.name, atLocation: location, withIndex: indexCounter, withID: user.id, isDish: false)
                marker.title = user.name
                marker.snippet = user.profileDescription
                markers.append(marker)
            }
            indexCounter += indexCounter
        }
        
        self.showMarkers(markers: markers)
    }
    
    private func randomScale() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
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
            if self.allMarks.count > 0 {
//                let bounds = self.allMarks.reduce(GMSCoordinateBounds()) {
//                    $0.includingCoordinate($1.position)
//                }
//                self.mapView.animate(with: .fit(bounds, withPadding: 50.0))
            } else {
                let camera = GMSCameraPosition.camera(withLatitude: kCameraLatitude, longitude: kCameraLongitude, zoom: 12)
                self.mapView.animate(to: camera)
            }
        } else {
            print("Location not found")
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        mapView.selectedMarker = marker
//        return false
        if let markerData = marker.userData as? Marker {
            if markerData.refrenceID != "" {
                if markerData.isDish {
                    self.openDish(with: markerData.refrenceID)
                } else {
                    self.openUser(with: markerData.refrenceID)
                }
            }
        } else {
            let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude, longitude: marker.position.longitude, zoom: 12)
            self.mapView.animate(to: camera)
        }

        return true
    }
    
    func openUser(with id: String) {
        if let navUser: MFNavigationController = UIStoryboard(name:"Main",bundle:nil).instantiateViewController(withIdentifier: "navUserProfile") as? MFNavigationController {
            if let profileVC = navUser.viewControllers.first as? OtherUsersProfileViewController {
                profileVC.userID = id
                self.present(navUser, animated: true, completion: nil)
            }
        }
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
        if let dishVC: DishDetailViewController = UIStoryboard(name:"DishDetail",bundle:nil).instantiateViewController(withIdentifier: "DishDetailViewController") as? DishDetailViewController {
        dishVC.dishID = dishID
        let navController: MFNavigationController = MFNavigationController(rootViewController: dishVC)
        navController.navigationBar.tintColor = navigationBarTintColor
        self.present(navController, animated: true, completion: nil)
        }
    }
    
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        if let markerData = marker.userData as? Marker {
            if markerData.isDish {
                marker.icon = #imageLiteral(resourceName: "iconMarkerPin")
            } else {
                marker.icon = #imageLiteral(resourceName: "iconMarkerPinUser")
            }
        }
    }
    
    //    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    //        kCameraLatitude = position.target.latitude
    //        kCameraLongitude = position.target.longitude
    //        self.output.loadMarkers(at: position.target)
    //        print("idle At: \(position.target)")
    //    }
}
