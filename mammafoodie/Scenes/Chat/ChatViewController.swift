import UIKit
import Firebase
import GoogleMobileAds

protocol ChatViewControllerInput {
    
}

protocol ChatViewControllerOutput {
   func chatWorkerInfo(username:String, meassagetext: String)
}


class ChatViewController: UIViewController, ChatViewControllerInput,  UITextFieldDelegate {
    
    var output: ChatViewControllerOutput!
    var router: ChatRouter!
    

    @IBOutlet weak var textFeild: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Object lifecycle
    var messages: [Message]? = []
    var messgeArray = [String]()
    var msglength: NSNumber = 100
    var chatInfo: Chat.Response?


    
    override func awakeFromNib() {
        super.awakeFromNib()
        ChatConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFeild.delegate = self
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        self.messgeArray.append(self.textFeild.text!)
        let userName = Auth.auth().currentUser?.displayName
        self.output.chatWorkerInfo(username: userName!,meassagetext: self.textFeild.text!)
    }
    
    
    func sendChatResponse(_ response: Chat.Response) {
        chatInfo = response
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView?.reloadData()
    }
    
    // MARK: - Event handling
    
    // MARK: - Display logic
    // UITextViewDelegate protocol methods
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        guard let text = textField.text else { return true }
//        textField.text = ""
//        view.endEditing(true)
////        let data = [MessageFields.text: text]
//        messgeArray.append(textField.text!)
//        print(messgeArray)
//        //sendMessage(withData: data)
//        return true
   // }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= self.msglength.intValue // Bool
    }

}


// MARK: - Table View

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {

    // UITableViewDataSource protocol methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatInfo!.arrayOfLiveChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell:ChatTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "chatcell") as! ChatTableViewCell
        cell.senderTxt?.numberOfLines = 3
        cell.senderTxt?.lineBreakMode = .byWordWrapping
        //        cell.textLabel?.text = commentsArray[indexPath.row].textContent
        cell.senderTxt.backgroundColor = UIColor(red: 242/255, green: 102/255, blue: 5/255, alpha: 1)
        
//        cell.senderTxt.text = messgeArray[indexPath.row]
        cell.receiveTxt.text = messgeArray[indexPath.row]
        
        cell.senderTxt.text = chatInfo?.arrayOfLiveChat[indexPath.row].messageText
        return cell
    }

}

