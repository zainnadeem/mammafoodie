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
//                    assertionFailure("Segue had no identifier")
                    return
                }
      
        
    }
    
    // Mark: - Privacy Policy
    
    func openSafariVC(with address: LoginViewController.SafariAddresses){
        let safariVC = SFSafariViewController(url: NSURL(string: address.rawValue)! as URL)
        viewController.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = viewController
    }
    
}
