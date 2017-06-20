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
    
    var media: MFMedia! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI(){

        screenShotImageView.image = UIImage(named: self.media.cover_large!)

        btnProfileImage.setImage(UIImage(named: self.media.user.picture!), for: .normal)
        btnNumberOfViews.setTitle(String(self.media.numberOfViewers), for: .normal)
        
        //need to figure out date
//        btnTimeLeft.titleLabel?.text = String(self.media.e)
        btnUsername.setTitle(self.media.user.name!, for: .normal)
        self.title.text = self.media.dish.name!
        
        if self.media.type == .liveVideo {
            btnTimeLeft.isHidden = true
            
        }else{
            btnTimeLeft.isHidden = false
        }
 
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
