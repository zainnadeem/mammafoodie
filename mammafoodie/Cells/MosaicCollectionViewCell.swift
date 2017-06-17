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

    func setViewProperties(){
        
        
        //sets properties for buttons inside cell
        let buttons : [UIButton] = [btnProfileImage, btnNumberOfViews, btnTimeLeft, btnUsername]
        
        for button in buttons {
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.layer.shadowRadius = 3
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowOpacity = 0.5
            button.layer.masksToBounds = false
            button.imageView?.contentMode = .scaleAspectFit
        }

        btnProfileImage.contentMode = .scaleAspectFit
        btnProfileImage.imageView?.layer.borderWidth = 0
        btnProfileImage.imageView?.layer.masksToBounds = false
        btnProfileImage.imageView?.layer.borderColor = UIColor.white.cgColor
        btnProfileImage.imageView?.layer.cornerRadius = btnProfileImage.frame.height/2
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
