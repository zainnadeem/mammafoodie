import UIKit
import DZNEmptyDataSet
//import TRMosaicLayout

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - View lifecycle
    
    @IBAction func populateNewsfeed(_ sender: Any) {
        
//        let dData = DummyData.sharedInstance
        
//        dData.populateNewsfeed { (newsfeed) in
//            
//            
//        }
//        
//        _ = dData.getUserForProfilePage()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.liveVideoCollectionView.delegate = self
        self.liveVideoCollectionView.dataSource = self
        self.liveVideoCollectionView.emptyDataSetDelegate = self
        self.liveVideoCollectionView.emptyDataSetSource = self
        self.output.loadLiveVideos()
        
//        let mosaicLayout = TRMosaicLayout()
//        self.liveVideoCollectionView.collectionViewLayout = mosaicLayout
//        mosaicLayout.delegate = self
        
//        liveVideoCollectionView.register(UINib(nibName: "MosaicCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MosaicCollectionCell.reuseIdentifier)
//        liveVideoCollectionView.register(MosaicCollectionCell.self, forCellWithReuseIdentifier: MosaicCollectionCell.reuseIdentifier)
        
        
        let customLayout = CustomLayout()
        self.liveVideoCollectionView.collectionViewLayout = customLayout
        
        liveVideos = LiveVideoMainPage.Response()
        
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MosaicCollectionCell", for: indexPath) as! MosaicCollectionCell
        
        cell.setViewProperties()
        cell.media = liveVideos.arrayOfLiveVideos[indexPath.row]
        
        //Arrange views depending on specific cells
//        if indexPath.item % 3 != 0 {
//            cell.setSmallCellConstraints()
//            
//            
//
//        }else{
//            cell.setLargeCellContraints()
//            
//        }
        
        let attribute = collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath)
        
        if attribute!.zIndex == 1 {
            cell.setLargeCellContraints()
        } else {
            cell.setSmallCellConstraints()
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liveVideos.arrayOfLiveVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let dish: MFDish = self.liveVideos.arrayOfLiveVideos[indexPath.item] {
            self.performSegue(withIdentifier: "segueShowLiveVideoDetails", sender: dish)
        }
    }
    
}

extension LiveVideoMainPageViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.init(string: "No live video found", attributes: [NSFontAttributeName: UIFont.MontserratLight(with: 15)!])
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 20
    }

}


//// Mark: - Mosaic CollectionView Flow Layout
//extension LiveVideoMainPageViewController: TRMosaicLayoutDelegate {
//    
//    func collectionView(_ collectionView:UICollectionView, mosaicCellSizeTypeAtIndexPath indexPath:IndexPath) -> TRMosaicCellType {
//        
////        if indexPath.item > 5{
////            return TRMosaicCellType.small
////        }
//        
//        return indexPath.item % 3 == 0 ? TRMosaicCellType.big : TRMosaicCellType.small
//    }
//    
//    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: TRMosaicLayout, insetAtSection:Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
//    }
//    
//    func heightForSmallMosaicCell() -> CGFloat {
//        return 200
//    }
//    
//}


