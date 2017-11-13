
import UIKit

class NotificationTableCell: UITableViewCell {

   
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var dishImage: UIImageView!
   
    @IBOutlet weak var notifyLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
