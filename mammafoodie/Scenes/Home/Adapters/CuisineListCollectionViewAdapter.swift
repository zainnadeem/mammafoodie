import UIKit

class CuisineListCollectionViewAdapter: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    var cuisines: [MFCuisine] = []
    var selectionIndicatorView: UIView!
    var conLeadingViewSelectionIndicator: NSLayoutConstraint!
    
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
        let theAttributes:UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
        let cellFrameInSuperview:CGPoint = collectionView.convert(theAttributes.center, to: collectionView.superview)
        self.conLeadingViewSelectionIndicator.constant = cellFrameInSuperview.x
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: collectionView.frame.height)
    }
}
