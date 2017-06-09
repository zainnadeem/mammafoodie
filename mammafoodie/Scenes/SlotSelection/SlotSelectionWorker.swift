import UIKit

class SlotSelectionWorker: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - Business Logic
    
    private let reuseIdentifier = "Cell"
    var collectionView:UICollectionView?
    var selectedCells = [Int:Bool]()
    
    func setUpCollectionView(_ collectionView:UICollectionView){
        collectionView.dataSource = self
        collectionView.delegate = self
        self.collectionView = collectionView
    }
    
    func handleSlotSelection(_ sender:UIPanGestureRecognizer){
        let touchX = sender.location(in: self.collectionView).x
        let touchY = sender.location(in: self.collectionView).y
        
        
        for cell in self.collectionView!.visibleCells{
            
            let cellSX = cell.frame.origin.x
            let cellEX = cell.frame.origin.x + cell.frame.size.width
            let cellSY = cell.frame.origin.y
            let cellEY = cell.frame.origin.y + cell.frame.size.height
            
            
            
            //            if (touchX >= cellSX && touchX <= cellEX && touchY >= cellSY && touchY <= cellEY){
            let touchOver = collectionView?.indexPath(for: cell)
            if (touchX > cellSX  && touchY > cellSY || touchY > cellEY ){
                
                
                //if lastAccessed != touchOver {
                
                if cell.isSelected && cell.tag == 0 {
                    //deSelectCollectionViewCell(atIndexPath: touchOver!)
                } else {
                    selectCollectionViewCell(atIndexPath: touchOver!)
                    //                        cell.tag = 1
                }
                //}
                
                //lastAccessed = touchOver
            } else {
                deSelectCollectionViewCell(atIndexPath: touchOver!)
            }
        }
        
        if sender.state == .ended{
            self.collectionView?.isScrollEnabled = true
            print(selectedCells)
        }

    }
    
    
    // MARK: UICollectionViewDataSource
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 10
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if cell.isSelected {
            cell.backgroundColor = .gray
        } else {
            cell.backgroundColor = .red
        }
        
        return cell
    }
    
    
    func selectCollectionViewCell(atIndexPath: IndexPath){
        self.collectionView?.selectItem(at: atIndexPath, animated: true, scrollPosition: .centeredVertically)
        self.collectionView!.delegate!.collectionView!(self.collectionView!, didSelectItemAt: atIndexPath)
        
    }
    
    func deSelectCollectionViewCell(atIndexPath: IndexPath){
        self.collectionView?.deselectItem(at: atIndexPath, animated: true)
        self.collectionView!.delegate!.collectionView!(self.collectionView!, didDeselectItemAt: atIndexPath)
    }
    
    
    // MARK: UICollectionViewDelegate
    
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .gray
        cell?.isSelected = true
        
        selectedCells.updateValue(true, forKey: indexPath.item)
        
    }
    
     func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .red
        cell?.isSelected = false
        
        selectedCells.removeValue(forKey: indexPath.item)
    }


}
