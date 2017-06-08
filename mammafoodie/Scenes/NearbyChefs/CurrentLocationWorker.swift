//
//  CurrentLocationWorker.swift
//  mammafoodie
//
//  Created by Arjav Lad on 08/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation
import MapKit

typealias FoundLoation = (CLLocation?) -> Void

class CurrentLocationWorker : NSObject, CLLocationManagerDelegate {
    
    var foundLocation : FoundLoation!
    
    var locationManager: CLLocationManager = CLLocationManager.init()
    
    func getCurrentLocation(_ completion: @escaping FoundLoation) {
        self.foundLocation = completion
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
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
        self.foundLocation(nil)
        print("Failed to determine location: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            self.locationManager.stopUpdatingLocation()
            self.foundLocation(locations.first)
        }
    }
    
}
