import UIKit
import TRMosaicLayout

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
        
        let mosaicLayout = TRMosaicLayout()
        self.vidupCollectionView.collectionViewLayout = mosaicLayout
        mosaicLayout.delegate = self
    }
    
    func addVideosToVC(_ response: VidupMainPage.Response) {
        vidups = response
    }
    
}

// MARK: - Collection View
extension VidupMainPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MosaicCollectionViewCell", for: indexPath) as! MosaicCollectionViewCell
        
        //Move to cell once object is established
        cell.setViewProperties()
        cell.title.text = "You Gotta See This!"
        cell.screenShotImageView.image = #imageLiteral(resourceName: "cook")
        cell.screenShotImageView.contentMode = .scaleAspectFill
        cell.btnProfileImage.setImage(#imageLiteral(resourceName: "ProfileImageShot"), for: .normal)
        
        cell.btnUsername.setTitle("Johnny Patel", for: .normal)
        
        
        cell.btnNumberOfViews.setTitle("1234", for: .normal)
        cell.btnTimeLeft.setTitle("21 min", for: .normal)

        //Arrange views depending on specific cells
        if indexPath.item % 3 != 0 {
                cell.setSmallCellConstraints()
                cell.btnNumberOfViews.isHidden = true
        }else{
                cell.setLargeCellContraints()
                
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vidups.arrayOfVidups.count
    }

}

extension VidupMainPageViewController: TRMosaicLayoutDelegate {
    
    func collectionView(_ collectionView:UICollectionView, mosaicCellSizeTypeAtIndexPath indexPath:IndexPath) -> TRMosaicCellType {
        // I recommend setting every third cell as .Big to get the best layout

        return indexPath.item % 3 == 0 ? TRMosaicCellType.big : TRMosaicCellType.small
    }
    
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: TRMosaicLayout, insetAtSection:Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
    
    func heightForSmallMosaicCell() -> CGFloat {
        return smallCellSize
        
    }
    
}






