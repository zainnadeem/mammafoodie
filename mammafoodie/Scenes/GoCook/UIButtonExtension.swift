//
//  UIButtonExtension.swift
//  mammafoodie
//
//  Created by Arjav Lad on 19/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation
import UIKit


extension UIButton {
    
    enum GradeintDirection {
        case topToBottom, bottomToTop, leftToRight, rightToLeft
    }
    
    func applyGradient(colors: [UIColor], direction: GradeintDirection = .topToBottom) -> Void {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        switch direction {
        case .topToBottom:
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            break
            
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            break
            
        case .leftToRight:
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            break
            
        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            break
        }
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func alignContentVerticallyByCenter(offset:CGFloat = 10) {
        let buttonSize = frame.size
        
        if let titleLabel = titleLabel,
            let imageView = imageView {
            
            if let buttonTitle = titleLabel.text,
                let image = imageView.image {
                let titleString:NSString = NSString(string: buttonTitle)
                let titleSize = titleString.size(attributes: [ NSFontAttributeName : titleLabel.font ])
                let buttonImageSize = image.size
                
                let topImageOffset = (buttonSize.height - (titleSize.height + buttonImageSize.height + offset)) / 2
                let leftImageOffset = (buttonSize.width - buttonImageSize.width) / 2
                imageEdgeInsets = UIEdgeInsetsMake(topImageOffset, leftImageOffset, 0, 0)
                
                let titleTopOffset = topImageOffset + offset + buttonImageSize.height
                let leftTitleOffset = (buttonSize.width - titleSize.width) / 2 - image.size.width
                
                titleEdgeInsets = UIEdgeInsetsMake(titleTopOffset, leftTitleOffset, 0, 0)
            }
        }
    }
}

extension UIButton {
    func set(image anImage: UIImage?, title: String!, titlePosition: UIViewContentMode, additionalSpacing: CGFloat, state: UIControlState){
        self.imageView?.contentMode = .center
        self.setImage(anImage, for: state)
        
        positionLabelRespectToImage(title: title, position: titlePosition, spacing: additionalSpacing)
        
        self.titleLabel?.contentMode = .center
        self.setTitle(title, for: state)
    }
    
    private func positionLabelRespectToImage(title: String!, position: UIViewContentMode, spacing: CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = title.size(attributes: [NSFontAttributeName: titleFont!])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: spacing, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: -spacing, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
}

