import UIKit

class HomePageCollectionViewAdapter: NSObject {
    
    var list: [MFDish] = []
    
    var collectionView: UICollectionView!
    var conHeightCollectionView: NSLayoutConstraint!
    
    var didSelect: ((_ dish: MFDish, _ cellFrame: CGRect)->Void)?
    var didSelectViewAll: (()->Void)?
    
    func getFirstCellForCurrentUser() -> MFDish {
        let dish: MFDish = MFDish()
        dish.id = "-1"
        return dish
    }
    
    func expand(animated: Bool) {
        let duration: Double = animated ? 0.27 : 0
        UIView.animate(withDuration: duration, animations: {
            let layout: UICollectionViewFlowLayout = self.getCollectionViewLayout(isExpanded: true)
            let numberOfRows: CGFloat = ceil(CGFloat(Double(self.list.count+1)/5.0))
            let newHeight = layout.minimumLineSpacing*(numberOfRows-1) + (layout.itemSize.height*numberOfRows) + layout.sectionInset.top + layout.sectionInset.bottom
            self.conHeightCollectionView.constant = newHeight
        })
    }
    
    func collapse(animated: Bool) {
        let duration: Double = animated ? 0.27 : 0
        UIView.animate(withDuration: duration, animations: {
            self.conHeightCollectionView.constant = self.getCollapsedHeight()
        })
    }
    
    func getCollapsedHeight() -> CGFloat {
        let layout: UICollectionViewFlowLayout = self.getCollectionViewLayout(isExpanded: false)
        let newHeight: CGFloat = layout.itemSize.height + layout.sectionInset.top + layout.sectionInset.bottom
        return newHeight
    }
    
    func updateCollectionViewLayout(animated: Bool, isExpanded: Bool) {
        let layout: UICollectionViewFlowLayout = self.getCollectionViewLayout(isExpanded: isExpanded)
        self.collectionView.setCollectionViewLayout(layout, animated: animated)
        self.collectionView.reloadData()
        //        self.collectionView.setContentOffset(.zero, animated: false)
    }
    
    func getCollectionViewLayout(isExpanded: Bool) -> UICollectionViewFlowLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        if isExpanded {
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 16
            layout.minimumLineSpacing = 25
        } else {
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 16
            layout.minimumLineSpacing = 16
        }
        // This should be at the last. after all other configurations are set for the layout
        layout.itemSize = self.getCellSize(for: layout)
        return layout
    }
    
    func getCellSize(for layout: UICollectionViewFlowLayout) -> CGSize {
        let numberOfColums: CGFloat = 5
        let availableWidth: CGFloat = self.collectionView.frame.width - layout.sectionInset.left - layout.sectionInset.right
        let width: CGFloat = (availableWidth - layout.minimumInteritemSpacing * (numberOfColums - 1)) / numberOfColums
        print("Width is: \(width)")
        return CGSize(width: width, height: width)
    }
}
