import UIKit

extension UIView {
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                let size: CGSize = CGSize(width: self.shadowOffsetWidth, height: self.shadowOffsetHeight)
                self.addShadow(shadowColor: self.shadowColor,
                               shadowOffset: size,
                               shadowOpacity: self.shadowOpacity,
                               shadowRadius: self.shadowRadius)
            }
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let cgColor = layer.shadowColor {
                return UIColor(cgColor: cgColor)
            }
            return nil
        }
        set {
            let size: CGSize = CGSize(width: self.shadowOffsetWidth, height: self.shadowOffsetHeight)
            self.addShadow(shadowColor: self.shadowColor,
                           shadowOffset: size,
                           shadowOpacity: self.shadowOpacity,
                           shadowRadius: self.shadowRadius)
        }
    }
    
    @IBInspectable var shadowOffsetWidth: CGFloat {
        get {
            return layer.shadowOffset.width
        }
        set {
            let size: CGSize = CGSize(width: newValue, height: self.shadowOffsetHeight)
            self.addShadow(shadowColor: self.shadowColor,
                           shadowOffset: size,
                           shadowOpacity: self.shadowOpacity,
                           shadowRadius: self.shadowRadius)
        }
    }
    
    @IBInspectable var shadowOffsetHeight: CGFloat {
        get {
            return layer.shadowOffset.width
        }
        set {
            let size: CGSize = CGSize(width: self.shadowOffsetWidth, height: newValue)
            self.addShadow(shadowColor: self.shadowColor,
                           shadowOffset: size,
                           shadowOpacity: self.shadowOpacity,
                           shadowRadius: self.shadowRadius)
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            let size: CGSize = CGSize(width: self.shadowOffsetWidth, height: self.shadowOffsetHeight)
            self.addShadow(shadowColor: self.shadowColor,
                           shadowOffset: size,
                           shadowOpacity: newValue,
                           shadowRadius: self.shadowRadius)
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            let size: CGSize = CGSize(width: self.shadowOffsetWidth, height: self.shadowOffsetHeight)
            self.addShadow(shadowColor: self.shadowColor,
                           shadowOffset: size,
                           shadowOpacity: self.shadowOpacity,
                           shadowRadius: newValue)
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    
    func addShadow(shadowColor: UIColor?, shadowOffset: CGSize, shadowOpacity: Float, shadowRadius: CGFloat) {
        if self.shadow {
            layer.shadowColor = shadowColor?.cgColor
            layer.shadowOffset = shadowOffset
            layer.shadowOpacity = shadowOpacity
            layer.shadowRadius = shadowRadius
        } else {
            layer.shadowColor = nil
        }
    }
}
