//
//  CuisineFiltreWorker.swift
//  mammafoodie
//
//  Created by Arjav Lad on 16/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation

typealias FilterLoaded = ([CuisineFilter]?, Error?) -> Void

struct CuisineFiltreWorker {
    
    func getCuisineFilters(_ completion:FilterLoaded) {
        completion(self.generateFakeData(), nil)
    }
    
    private func generateFakeData() -> [CuisineFilter] {
        var filters = [CuisineFilter]()
        for index in 0...3 {
            filters.append(CuisineFilter(name: "Chinese", id: "12+\(index)", selectedImage: #imageLiteral(resourceName: "chinese_cuisine_selected"), unselectedImage: #imageLiteral(resourceName: "chinese_cuisine_unselected"), pin : #imageLiteral(resourceName: "chinese_pin")))
            filters.append(CuisineFilter(name: "Indian", id: "3+\(index)", selectedImage: #imageLiteral(resourceName: "Indian_Cuisine_Selected"), unselectedImage: #imageLiteral(resourceName: "Indian_Cuisine_Unselected"), pin : #imageLiteral(resourceName: "pinIndian")))
            filters.append(CuisineFilter(name: "Mexican", id: "13+\(index)", selectedImage: #imageLiteral(resourceName: "Mexican_selected"), unselectedImage: #imageLiteral(resourceName: "Mexican_unselected"), pin : #imageLiteral(resourceName: "pinMexican")))
        }
        return filters
    }
}
