
import Foundation

protocol RegisterAdapterDelegate{
    
//    func RegisterAdapter(View:UIViewController)
    
}


class RegisterAdapter:NSObject, UITextFieldDelegate {
    
    var nameTextField: UITextField!
    var emailTextFeild: UITextField!
    var passTextFeild: UITextField!
    var nameImageView: UIImageView!
    var emailImageView: UIImageView!
    var passImageView: UIImageView!
    var viewNameIcon: UIView!
    var viewEmailIcon: UIView!
    var viewPasswordIcon: UIView!


    
    var RegisterTextFeild:UITextField? {
        didSet{
            RegisterTextFeild?.delegate = self
        }
    }
    
    var delegate:RegisterAdapter?
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if nameTextField == textField {
            nameImageView.image = UIImage(named: "Nameselect")
            emailTextChange()
            PassTextChangeImage()
        }
        if emailTextFeild == textField {
            emailImageView.image = UIImage(named: "username")
            nameTextChangeImage()
            PassTextChangeImage()
        }
        if passTextFeild == textField {
            passImageView.image = UIImage(named: "Password")
            emailTextChange()
            nameTextChangeImage()
        }
    }

    
    
    func nameTextChangeImage() {
        if nameTextField.text == "" {
            nameImageView.image = UIImage(named: "Name")
        }
        else {
            nameImageView.image = UIImage(named: "Nameselect")
        }
    }
    
    func emailTextChange() {
        if emailTextFeild.text == "" {
            emailImageView.image = UIImage(named: "unselectuser")
        }
        else {
            emailImageView.image = UIImage(named: "username")
        }
    }
    
    func PassTextChangeImage() {
        
        if passTextFeild.text == "" {
            passImageView.image = UIImage(named: "unselectpass")
        }
        else {
            passImageView.image = UIImage(named: "Password")
        }
    }
    
    
    func setupTextfeildView() {
        nameTextField.layer.cornerRadius = 5
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.clear.cgColor
        
        // let color: UIColor = #colorLiteral(red: 0.428863733, green: 0.6729379252, blue: 0.6100127551, alpha: 1)
        
        emailTextFeild.layer.cornerRadius = 5
        emailTextFeild.layer.borderWidth = 1
        emailTextFeild.layer.borderColor = UIColor.clear.cgColor
        
        passTextFeild.layer.cornerRadius = 5
        passTextFeild.layer.borderWidth = 1
        passTextFeild.layer.borderColor = UIColor.clear.cgColor
        
        
        nameTextField.delegate = self
        passTextFeild.delegate = self
        emailTextFeild.delegate = self
        
        self.nameTextField.leftView = self.viewNameIcon
        self.nameTextField.leftViewMode = .always
        
        self.emailTextFeild.leftView = self.viewEmailIcon
        self.emailTextFeild.leftViewMode = .always
        
        self.passTextFeild.leftView = self.viewPasswordIcon
        self.passTextFeild.leftViewMode = .always

    }

    
}
