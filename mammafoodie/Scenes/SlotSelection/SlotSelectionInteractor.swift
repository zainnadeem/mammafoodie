import UIKit

protocol SlotSelectionInteractorInput {
    func handleSlotSelection(_ sender:UIPanGestureRecognizer)
    func setUpCollectionView(_ collectionView:UICollectionView)
}

protocol SlotSelectionInteractorOutput {
    func selectedSlots(_ slots: Dictionary<String, Any>)
}

class SlotSelectionInteractor: SlotSelectionInteractorInput {
    
    var output: SlotSelectionInteractorOutput!
    var worker: SlotSelectionWorker! = SlotSelectionWorker()
    
    // MARK: - Business logic
    
    func handleSlotSelection(_ sender:UIPanGestureRecognizer){
        worker.handleSlotSelection(sender)
    }
    
    func setUpCollectionView(_ collectionView:UICollectionView){
        
        worker.setUpCollectionView(collectionView)
        
    }
}
