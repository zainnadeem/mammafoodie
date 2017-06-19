import UIKit

class HomePageVidupsCollectionViewAdapter: HomePageCollectionViewAdapter, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var vidups: [MFMedia] = []
    
    func createStaticData() {
        self.vidups.append(self.vidup(with: String(describing: "-1")))
        for index in 1...20 {
            self.vidups.append(self.vidup(with: String(describing: index)))
        }
    }
    
    func vidup(with id: String) -> MFMedia {
        let media1: MFMedia = MFMedia()
        media1.type = .vidup
        media1.id = id
        media1.contentId = id
        return media1
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
        cell.setup(with: self.vidups[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vidups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelect?(self.vidups[indexPath.item])
    }
}
