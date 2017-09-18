import UIKit

class HomePageVidupsCollectionViewAdapter: HomePageCollectionViewAdapter, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let worker: DealsListWorker = DealsListWorker()
    
    func loadVidup() {
        self.worker.getList { (dishes) in
            self.list = [self.getFirstCellForCurrentUser()]
            self.list.append(contentsOf: dishes)
            self.collectionView.reloadData()
        }
    }
    
    func remove(vidup: MFDish) {
        if let index: Int = self.list.index(of: vidup) {
            self.list.remove(at: index)
            self.collectionView.deleteItems(at: [ IndexPath(row: index, section: 0) ])
        }
    }
    
    func setup(with tableView: UICollectionView) {
        self.collectionView = tableView
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let name: String = "HomePageVidupClnCell"
        self.collectionView.register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
        
        self.list = [self.getFirstCellForCurrentUser()]
        self.collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomePageVidupClnCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageVidupClnCell", for: indexPath) as! HomePageVidupClnCell
        cell.setup(with: self.list[indexPath.item])
        if self.isLastItem(indexPath.item) {
            cell.showViewAll()
        } else {
            cell.hideViewAll()
        }
        cell.vidupDidEnd = { (endedVidup) in
            self.remove(vidup: endedVidup)
        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        (cell as! HomePageVidupClnCell).setup(with: self.list[indexPath.item])
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(self.limit, self.list.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let theAttributes: UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
//        self.didSelectViewAll?(theAttributes.frame)
//        return
        if self.isLastItem(indexPath.item) {
            self.didSelectViewAll?(theAttributes.frame)
        } else {
            self.didSelect?(self.list[indexPath.item], theAttributes.frame)
        }
    }
}
