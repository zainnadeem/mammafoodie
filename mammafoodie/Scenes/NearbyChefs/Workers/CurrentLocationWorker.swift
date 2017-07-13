//
//  CurrentLocationWorker.swift
//  mammafoodie
//
//  Created by Arjav Lad on 08/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation
import MapKit

typealias FoundLoation = (CLLocation?, Error?) -> Void

class CurrentLocationWorker : NSObject, CLLocationManagerDelegate {
    
    var foundLocation : FoundLoation!
    private var hasFoundLocation : Bool = false
    var locationManager: CLLocationManager = CLLocationManager.init()
    
    func getCurrentLocation(_ completion: @escaping FoundLoation) {
        self.foundLocation = completion
        self.hasFoundLocation = false
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.requestLocation()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways,.authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            break
        case .denied, .notDetermined, .restricted:
            print("Access Denied")
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.foundLocation(nil, error)
        print("Failed to determine location: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 &&
            !self.hasFoundLocation {
            self.hasFoundLocation = true
            self.locationManager.stopUpdatingLocation()
            self.foundLocation(locations.first, nil)
        }
    }
    
}
