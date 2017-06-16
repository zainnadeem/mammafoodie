import UIKit

class VidupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var btnProfileImage: UIButton!
    @IBOutlet weak var btnNumberOfViews: UIButton!
    @IBOutlet weak var btnTimeLeft: UIButton!
    @IBOutlet weak var screenShotImageView: UIImageView!
    
    
    lazy var mainLabelStackview     : UIStackView = UIStackView()
    
    @IBOutlet var smallCellConstraints: [NSLayoutConstraint]!

    @IBOutlet var largeCellConstraints: [NSLayoutConstraint]!
    
    func setViewProperties(){
        screenShotImageView.layer.shadowColor = UIColor.black.cgColor
        screenShotImageView.layer.shadowOpacity = 0.25
        
        
        title.layer.shadowRadius = 3
        title.layer.shadowColor = UIColor.black.cgColor
        title.layer.shadowOffset = CGSize(width: 0, height: 2)
        title.layer.shadowOpacity = 0.5
        title.layer.masksToBounds = false
        
        btnNumberOfViews.titleLabel?.layer.shadowRadius = 3
        btnNumberOfViews.titleLabel?.layer.shadowColor = UIColor.black.cgColor
        btnNumberOfViews.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 2)
        btnNumberOfViews.titleLabel?.layer.shadowOpacity = 0.5
        btnNumberOfViews.titleLabel?.layer.masksToBounds = false
        
        btnTimeLeft.titleLabel?.layer.shadowRadius = 3
        btnTimeLeft.titleLabel?.layer.shadowColor = UIColor.black.cgColor
        btnTimeLeft.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 2)
        btnTimeLeft.titleLabel?.layer.shadowOpacity = 0.5
        btnTimeLeft.titleLabel?.layer.masksToBounds = false
        
        
        btnProfileImage.contentMode = .scaleAspectFit
        btnProfileImage.imageView?.layer.borderWidth = 1
        btnProfileImage.imageView?.layer.masksToBounds = false
        btnProfileImage.imageView?.layer.borderColor = UIColor.white.cgColor
        btnProfileImage.imageView?.layer.cornerRadius = btnProfileImage.frame.height/2
        btnProfileImage.imageView?.clipsToBounds = true
        btnProfileImage.layer.shadowRadius = 3
        btnProfileImage.layer.shadowColor = UIColor.black.cgColor
        btnProfileImage.layer.shadowOffset = CGSize(width: 0, height: 2)
        btnProfileImage.layer.shadowOpacity = 0.5
        btnProfileImage.layer.masksToBounds = false
        
    }
    
    
    func setLargeCellContraints(){
        for con in self.smallCellConstraints{
            con.isActive = false
        }
        
        for con in self.largeCellConstraints{
            con.isActive = true
        }

    }
    
    func setSmallCellConstraints(){
        
        for con in self.largeCellConstraints{
            con.isActive = false
        }
        
        for con in self.smallCellConstraints {
            con.isActive = true
        }

    }
}
