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
        filters.append(CuisineFilter(name: "ALL", id: "1", selectedImage: #imageLiteral(resourceName: "chinese_cuisine_selected"), unselectedImage: #imageLiteral(resourceName: "chinese_cuisine_unselected")))
        filters.append(CuisineFilter(name: "Italian", id: "2", selectedImage: #imageLiteral(resourceName: "chinese_cuisine_selected"), unselectedImage: #imageLiteral(resourceName: "chinese_cuisine_unselected")))
        filters.append(CuisineFilter(name: "Indian", id: "3", selectedImage: #imageLiteral(resourceName: "chinese_cuisine_selected"), unselectedImage: #imageLiteral(resourceName: "chinese_cuisine_unselected")))
        filters.append(CuisineFilter(name: "Ameican", id: "4", selectedImage: #imageLiteral(resourceName: "chinese_cuisine_selected"), unselectedImage: #imageLiteral(resourceName: "chinese_cuisine_unselected")))
        filters.append(CuisineFilter(name: "Mexican", id: "5", selectedImage: #imageLiteral(resourceName: "chinese_cuisine_selected"), unselectedImage: #imageLiteral(resourceName: "chinese_cuisine_unselected")))
        filters.append(CuisineFilter(name: "French", id: "6", selectedImage: #imageLiteral(resourceName: "chinese_cuisine_selected"), unselectedImage: #imageLiteral(resourceName: "chinese_cuisine_unselected")))
        filters.append(CuisineFilter(name: "Afghani", id: "7", selectedImage: #imageLiteral(resourceName: "chinese_cuisine_selected"), unselectedImage: #imageLiteral(resourceName: "chinese_cuisine_unselected")))
        filters.append(CuisineFilter(name: "Iranian", id: "8", selectedImage: #imageLiteral(resourceName: "chinese_cuisine_selected"), unselectedImage: #imageLiteral(resourceName: "chinese_cuisine_unselected")))
        filters.append(CuisineFilter(name: "Chinese", id: "9", selectedImage: #imageLiteral(resourceName: "chinese_cuisine_selected"), unselectedImage: #imageLiteral(resourceName: "chinese_cuisine_unselected")))
        filters.append(CuisineFilter(name: "Japanese", id: "10", selectedImage: #imageLiteral(resourceName: "chinese_cuisine_selected"), unselectedImage: #imageLiteral(resourceName: "chinese_cuisine_unselected")))
        filters.append(CuisineFilter(name: "Pakistani", id: "11", selectedImage: #imageLiteral(resourceName: "chinese_cuisine_selected"), unselectedImage: #imageLiteral(resourceName: "chinese_cuisine_unselected")))
        filters.append(CuisineFilter(name: "Russian", id: "12", selectedImage: #imageLiteral(resourceName: "chinese_cuisine_selected"), unselectedImage: #imageLiteral(resourceName: "chinese_cuisine_unselected")))
        filters.append(CuisineFilter(name: "African", id: "13", selectedImage: #imageLiteral(resourceName: "chinese_cuisine_selected"), unselectedImage: #imageLiteral(resourceName: "chinese_cuisine_unselected")))
        
        return filters
    }
}
