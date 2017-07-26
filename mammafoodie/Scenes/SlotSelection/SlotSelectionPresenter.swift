import UIKit

protocol SlotSelectionPresenterInput {
//    func selectedSlots(_ slots: Dictionary<String, Any>)
}

protocol SlotSelectionPresenterOutput: class {
//    func selectedSlots(_ slots: Dictionary<String, Any>)
}

class SlotSelectionPresenter: SlotSelectionPresenterInput {
    weak var output: SlotSelectionPresenterOutput!
    
    // MARK: - Presentation logic
    
    func selectedSlots(_ slots: Dictionary<String, Any>){
//        output.selectedSlots(slots)
    }
    
}
