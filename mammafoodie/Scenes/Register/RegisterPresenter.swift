import UIKit

protocol RegisterPresenterInput {
    func signUpCompletion(errorMessage:String?)
    func updateShadow()
}

protocol RegisterPresenterOutput: class {

}

class RegisterPresenter: RegisterPresenterInput {
    weak var output: RegisterPresenterOutput!
    weak var viewcontroller: RegisterViewController?
    var shapeLayer: CAShapeLayer!
    

    
    // MARK: - Presentation logic
    func updateShadow()
    {
       updateShadowSetup()
    }
    func signUpCompletion(errorMessage:String?)
    {
        if let errorMessage = errorMessage{
            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.viewcontroller?.showAlert(alertController: alertController)
        } else {
            self.viewcontroller?.navigateHomePage()
        }

    }
    
    func updateShadowSetup() {
        if self.shapeLayer == nil {
            self.viewcontroller?.view.layoutIfNeeded()
            self.shapeLayer = CAShapeLayer()
            self.shapeLayer.shadowColor = #colorLiteral(red: 1, green: 0.7725490196, blue: 0.6, alpha: 1).cgColor
            self.shapeLayer.shadowOpacity = 0.7
            self.shapeLayer.shadowRadius = 7
            
            var shadowFrame: CGRect = self.viewcontroller!.registerBtn.frame
            shadowFrame.origin.x += 35
            shadowFrame.origin.y += 30
            shadowFrame.size.width -= 70
            //            shadowFrame.size.height -= 8
            
            self.shapeLayer.shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: self.self.viewcontroller!.registerBtn.layer.cornerRadius).cgPath
            self.shapeLayer.shadowOffset = CGSize(width: 0, height: 1)
            
            self.viewcontroller!.registerBtn.superview?.layer.insertSublayer(self.shapeLayer, at: 0)
        }
    }

}
