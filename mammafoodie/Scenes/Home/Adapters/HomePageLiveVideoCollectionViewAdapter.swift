import UIKit

class HomePageLiveVideoCollectionViewAdapter: HomePageCollectionViewAdapter, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var liveVideos: [MFMedia] = []
    
    func createStaticData() {
        self.liveVideos.append(self.liveVideo(with: String(describing: -1)))
        for index in 0...20 {
            self.liveVideos.append(self.liveVideo(with: String(describing: index)))
        }
    }
    
    func liveVideo(with id: String) -> MFMedia {
        let media1: MFMedia = MFMedia()
        media1.type = .liveVideo
        media1.id = id
        media1.contentId = id
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
        self.didSelect?(self.liveVideos[indexPath.item])
    }
}
