//
//  NearbyChefModel.swift
//  mammafoodie
//
//  Created by Arjav Lad on 08/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation
import GoogleMaps

class Marker : GMSMarker {
    var isSelected = false
    
    class func marker(with title: String, at location: CLLocationCoordinate2D) -> Marker {
        let marker = Marker()
        
        marker.position = location
        marker.title = title
        marker.isTappable = true
        marker.appearAnimation = .pop
        return marker
    }
}
