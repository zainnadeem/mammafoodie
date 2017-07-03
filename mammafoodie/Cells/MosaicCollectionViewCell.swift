import UIKit


class MosaicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var btnProfileImage: UIButton!
    @IBOutlet weak var btnNumberOfViews: UIButton!
    @IBOutlet weak var btnTimeLeft: UIButton!
    @IBOutlet weak var screenShotImageView: UIImageView!
    @IBOutlet weak var btnUsername: UIButton!
    
    @IBOutlet var smallCellConstraints: [NSLayoutConstraint]!
    @IBOutlet var largeCellConstraints: [NSLayoutConstraint]!
    
    var dish: MFDish! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI(){
        self.screenShotImageView.sd_cancelCurrentImageLoad()
        
        self.screenShotImageView.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        if let url: URL = self.dish.mediaURL {
            self.screenShotImageView.contentMode = UIViewContentMode.scaleAspectFill
            self.screenShotImageView.sd_setImage(with: url, completed: { (downloadedImage, error, cacheType, url) in
                if downloadedImage == nil || error != nil {
                    self.setLogo()
                }
            })
        } else {
            self.setLogo()
        }
        
        if let url: URL = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: self.dish.user.id) {
            self.btnProfileImage.imageView?.contentMode = UIViewContentMode.scaleAspectFill
            self.btnProfileImage.imageView?.sd_setImage(with: url, completed: { (downloadedImage, error, cacheType, url) in
                if downloadedImage == nil || error != nil {
                    //                    self.setLogo()
                }
            })
        } else {
            //            self.setLogo()
        }
        
        
        self.btnNumberOfViews.setTitle(String(self.dish.numberOfViewers), for: .normal)
        
        //need to figure out date
        //        btnTimeLeft.titleLabel?.text = String(self.media.e)
        self.btnUsername.setTitle(self.dish.user.name!, for: .normal)
        self.title.text = self.dish.name
        
        if self.dish.mediaType == .liveVideo {
            self.btnTimeLeft.isHidden = true
        }else{
            self.btnTimeLeft.isHidden = false
        }
        
    }
    
    func setLogo() {
        self.screenShotImageView.contentMode = UIViewContentMode.center
        self.screenShotImageView.image = UIImage(named: "LogoMammaFoodieWithoutName")!
    }
    
    
    func setViewProperties(){
        //sets properties for buttons inside cell
        let buttons : [UIButton] = [btnNumberOfViews, btnTimeLeft, btnUsername]
        screenShotImageView.contentMode = .scaleAspectFill
        
        
        for button in buttons {
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.layer.shadowRadius = 5
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowOpacity = 1
            button.layer.masksToBounds = false
            button.imageView?.contentMode = .scaleAspectFit
        }
        
        btnUsername.titleLabel?.numberOfLines = 2
        btnUsername.titleLabel?.adjustsFontSizeToFitWidth = false
        
        btnUsername.titleLabel?.lineBreakMode = .byWordWrapping
        
        btnProfileImage.imageView?.contentMode = .scaleAspectFill
        btnProfileImage.layer.shadowRadius = 3
        btnProfileImage.layer.shadowColor = UIColor.blue.cgColor
        btnProfileImage.layer.masksToBounds = false
        btnProfileImage.imageView?.layer.cornerRadius = btnProfileImage.frame.height / 2
        btnProfileImage.imageView?.clipsToBounds = true
        
        title.layer.shadowRadius = 3
        title.layer.shadowColor = UIColor.black.cgColor
        title.layer.shadowOffset = CGSize(width: 0, height: 2)
        title.layer.shadowOpacity = 0.5
        title.layer.masksToBounds = false
        
    }
    
    
    //call these functions based on size of the cell
    func setLargeCellContraints(){
        btnNumberOfViews.isHidden = false
        for con in self.smallCellConstraints{
            con.isActive = false
        }
        
        for con in self.largeCellConstraints{
            con.isActive = true
        }
        
    }
    
    func setSmallCellConstraints(){
        btnNumberOfViews.isHidden = true
        btnUsername.titleLabel?.adjustsFontForContentSizeCategory = true
        
        for con in self.largeCellConstraints{
            con.isActive = false
        }
        
        for con in self.smallCellConstraints {
            con.isActive = true
        }
        
    }
}
