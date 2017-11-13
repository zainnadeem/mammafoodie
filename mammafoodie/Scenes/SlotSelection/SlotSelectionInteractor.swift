import UIKit

protocol SlotSelectionInteractorInput {
    func handleSlotSelection(withPanGesture sender : UIPanGestureRecognizer, adapter : SlotCollectionViewAdapter, collectionView : UICollectionView)
    
}

protocol SlotSelectionInteractorOutput {
//    func selectedSlots(_ slots: Dictionary<String, Any>)
}

class SlotSelectionInteractor: SlotSelectionInteractorInput {
    
    var output: SlotSelectionInteractorOutput!
    var worker: SlotSelectionWorker = SlotSelectionWorker()
    
    // MARK: - Business logic
    
    func handleSlotSelection(withPanGesture sender : UIPanGestureRecognizer, adapter : SlotCollectionViewAdapter, collectionView : UICollectionView) {
        self.worker.handleSlotSelection(withPanGesture: sender, adapter: adapter, collectionView: collectionView)
    }
    
}
