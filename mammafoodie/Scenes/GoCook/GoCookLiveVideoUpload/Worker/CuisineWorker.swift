import UIKit

typealias CuisinesLoaded = ([Cuisine]?, Error?) -> Void

class CuisineWorker {
    // MARK: - Business Logic
    func getCuisines(_ completion:CuisinesLoaded) {
        completion(self.generateFakeData(), nil)
    }
    
    private func generateFakeData() -> [Cuisine] {
        var filters = [Cuisine]()
        for index in 0...3 {
            filters.append(Cuisine(name: "Chinese", id: "12+\(index)", selectedImage: #imageLiteral(resourceName: "iconChinese_cuisine_selected"), unselectedImage: #imageLiteral(resourceName: "iconChinese_cuisine_unselected")))
            filters.append(Cuisine(name: "Indian", id: "3+\(index)", selectedImage: #imageLiteral(resourceName: "iconIndian_Cuisine_Selected"), unselectedImage: #imageLiteral(resourceName: "iconIndian_Cuisine_unselected")))
            filters.append(Cuisine(name: "Mexican", id: "13+\(index)", selectedImage: #imageLiteral(resourceName: "iconMexican_selected"), unselectedImage: #imageLiteral(resourceName: "iconMexican_unselected")))
        }
        return filters
    }
    
}
