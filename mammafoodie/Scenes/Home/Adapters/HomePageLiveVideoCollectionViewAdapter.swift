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
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomePageLiveVideoClnCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageLiveVideoClnCell", for: indexPath) as! HomePageLiveVideoClnCell
        cell.setup(with: self.list[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as! HomePageLiveVideoClnCell).setup(with: self.list[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.list[indexPath.item] == self.list.last {
            self.didSelectViewAll?()
        } else {
            let theAttributes: UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
            //            let cellFrameInSuperview: CGRect = collectionView.convert(, to: collectionView.superview)
            self.didSelect?(self.list[indexPath.item], theAttributes.frame)
        }
    }
}
