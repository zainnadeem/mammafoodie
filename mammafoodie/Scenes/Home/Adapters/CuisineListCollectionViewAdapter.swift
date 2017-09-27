import UIKit

class CuisineListCollectionViewAdapter: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    var cuisines: [MFCuisine] = []
    var selectionIndicatorView: UIView!
    var conLeadingViewSelectionIndicator: NSLayoutConstraint!
    var selectedCuisine: MFCuisine!
    var didSelectCuisine: ((MFCuisine)->Void)?
    
    // Stored property for contentOffset observer
    var contentOffsetKVOContext: UInt8 = 1
    var selectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    func createStaticData() {
        self.cuisines.append(MFCuisine(id: "1", name: "Italian", isSelected: true))
        self.cuisines.append(MFCuisine(id: "2", name: "Chinese", isSelected: false))
        self.cuisines.append(MFCuisine(id: "3", name: "Indian", isSelected: false))
        self.cuisines.append(MFCuisine(id: "4", name: "Asian", isSelected: false))
        self.cuisines.append(MFCuisine(id: "5", name: "American", isSelected: false))
        self.cuisines.append(MFCuisine(id: "6", name: "Thai", isSelected: false))
        self.cuisines.append(MFCuisine(id: "7", name: "Spanish", isSelected: false))
        self.cuisines.append(MFCuisine(id: "8", name: "African", isSelected: false))
    }
    
    func setup(with collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let name: String = "MenuCuisineSelectorClnCell"
        self.collectionView.register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
        
        self.addObserverForContentOffset()
        
        self.selectedCuisine = self.cuisines.first
        self.updateSelectionIndicatorView(in: self.collectionView, at: self.selectedIndexPath, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MenuCuisineSelectorClnCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCuisineSelectorClnCell", for: indexPath) as! MenuCuisineSelectorClnCell
        cell.setup(with: self.cuisines[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cuisines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.updateSelectionIndicatorView(in: collectionView, at: indexPath, animated: false)
        self.updateSelection(for: indexPath)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.didSelectCuisine?(self.cuisines[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: collectionView.frame.height)
    }
    
    func updateSelectionIndicatorView(in collectionView: UICollectionView, at indexPath: IndexPath, animated: Bool) {
        let theAttributes: UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
        let cellFrameInSuperview: CGPoint = collectionView.convert(theAttributes.center, to: collectionView.superview)
        UIView.animate(withDuration: animated ? 0.27 : 0) {
            self.conLeadingViewSelectionIndicator.constant = cellFrameInSuperview.x - collectionView.frame.origin.x
        }
    }
    
    func updateSelection(for indexPath: IndexPath) {
        for (index, cuisine) in self.cuisines.enumerated() {
            if cuisine.isSelected {
                cuisine.isSelected = false
            }
            self.cuisines[index] = cuisine
        }
        self.cuisines[indexPath.item].isSelected = !self.cuisines[indexPath.item].isSelected
        collectionView.reloadData()
        self.selectedIndexPath = indexPath
    }
}

// Key-Value observer for contentOffset
extension CuisineListCollectionViewAdapter {
    
    func addObserverForContentOffset() {
        self.collectionView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: &contentOffsetKVOContext)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &contentOffsetKVOContext {
            let collectionView: UICollectionView = object as! UICollectionView
            self.updateSelectionIndicatorView(in: collectionView, at: self.selectedIndexPath, animated: false)
        }
    }
}
