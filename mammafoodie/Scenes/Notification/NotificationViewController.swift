import UIKit

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var notifcationTblView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notifcationTblView.delegate = self
        notifcationTblView.dataSource = self
        notifcationTblView.estimatedRowHeight = 80
        
        let name: String = "NotificationTableCell"
        notifcationTblView.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
        
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationTableCell = notifcationTblView.dequeueReusableCell(withIdentifier: "NotificationTableCell", for: indexPath) as! NotificationTableCell
//        cell.profileImage.image = UIImage(named: "AlexaGrimes")!
        return cell
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
