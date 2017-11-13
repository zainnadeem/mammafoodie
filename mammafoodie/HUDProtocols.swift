//
//  HUDProtocols.swift
//

import UIKit


protocol HUDRenderer { }

extension HUDRenderer {
    
    func showAlert(title: String = "", message: String, okButtonText: String = "OK", cancelButtonText: String? = nil, handler: @escaping ((Bool) -> ()) = { _ in }) {
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
        if let top = UIApplication.shared.keyWindow?.rootViewController {
            if let nav = top as? UINavigationController {
                if let topMost = self.getTopVC(for: nav) {
                    topMost.present(alertController, animated: true, completion: nil)
                }
            } else {
                top.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    private func getTopVC(for navigation: UINavigationController) -> UIViewController? {
        if let topMost = navigation.viewControllers.last {
            if let presented = topMost.presentedViewController as? UINavigationController {
                return self.getTopVC(for: presented)
            } else if let presented = topMost.presentedViewController {
                if let prepresented = presented.presentedViewController {
                    if let preNav = prepresented.presentedViewController as? UINavigationController {
                        return self.getTopVC(for: preNav)
                    } else {
                        return prepresented
                    }
                } else {
                    return presented
                }
            }
        }
        return nil
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


