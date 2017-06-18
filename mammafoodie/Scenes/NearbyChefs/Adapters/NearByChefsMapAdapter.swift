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
    
    func showMarkers(markers: [Marker]) {
        print("showing marker at location: \(String(describing: markers.first?.position))")
        if markers != nil {
            for marker in markers {
                if !self.allMarks.contains(marker) {
                    self.allMarks.append(marker)
                    self.clusterManager.add(marker)
                }
            }
            self.clusterManager.cluster()
        }
        print("Total Pins: \(self.clusterManager.algorithm.allItems().count)")
    }
    
    func showCurrentLocation(_ location: CLLocation?) {
        if let currentLocation = location {
            kCameraLatitude = currentLocation.coordinate.latitude
            kCameraLongitude = currentLocation.coordinate.longitude
            let camera = GMSCameraPosition.camera(withLatitude: kCameraLatitude, longitude: kCameraLongitude, zoom: 12)
            self.mapView.animate(to: camera)
            self.output.loadMarkers(at: currentLocation.coordinate)
        } else {
            print("Location not found")
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let _ = marker.userData as? Marker {
            let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude, longitude: marker.position.longitude, zoom: 12)
            self.mapView.animate(to: camera)
        } else {
            let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude, longitude: marker.position.longitude, zoom: 12)
            self.mapView.animate(to: camera)
        }
        
        return true
    }
    
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        marker.icon = #imageLiteral(resourceName: "iconMarkerPin")
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.output.loadMarkers(at: position.target)
        print("idle At: \(position.target)")
    }
}
