import UIKit
//import TRMosaicLayout
import DZNEmptyDataSet

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
    
    lazy var smallCellSize: CGFloat = 242
    
    
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
        self.vidupCollectionView.emptyDataSetDelegate = self
        self.vidupCollectionView.emptyDataSetSource = self
        
//        let mosaicLayout = TRMosaicLayout()
//        self.vidupCollectionView.collectionViewLayout = mosaicLayout
//        mosaicLayout.delegate = self
        
        let customLayout = CustomLayout()
        self.vidupCollectionView.collectionViewLayout = customLayout
        
    }
    
    func addVideosToVC(_ response: VidupMainPage.Response) {
        vidups = response
    }
    
}

// MARK: - Collection View
extension VidupMainPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MosaicCollectionCell", for: indexPath) as! MosaicCollectionCell
        
        //Move to cell once object is established
        cell.media = self.vidups.arrayOfVidups[indexPath.row]
        cell.setViewProperties()
        

        //Arrange views depending on specific cells
//        if indexPath.item % 3 != 0 {
//                cell.setSmallCellConstraints()
//                cell.btnNumberOfViews.isHidden = true
//        }else{
//                cell.setLargeCellContraints()
//                
//        }
       
        let attribute = collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath)
        
        if attribute!.zIndex == 1 { //zIndex of bigCells are set to 1 in custom layout class
            cell.setLargeCellContraints()
        } else {
            cell.setSmallCellConstraints()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vidups.arrayOfVidups.count
    }

}

extension VidupMainPageViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.init(string: "No vidup found", attributes: [NSFontAttributeName: UIFont.MontserratLight(with: 15)!])
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 20
    }

}

//extension VidupMainPageViewController: TRMosaicLayoutDelegate {
//    
//    func collectionView(_ collectionView:UICollectionView, mosaicCellSizeTypeAtIndexPath indexPath:IndexPath) -> TRMosaicCellType {
//        // I recommend setting every third cell as .Big to get the best layout
//
//        return indexPath.item % 3 == 0 ? TRMosaicCellType.big : TRMosaicCellType.small
//    }
//    
//    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: TRMosaicLayout, insetAtSection:Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
//    }
//    
//    func heightForSmallMosaicCell() -> CGFloat {
//        return smallCellSize
//        
//    }
//    
//}
//





