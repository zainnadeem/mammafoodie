import UIKit

class HomePageVidupsCollectionViewAdapter: HomePageCollectionViewAdapter, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func loadVidup() {
        let worker: VidupListWorker = VidupListWorker()
        worker.getList { (dishes) in
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
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomePageVidupClnCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageVidupClnCell", for: indexPath) as! HomePageVidupClnCell
        cell.setup(with: self.list[indexPath.item])
        cell.vidupDidEnd = { (endedVidup) in
            self.remove(vidup: endedVidup)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.list[indexPath.item] == self.list.last {
            self.didSelectViewAll?()
        } else {
            let theAttributes: UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
            self.didSelect?(self.list[indexPath.item], theAttributes.frame)
        }
    }
}
