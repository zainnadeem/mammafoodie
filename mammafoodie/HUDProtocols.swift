//
//  HUDProtocols.swift
//

import UIKit


protocol HUDRenderer {}

extension HUDRenderer {
    
    func showAlert(title:String = "",message:String, okButtonText:String = "OK",cancelButtonText:String? = nil, handler: @escaping (_ succeeded:Bool)->() = {_ in  }) {
        
        var alertController : UIAlertController
        alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        if let cancelText = cancelButtonText{
            alertController.addAction(UIAlertAction(title: cancelText, style: UIAlertActionStyle.default, handler: { finished in
                
                handler(false)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: okButtonText, style: UIAlertActionStyle.default, handler: { finished in
            
            handler(true)
        }))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func showActivityIndicator() {
            self.hideActivityIndicator()
            let delegate = (UIApplication.shared.delegate as! AppDelegate)
            if delegate.activityIndicatorView == nil {
                if let window = delegate.window{
                    
                    let bgView = UIView(frame: window.frame)
                    bgView.backgroundColor = .black
                    bgView.alpha = 0.5
                    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
                    activityIndicator.center = window.center
                    bgView.addSubview(activityIndicator)
                    delegate.activityIndicatorView = bgView
                    activityIndicator.startAnimating()
                    window.addSubview(delegate.activityIndicatorView!)
                    window.bringSubview(toFront: delegate.activityIndicatorView!)
                }
            }
    }
    
    func hideActivityIndicator() {
   
      
            let delegate = (UIApplication.shared.delegate as! AppDelegate)
            if delegate.activityIndicatorView != nil {
                delegate.activityIndicatorView?.removeFromSuperview()
                delegate.activityIndicatorView = nil
            }
        
    }
}


