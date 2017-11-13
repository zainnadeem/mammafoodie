import UIKit

protocol RequestDishViewControllerInput {
    func dishRequestCompletion(success:Bool,message:String)
}

protocol RequestDishViewControllerOutput {
    func RequestDishes(dish:MFDish,quantity:String)

}

class RequestDishViewController: UIViewController, RequestDishViewControllerInput,HUDRenderer {
    
    var output: RequestDishViewControllerOutput!
    var router: RequestDishRouter!
    
    
    
    @IBOutlet weak var dishNameTxt: UITextField!
    
    @IBOutlet weak var dishNumberTxt: UITextField!
    
    var dish:MFDish?
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        RequestDishConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dishNameTxt.text = self.dish?.name
        self.dishNumberTxt.keyboardType = .numberPad
    }
    
    // MARK: - Event handling
    
    @IBAction func sendRequestBtn(_ sender: Any) {
        
        guard self.dishNumberTxt.text != nil && self.dishNumberTxt.text != "" else {return}
        
        self.output.RequestDishes(dish: self.dish!, quantity: self.dishNumberTxt.text!)
    }
    @IBAction func cancelRequest(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Input
    
    func dishRequestCompletion(success:Bool,message:String){
        if success {
            showAlert(message: message, okButtonText: "OK", handler: { (success) in
                self.dismiss(animated: true, completion: nil)
            })
            
        } else {
            self.showAlert(message: message)
        }
    }
    
    // MARK: - Display logic
    @IBAction func chatBtn(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatListViewController") as! ChatListViewController
//        present(vc, animated: true, completion: nil)
    }
    
}
