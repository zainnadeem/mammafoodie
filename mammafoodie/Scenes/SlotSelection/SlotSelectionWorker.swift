import UIKit

class SlotSelectionWorker: NSObject {
    // MARK: - Business Logic
    
    func handleSlotSelection(withPanGesture sender:UIPanGestureRecognizer, adapter:SlotCollectionViewAdapter){
        
        guard let collectionView = adapter.collectionView else {return}
        
        let touchX = sender.location(in: collectionView).x
        let touchY = sender.location(in: collectionView).y
        
        
        for cell in collectionView.visibleCells{
            
            let cellSX = cell.frame.origin.x
//            let cellEX = cell.frame.origin.x + cell.frame.size.width
            let cellSY = cell.frame.origin.y
            let cellEY = cell.frame.origin.y + cell.frame.size.height/2
            
            
            
            //            if (touchX >= cellSX && touchX <= cellEX && touchY >= cellSY && touchY <= cellEY){
            let touchOver = collectionView.indexPath(for: cell)
            if (touchX > cellSX  && touchY > cellSY || touchY > cellEY ){
                
                
                //if lastAccessed != touchOver {
                
//                if cell.isSelected && cell.tag == 0 {
//                    //deSelectCollectionViewCell(atIndexPath: touchOver!)
//                } else {
                   adapter.selectCollectionViewCell(atIndexPath: touchOver!)
                    //                        cell.tag = 1
//                }
            } else {
                adapter.deSelectCollectionViewCell(atIndexPath: touchOver!)
            }
        }
        
        if sender.state == .ended{
//            collectionView.isScrollEnabled = true
        }

    }
}
