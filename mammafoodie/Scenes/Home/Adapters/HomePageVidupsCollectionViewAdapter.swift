import UIKit

class HomePageVidupsCollectionViewAdapter: HomePageCollectionViewAdapter, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var vidups: [MFMedia] = []
    
    func createStaticData() {
        self.vidups.append(self.vidup(with: String(describing: "-1")))
        self.vidups.append(self.vidup(with: String(describing: 0)))
        self.vidups.append(self.vidup(with: String(describing: 1)))
        self.vidups.append(self.vidup(with: String(describing: 2)))
        self.vidups.append(self.vidup(with: String(describing: 3)))
        self.vidups.append(self.vidup(with: String(describing: 4)))
        self.vidups.append(self.vidup(with: String(describing: 5)))
        self.vidups.append(self.vidup(with: String(describing: 6)))
        self.vidups.append(self.vidup(with: String(describing: 7)))
        self.vidups.append(self.vidup(with: String(describing: 8)))
        self.vidups.append(self.vidup(with: String(describing: 9)))
        self.vidups.append(self.vidup(with: String(describing: 10)))
        self.vidups.append(self.vidup(with: String(describing: 11)))
        self.vidups.append(self.vidup(with: String(describing: 12)))
        self.vidups.append(self.vidup(with: String(describing: 13)))
        self.vidups.append(self.vidup(with: String(describing: 14)))
        self.vidups.append(self.vidup(with: String(describing: 15)))
        self.vidups.append(self.vidup(with: String(describing: 16)))
        self.vidups.append(self.vidup(with: String(describing: 17)))
        self.vidups.append(self.vidup(with: String(describing: 18)))
        self.vidups.append(self.vidup(with: String(describing: 19)))
        self.vidups.append(self.vidup(with: String(describing: 30)))
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
        if self.vidups[indexPath.item] == self.vidups.last {
            self.didSelectViewAll?()
        } else {
            self.didSelect?(self.vidups[indexPath.item])
        }
    }
}
