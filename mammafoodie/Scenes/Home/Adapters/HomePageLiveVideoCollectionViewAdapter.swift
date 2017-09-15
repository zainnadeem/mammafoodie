import UIKit

class HomePageLiveVideoCollectionViewAdapter: HomePageCollectionViewAdapter, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func loadLiveVideos() {
        let worker: LiveVideoListWorker = LiveVideoListWorker()
        worker.getList { (dishes) in
            self.list = [self.getFirstCellForCurrentUser()]
            self.list.append(contentsOf: dishes)
            self.collectionView.reloadData()
        }
    }
    
    func setup(with tableView: UICollectionView) {
        self.collectionView = tableView
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let name: String = "HomePageLiveVideoClnCell"
        self.collectionView.register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
        
        self.list = [self.getFirstCellForCurrentUser()]
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(self.limit, self.list.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomePageLiveVideoClnCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageLiveVideoClnCell", for: indexPath) as! HomePageLiveVideoClnCell
        cell.setup(with: self.list[indexPath.item])
        if self.isLastItem(indexPath.item) {
            cell.showViewAll()
        } else {
            cell.hideViewAll()
        }
        return cell
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //        (cell as! HomePageLiveVideoClnCell).setup(with: self.list[indexPath.item])
    //    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let theAttributes: UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)        
        if self.isLastItem(indexPath.item) {
            self.didSelectViewAll?(theAttributes.frame)
        } else {
            self.didSelect?(self.list[indexPath.item], theAttributes.frame)
        }
    }
}
