import UIKit

protocol LiveVideoMainPageViewControllerInput {
    func displayLiveVideos(_ response: LiveVideoMainPage.Response)
}

protocol LiveVideoMainPageViewControllerOutput {
    func loadLiveVideos()
    
}

class LiveVideoMainPageViewController: UIViewController,  LiveVideoMainPageViewControllerInput{
    
    var output: LiveVideoMainPageViewControllerOutput!
    var router: LiveVideoMainPageRouter!
    var liveVideos: LiveVideoMainPage.Response!
    
    //Create outlet to collectionview here. For now use dummy property.
    var liveVideoCollectionView = UICollectionView()
    //
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        LiveVideoMainPageConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.liveVideoCollectionView.delegate = self
        self.liveVideoCollectionView.dataSource = self
        self.output.loadLiveVideos()
        
    }
    
    // Mark: - Fetch Live Vids
    
    func displayLiveVideos(_ response: LiveVideoMainPage.Response) {
        liveVideos = response
        liveVideoCollectionView.reloadData()
    }
    
}

// Mark: - CollectionView

extension LiveVideoMainPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveVideoCollectionViewCell", for: indexPath) as! LiveVideoCollectionViewCell
        cell.title.text = liveVideos.arrayOfLiveVideos[indexPath.row].contentId
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liveVideos.arrayOfLiveVideos.count
    }
}
