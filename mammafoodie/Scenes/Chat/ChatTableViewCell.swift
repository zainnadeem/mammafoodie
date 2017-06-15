
import UIKit
import QuartzCore


class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var receiveTxt: UILabel!
    @IBOutlet weak var senderTxt: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        senderTxt.layer.cornerRadius = 8
        senderTxt.layer.masksToBounds = true
        receiveTxt.layer.cornerRadius = 8
        receiveTxt.layer.masksToBounds = true
        senderTxt.textColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
