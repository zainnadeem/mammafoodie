import UIKit
import TRMosaicLayout

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
    //
    
    // MARK: - Object lifecycle
    
    @IBOutlet weak var liveVideoCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        LiveVideoMainPageConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    @IBAction func populateNewsfeed(_ sender: Any) {
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.liveVideoCollectionView.delegate = self
        self.liveVideoCollectionView.dataSource = self
        self.output.loadLiveVideos()
        
        let mosaicLayout = TRMosaicLayout()
        self.liveVideoCollectionView.collectionViewLayout = mosaicLayout
        mosaicLayout.delegate = self
        
    }
    
    // Mark: - Fetch Live Vids
    
    func displayLiveVideos(_ response: LiveVideoMainPage.Response) {
        liveVideos = response
        liveVideoCollectionView.reloadData()
    }
    
}

// Mark: - CollectionView Delegate & Datasource

extension LiveVideoMainPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MosaicCollectionViewCell", for: indexPath) as! MosaicCollectionViewCell
        
        cell.setViewProperties()
        cell.dish = liveVideos.arrayOfLiveVideos[indexPath.row]
        
        //Arrange views depending on specific cells
        if indexPath.item % 3 != 0 {
            cell.setSmallCellConstraints()

        }else{
            cell.setLargeCellContraints()
            
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.liveVideos != nil {
            return self.liveVideos.arrayOfLiveVideos.count
        } else {
            return 0
        }
        
    }
}

// Mark: - Mosaic CollectionView Flow Layout
extension LiveVideoMainPageViewController: TRMosaicLayoutDelegate {
    
    func collectionView(_ collectionView:UICollectionView, mosaicCellSizeTypeAtIndexPath indexPath:IndexPath) -> TRMosaicCellType {
        
        return indexPath.item % 3 == 0 ? TRMosaicCellType.big : TRMosaicCellType.small
    }
    
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: TRMosaicLayout, insetAtSection:Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
    
    func heightForSmallMosaicCell() -> CGFloat {
        return 200
    }
    
}


