//
//  UIViewExtention.swift
//  mammafoodie
//
//  Created by Arjav Lad on 16/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation

extension UIView {
    enum GradientDirection {
        case leftToRight
        case rightToLeft
        case topToBottom
        case bottomToTop
    }
    
    fileprivate func getGradientLayer() -> CAGradientLayer? {
        if let subLays = self.layer.sublayers {
            for subLayer in subLays {
                if let grad = subLayer as? CAGradientLayer {
                    return grad
                }
            }
        }
        return nil
    }
    
    func removeGradient() {
        if let gradientLayer = self.getGradientLayer() {
           gradientLayer.removeFromSuperlayer()
        }
    }
    
    func applyGradient(at locations: [NSNumber]?, with colors: [CGColor], in direction: GradientDirection) {
        self.removeGradient()
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.bounds = self.bounds
        gradientLayer.locations = locations
        gradientLayer.colors = colors
        switch direction {
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        default:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            break
        }
        gradientLayer.frame.origin = .zero
        self.layer.addSublayer(gradientLayer)
        
        let layerB = CALayer.init()
        layerB.bounds = self.bounds
        layerB.frame.origin = .zero
        layerB.backgroundColor = UIColor.black.cgColor
        self.layer.addSublayer(layerB)
        self.layoutIfNeeded()
    }
}
