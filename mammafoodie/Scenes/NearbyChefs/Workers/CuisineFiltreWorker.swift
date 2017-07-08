//
//  CuisineFiltreWorker.swift
//  mammafoodie
//
//  Created by Arjav Lad on 16/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation

typealias FilterLoaded = ([MFCuisine]?, Error?) -> Void

struct CuisineFilterWorker {
    
    func getCuisineFilters(_ completion:@escaping FilterLoaded) {
        DatabaseGateway.sharedInstance.getCuisines { (cuisines) in
            DispatchQueue.main.async {
             completion(cuisines, nil)   
            }
        }
    }
    
}
