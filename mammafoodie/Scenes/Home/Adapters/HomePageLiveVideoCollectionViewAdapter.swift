import UIKit

class HomePageLiveVideoCollectionViewAdapter: HomePageCollectionViewAdapter, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var liveVideos: [MFMedia] = []
    
    func createStaticData() {
        self.liveVideos.append(self.liveVideo(with: String(describing: -1)))
        self.liveVideos.append(self.liveVideo(with: String(describing: 17)))
        self.liveVideos.append(self.liveVideo(with: String(describing: 8)))
        self.liveVideos.append(self.liveVideo(with: String(describing: 13)))
        self.liveVideos.append(self.liveVideo(with: String(describing: 6)))
        self.liveVideos.append(self.liveVideo(with: String(describing: 5)))
        self.liveVideos.append(self.liveVideo(with: String(describing: 9)))
        self.liveVideos.append(self.liveVideo(with: String(describing: 0)))
        self.liveVideos.append(self.liveVideo(with: String(describing: 10)))
        self.liveVideos.append(self.liveVideo(with: String(describing: 11)))
        self.liveVideos.append(self.liveVideo(with: String(describing: 12)))
        self.liveVideos.append(self.liveVideo(with: String(describing: 2)))
        self.liveVideos.append(self.liveVideo(with: String(describing: 3)))
        self.liveVideos.append(self.liveVideo(with: String(describing: 14)))
        self.liveVideos.append(self.liveVideo(with: String(describing: 15)))
        self.liveVideos.append(self.liveVideo(with: String(describing: 16)))
        self.liveVideos.append(self.liveVideo(with: String(describing: 1)))
        self.liveVideos.append(self.liveVideo(with: String(describing: 18)))
        self.liveVideos.append(self.liveVideo(with: String(describing: 19)))
        self.liveVideos.append(self.liveVideo(with: String(describing: 4)))
        self.liveVideos.append(self.liveVideo(with: String(describing: 20)))
        self.liveVideos.append(self.liveVideo(with: String(describing: 30)))
    }
    
    func liveVideo(with id: String) -> MFMedia {
        let media1: MFMedia = MFMedia()
        media1.type = .liveVideo
        media1.id = id
//        media1.contentId = id
        return media1
    }
    
    func setup(with tableView: UICollectionView) {
        self.collectionView = tableView
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let name: String = "HomePageLiveVideoClnCell"
        self.collectionView.register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.liveVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomePageLiveVideoClnCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageLiveVideoClnCell", for: indexPath) as! HomePageLiveVideoClnCell
        cell.setup(with: self.liveVideos[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.liveVideos[indexPath.item] == self.liveVideos.last {
            self.didSelectViewAll?()
        } else {
            let theAttributes: UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
//            let cellFrameInSuperview: CGRect = collectionView.convert(, to: collectionView.superview)
            self.didSelect?(self.liveVideos[indexPath.item], theAttributes.frame)
        }
    }
}
