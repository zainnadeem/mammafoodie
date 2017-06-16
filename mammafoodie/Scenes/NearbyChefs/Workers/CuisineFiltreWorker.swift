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
        filters.append(CuisineFilter(name: "ALL", id: "1"))
        filters.append(CuisineFilter(name: "Italian", id: "2"))
        filters.append(CuisineFilter(name: "Indian", id: "3"))
        filters.append(CuisineFilter(name: "Ameican", id: "4"))
        filters.append(CuisineFilter(name: "Mexican", id: "5"))
        filters.append(CuisineFilter(name: "French", id: "6"))
        filters.append(CuisineFilter(name: "Afghani", id: "7"))
        filters.append(CuisineFilter(name: "Iranian", id: "8"))
        filters.append(CuisineFilter(name: "Chinese", id: "9"))
        filters.append(CuisineFilter(name: "Japanese", id: "10"))
        filters.append(CuisineFilter(name: "Pakistani", id: "11"))
        filters.append(CuisineFilter(name: "Russian", id: "12"))
        filters.append(CuisineFilter(name: "African", id: "13"))
        
        for index in 14...30 {
            filters.append(CuisineFilter(name: "African - \(index) \(index - 5) \(index - 10) ", id: "\(index)"))
        }
        return filters
    }
}
