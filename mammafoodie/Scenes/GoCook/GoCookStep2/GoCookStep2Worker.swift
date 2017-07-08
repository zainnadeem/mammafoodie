import UIKit

class GoCookStep2Worker {
    // MARK: - Business Logic
    
}

typealias CuisinesLoaded = ([MFCuisine]?, Error?) -> Void

class CuisineWorker {
    // MARK: - Business Logic
    func getCuisines(_ completion:@escaping CuisinesLoaded) {
        DatabaseGateway.sharedInstance.getCuisines { (cuisines) in
            DispatchQueue.main.async {
                completion(cuisines, nil)
            }
        }
    }
    
    private func generateFakeData() -> [MFCuisine] {
        var filters = [MFCuisine]()
        for index in 0...3 {
            filters.append(MFCuisine(id: "12+\(index)", name: "Chinese", isSelected: false, selectedImage: #imageLiteral(resourceName: "iconChinese_cuisine_selected"), unselectedImage: #imageLiteral(resourceName: "iconChinese_cuisine_unselected")))
            filters.append(MFCuisine(id: "19+\(index)", name: "Indian", isSelected: false, selectedImage: #imageLiteral(resourceName: "iconIndian_Cuisine_Selected"), unselectedImage: #imageLiteral(resourceName: "iconIndian_Cuisine_unselected")))
            filters.append(MFCuisine(id: "14+\(index)", name: "Mexican", isSelected: false, selectedImage: #imageLiteral(resourceName: "iconMexican_selected"), unselectedImage: #imageLiteral(resourceName: "iconMexican_unselected")))
        }
        return filters
    }
    
}
