import Foundation
import UIKit

struct MFCuisine : Equatable {
    var id: String!
    var name: String!
    var isSelected: Bool = false
    var selectedImage : UIImage?
    var unselectedImage : UIImage?
    
    init(id: String!, name: String!, isSelected: Bool) {
        self.id = id
        self.name = name
        self.isSelected = isSelected
    }
    
    init(id: String!, name: String!, isSelected: Bool, selectedImage : UIImage?, unselectedImage : UIImage?) {
        self.id = id
        self.name = name
        self.isSelected = isSelected
        self.selectedImage = selectedImage
        self.unselectedImage = unselectedImage
    }
    
    static func ==(lhs: MFCuisine, rhs : MFCuisine) -> Bool {
        return lhs.id == rhs.id
    }
}
