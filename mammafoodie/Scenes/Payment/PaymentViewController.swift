
import UIKit

class PaymentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var paymentCollectionView: UICollectionView!
    
    @IBOutlet weak var pickButton: UIButton!
    
    @IBOutlet weak var deliveryButton: UIButton!
    
    @IBOutlet weak var confirmButton: UIButton!
   
    @IBOutlet weak var postmateButton: UIButton!
    
    @IBOutlet weak var uberButton: UIButton!
   
    @IBOutlet weak var addressView: UIView!
    
    @IBOutlet weak var deliveryText: UILabel!
    
    @IBOutlet weak var choosedeliveryText: UILabel!
    
    @IBOutlet weak var delveryaddTextField: UITextField!
    
    @IBOutlet weak var pickTime: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        paymentCollectionView.delegate = self
        paymentCollectionView.dataSource = self
        
        self.pickButton.layer.cornerRadius = self.pickButton.frame.height/2
        pickButton.layer.borderColor =   #colorLiteral(red: 0.4588235294, green: 0.5333333333, blue: 0.6196078431, alpha: 1).cgColor

        pickButton.layer.borderWidth = 1
        self.deliveryButton.layer.cornerRadius = self.deliveryButton.frame.height/2
        deliveryButton.layer.borderColor =   #colorLiteral(red: 0.4588235294, green: 0.5333333333, blue: 0.6196078431, alpha: 1).cgColor

        deliveryButton.layer.borderWidth = 1
        self.confirmButton.layer.cornerRadius = self.confirmButton.frame.height/2
       
        self.postmateButton.layer.cornerRadius = self.postmateButton.frame.height/2
        postmateButton.layer.borderColor =  #colorLiteral(red: 0.4588235294, green: 0.5333333333, blue: 0.6196078431, alpha: 1).cgColor
        postmateButton.layer.borderWidth = 1
        
        self.uberButton.layer.cornerRadius = self.uberButton.frame.height/2
        uberButton.layer.borderColor =  #colorLiteral(red: 0.4588235294, green: 0.5333333333, blue: 0.6196078431, alpha: 1).cgColor
        uberButton.layer.borderWidth = 1
        
        addressView.isHidden = true
        confirmButton.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: paymentCollectionView.frame.size.width - 20, height: paymentCollectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = paymentCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        if cell.isSelected {
            cell.backgroundColor = .gray
        } else {
            cell.backgroundColor = .red
        }
        return cell
    }
    
    @IBAction func pickupAddress(_ sender: Any) {
        
        pickButton.layer.borderColor =  #colorLiteral(red: 1, green: 0.4620534182, blue: 0.1706305146, alpha: 1).cgColor

        deliveryButton.layer.borderColor =  #colorLiteral(red: 0.4588235294, green: 0.5333333333, blue: 0.6196078431, alpha: 1).cgColor

        addressView.isHidden = false
        confirmButton.isHidden = false
        deliveryText.text! = "Chefs Address"
        choosedeliveryText.text! = "Pick up time"
        delveryaddTextField.layer.backgroundColor = UIColor.clear.cgColor
        delveryaddTextField.isUserInteractionEnabled = false
        pickTime.isHidden = false
        uberButton.isHidden = true
        postmateButton.isHidden = true
    }
    @IBAction func deliveryAddress(_ sender: Any) {
        
        pickButton.layer.borderColor =  #colorLiteral(red: 0.4588235294, green: 0.5333333333, blue: 0.6196078431, alpha: 1).cgColor
        
        deliveryButton.layer.borderColor =  #colorLiteral(red: 1, green: 0.4620534182, blue: 0.1706305146, alpha: 1).cgColor

        pickTime.isHidden = true
        uberButton.isHidden = false
        postmateButton.isHidden = false
        
        
        addressView.isHidden = false
        confirmButton.isHidden = false
        deliveryText.text! = "Delivery Address"
        choosedeliveryText.text! = "Choose Delivery Address"
        delveryaddTextField.isUserInteractionEnabled = true
        delveryaddTextField.layer.cornerRadius = 5
        delveryaddTextField.layer.borderColor = UIColor.clear.cgColor
        delveryaddTextField.layer.backgroundColor = #colorLiteral(red: 0.9782952666, green: 0.9755677581, blue: 0.9876046777, alpha: 1).cgColor

    }
    
    @IBAction func uberButnActn(_ sender: Any) {
        uberButton.layer.borderColor =  #colorLiteral(red: 1, green: 0.4620534182, blue: 0.1706305146, alpha: 1).cgColor
        postmateButton.layer.borderColor =  #colorLiteral(red: 0.4588235294, green: 0.5333333333, blue: 0.6196078431, alpha: 1).cgColor


    }
    
    @IBAction func postButnActn(_ sender: Any) {
        
        postmateButton.layer.borderColor =  #colorLiteral(red: 1, green: 0.4620534182, blue: 0.1706305146, alpha: 1).cgColor
        uberButton.layer.borderColor =  #colorLiteral(red: 0.4588235294, green: 0.5333333333, blue: 0.6196078431, alpha: 1).cgColor


    }
    
}
