import Foundation
import UIKit


//MARK: - Add Placeholder
extension UITextView   {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    var textInset : UIEdgeInsets {
        
        get{
            return self.textContainerInset
        }
        set{
            self.textContainerInset = newValue
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    @IBInspectable public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            print(self.textContainerInset)
            let labelX:CGFloat =  self.textContainerInset.left + self.textContainer.lineFragmentPadding
            let labelY:CGFloat = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    func handlePlaceholderVisibility(_ notification:NSNotification){
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.hasText
        }
    }
    
    func updatePlaceholderVisibility(){
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.hasText
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.characters.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        //print(placeholderLabel.frame)
        //self.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handlePlaceholderVisibility), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
}


//MARK: -  convenience method to add toolbar
extension UITextView{
    
    func addDoneToolBarButton(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 20))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneSelector))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
        //self.inputAccessoryView?.tintColor = Utility.appThemeColour
    }
    
    
    func doneSelector(){
        self.resignFirstResponder()
    }
    
    
    func textFieldValidation(string:String,maxLen: Int)-> Bool{
        
        if (self.text?.characters.count)! < maxLen {
            var allowedCharacters = CharacterSet.alphanumerics
            var characterSet = CharacterSet(charactersIn: string)
            
            if allowedCharacters.isSuperset(of: characterSet) {
                return true
            }
            else{
                if string == "@" || string == "."{
                    return true
                }else{
                    allowedCharacters = CharacterSet.whitespacesAndNewlines
                    //allowedSpaces = CharacterSet.whitespaces
                    characterSet = CharacterSet(charactersIn: string)
                    
                    if allowedCharacters.isSuperset(of: characterSet) && self.text.characters.count > 0 {
                        return true
                    }
                    else{
                        return false
                    }
                }
            }
        }
        else{
            let allowedCharacters = CharacterSet.newlines
            let characterSet = CharacterSet(charactersIn: string)
            
            if allowedCharacters.isSuperset(of: characterSet){
                return true
            }else{
                return false
            }
            
        }
        
    }
    
    func textFieldlengthValidation(string:String,maxLen: Int)-> Bool{
        
        if (self.text?.characters.count)! < maxLen {
            return true
        }
        else{
            let allowedCharacters = CharacterSet.newlines
            let characterSet = CharacterSet(charactersIn: string)
            
            if allowedCharacters.isSuperset(of: characterSet){
                return true
            }else{
                return false
            }
        }
        
    }
    
    
}
