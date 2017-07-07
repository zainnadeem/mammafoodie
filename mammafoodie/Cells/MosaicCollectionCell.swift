//
//  MosaicCollectionCell.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 05/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class MosaicCollectionCell: UICollectionViewCell {

    static let reuseIdentifier = "MosaicCollectionCell"
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var btnProfileImage: UIButton!
    @IBOutlet weak var btnNumberOfViews: UIButton!
    @IBOutlet weak var btnTimeLeft: UIButton!
    @IBOutlet weak var screenShotImageView: UIImageView!
    @IBOutlet weak var btnUsername: UIButton!
    
    //    @IBOutlet var smallCellConstraints: [NSLayoutConstraint]!
    //    @IBOutlet var largeCellConstraints: [NSLayoutConstraint]!
    
    
    @IBOutlet weak var topStackView: UIStackView!
    
    @IBOutlet weak var bottomStackView: UIStackView!
    
    var media: MFDish! {
        didSet {
            self.updateUI()
        }
    }
    
    
    func updateUI(){
        
        do {
            if let coverURL = self.media.mediaURL {
                screenShotImageView.sd_setImage(with: coverURL, placeholderImage: UIImage(named: "Image-1"))
            }
            
//            screenShotImageView.image = UIImage(named: "Image-1")
        } catch {
            print(error.localizedDescription)
        }
        
        //        btnProfileImage.setImage(UIImage(named: self.media.user.picture!), for: .normal)
        //        btnNumberOfViews.setTitle(String(self.media.numberOfViewers), for: .normal)
        //
        //        //need to figure out date
        ////        btnTimeLeft.titleLabel?.text = String(self.media.e)
        //        btnUsername.setTitle(self.media.user.name!, for: .normal)
        //        self.title.text = self.media.dish.name!
        //
        //        if self.media.type == .liveVideo {
        //            btnTimeLeft.isHidden = true
        //
        //        }else{
        //            btnTimeLeft.isHidden = false
        //        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setViewProperties()
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
        //        btnNumberOfViews.isHidden = false
        //        for con in self.smallCellConstraints{
        //            con.isActive = false
        //        }
        //
        //        for con in self.largeCellConstraints{
        //            con.isActive = true
        //        }
        
        topStackView.axis = .horizontal
        bottomStackView.axis = .horizontal
        btnNumberOfViews.contentHorizontalAlignment = .right
        
    }
    
    func setSmallCellConstraints(){
        //        btnNumberOfViews.isHidden = true
        btnUsername.titleLabel?.adjustsFontForContentSizeCategory = true
        //
        //        for con in self.largeCellConstraints{
        //            con.isActive = false
        //        }
        //        
        //        for con in self.smallCellConstraints {
        //            con.isActive = true
        //        }
        
        
        topStackView.axis = .vertical
        bottomStackView.axis = .vertical
        btnNumberOfViews.contentHorizontalAlignment = .left
        
    }


}
