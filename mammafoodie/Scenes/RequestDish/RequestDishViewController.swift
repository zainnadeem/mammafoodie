import UIKit

protocol RequestDishViewControllerInput {
    
}

protocol RequestDishViewControllerOutput {
    func RequestDishes(dishName:String,dishNo:String)

}

class RequestDishViewController: UIViewController, RequestDishViewControllerInput {
    
    var output: RequestDishViewControllerOutput!
    var router: RequestDishRouter!
    
    
    
    @IBOutlet weak var dishNameTxt: UITextField!
    
    @IBOutlet weak var dishNumberTxt: UITextField!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        RequestDishConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Event handling
    
    @IBAction func sendRequestBtn(_ sender: Any) {
        self.output.RequestDishes(dishName:self.dishNameTxt.text!,dishNo:self.dishNumberTxt.text!)
    }
    @IBAction func cancelRequest(_ sender: Any) {
    }
    // MARK: - Display logic
    @IBAction func chatBtn(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatListViewController") as! ChatListViewController
//        present(vc, animated: true, completion: nil)
    }
    
}
