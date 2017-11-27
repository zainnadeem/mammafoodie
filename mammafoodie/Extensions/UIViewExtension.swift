//
//  UIViewExtension.swift
//  mammafoodie
//
//  Created by Arjav Lad on 20/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    enum GradientDirection {
        case topToBottom, bottomToTop, leftToRight, rightToLeft
    }
    
    func startPoint(for direction : GradientDirection) -> CGPoint{
        switch direction {
        case .topToBottom, .leftToRight:
            return CGPoint(x: 0.5, y: 0.0)
            
        case .bottomToTop:
            return CGPoint(x: 0, y: 1)
            
        case .rightToLeft:
            return CGPoint(x: 1, y: 0)
        }
    }
    
    func endPoint(for direction : GradientDirection) -> CGPoint{
        switch direction {
        case .topToBottom, .rightToLeft:
            return CGPoint(x: 0, y: 1)
            
        case .leftToRight, .bottomToTop:
            return CGPoint(x: 1, y: 0)
            
        }
    }
    
    func applyGradient(colors: [UIColor], direction: GradientDirection = .topToBottom) -> Void {
        self.removeGradient()
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        
        gradientLayer.startPoint = self.startPoint(for: direction)
        gradientLayer.endPoint = self.endPoint(for: direction)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func removeGradient() {
        if let subLayers = self.layer.sublayers {
            for subLayer in subLayers {
                if let gradLayer = subLayer as? CAGradientLayer {
                    gradLayer.removeFromSuperlayer()
                }
            }
        }
    }
    
    func addGradienBorder(colors:[UIColor] , direction : GradientDirection = .topToBottom, borderWidth width : CGFloat = 1.0, animated : Bool = true, animationDuration : CFTimeInterval = 0.27) {
        self.removeGradient()
        let gradientLayer = CAGradientLayer()
        
        if self.clipsToBounds {
            gradientLayer.frame =  CGRect(origin: CGPoint.zero, size: self.bounds.size)
        } else {
            gradientLayer.frame =  CGRect(origin: CGPoint.init(x: width * -1, y: width * -1), size: CGSize.init(width: self.bounds.size.width + width, height: self.bounds.size.height + width))
        }
        
        gradientLayer.colors = colors.map({$0.cgColor})
        
        gradientLayer.startPoint = self.startPoint(for: direction)
        gradientLayer.endPoint = self.endPoint(for: direction)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = UIBezierPath.init(roundedRect: gradientLayer.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.cornerRadius = self.layer.cornerRadius
        gradientLayer.mask = shapeLayer
        
        if animated {
            let fadeAnimation = CABasicAnimation(keyPath: "opacity")
            fadeAnimation.fromValue = 0
            fadeAnimation.toValue = 1.0
            fadeAnimation.duration = animationDuration
            fadeAnimation.repeatCount = 1
            
            gradientLayer.opacity = 1.0
            gradientLayer.add(fadeAnimation, forKey: "FadeAnimation")
        }
        
        self.layer.addSublayer(gradientLayer)
    }
    
}
