import UIKit
import SafariServices

protocol LoginRouterInput {
    func openSegue(_ segue: UIStoryboardSegue)
}


class LoginRouter: LoginRouterInput {
    
    weak var viewController: LoginViewController!
    
    // MARK: - Navigation
    
    func openSegue(_ segue: UIStoryboardSegue) {
        
        guard let identifier = segue.identifier else {
            assertionFailure("Segue had no identifier")
            return
        }
        
        guard let identifierCase = LoginViewController.ViewControllerSegue(rawValue: identifier) else {
            assertionFailure("identifier case not found")
            return
        }
        
        switch identifierCase  {
        case .privacyPolicy:
            self.openPrivacyPolicy()
        case .terms:
            self.openTermsAndConditions()
        default :
            print("identifier case not found")
        }
        
    }

    // Mark: - Privacy Policy
    
    func openPrivacyPolicy(){
        let safariVC = SFSafariViewController(url: NSURL(string: "https://www.google.co.in/?gfe_rd=cr&ei=0UU5Wfj6GsGL8QfN1aaoDQ")! as URL)
        viewController.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = viewController
    }
    
    func openTermsAndConditions(){
        let safariVC = SFSafariViewController(url: NSURL(string: "https://www.yahoo.com")! as URL)
        viewController.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = viewController
    }
}
