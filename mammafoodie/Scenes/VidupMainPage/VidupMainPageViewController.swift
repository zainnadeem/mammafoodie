import UIKit

protocol VidupMainPageViewControllerInput {
    func addVideosToVC(_ response: VidupMainPage.Response)
}

protocol VidupMainPageViewControllerOutput {
    func loadVidups()
}

class VidupMainPageViewController: UIViewController, VidupMainPageViewControllerInput {
    
    var output: VidupMainPageViewControllerOutput!
    var router: VidupMainPageRouter!
    var vidups: VidupMainPage.Response!
    
    @IBOutlet weak var vidupCollectionView: UICollectionView!
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        VidupMainPageConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.output.loadVidups()
        self.vidupCollectionView.dataSource = self
        self.vidupCollectionView.delegate = self
    }
    
    func addVideosToVC(_ response: VidupMainPage.Response) {
        vidups = response
    }
    
}

// MARK: - Collection View

extension VidupMainPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VidupCollectionViewCell", for: indexPath) as! VidupCollectionViewCell
        
        cell.title.text = self.vidups.arrayOfVidups[indexPath.row].contentId
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vidups.arrayOfVidups.count
    }
}
