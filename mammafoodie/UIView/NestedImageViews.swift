//
//  NestedImageViews.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 04/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

struct CascadingViews {
    
   static func imageViews(withUsers users:[MFUser] , size:CGFloat) -> UIStackView {
        
        let limit = 3 //Max number of images to show in UI
        
        var imageViews = [UIView]()
        
        for (index,user) in users.enumerated() {
            
            let imageView = UIImageView()
            
            if let urlString = user.picture, let url = URL(string: urlString){
                imageView.sd_setImage(with: url, placeholderImage: UIImage()) //FIXME: -  Set placeholder
            } else {
                imageView.image = UIImage() //FIXME: - PlaceHolder
            }
            
            imageView.layer.cornerRadius = size/2
            imageView.clipsToBounds = true
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            imageView.widthAnchor.constraint(equalToConstant: size).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: size).isActive = true
            
            imageViews.append(imageView)
            
            if index == 2 && users.count > limit { //Only add first 3 images
                
                let label = UILabel()
                label.widthAnchor.constraint(equalToConstant: size).isActive = true
                label.heightAnchor.constraint(equalToConstant: size).isActive = true
                label.text = "+\(users.count - limit)"
                label.textColor = .white
                label.backgroundColor = .orange
                label.layer.cornerRadius = size/2
                label.clipsToBounds = true
                label.font = UIFont.MontserratSemiBold(with: 14)
                imageViews.append(label)
                
                break
            }
        }
        
        let stackView = UIStackView(arrangedSubviews: imageViews)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.spacing = -size/2
        
        for subView in stackView.arrangedSubviews{
            stackView.sendSubview(toBack: subView)
        }
        
        
        return stackView
    }

}
    


