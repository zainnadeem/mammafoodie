
import UIKit

class DishesSavedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var dishesListTableView: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        dishesListTableView.delegate = self
        dishesListTableView.dataSource = self
        dishesListTableView.rowHeight = UITableViewAutomaticDimension
        dishesListTableView.estimatedRowHeight = 270
        
        let name: String = "MenuItemTblCell"
        dishesListTableView.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MenuItemTblCell = dishesListTableView.dequeueReusableCell(withIdentifier: "MenuItemTblCell", for: indexPath) as! MenuItemTblCell
//            cell.setup(with: self.menu[indexPath.item])
            cell.imgView.image = UIImage(named: "AlexaGrimes")!
            cell.lblDishName.text = "Chiken Fries"
            cell.lblUsername.text =  "Tim"
            cell.imgViewProfilePicture.image = UIImage(named: "Bitmap")!
            return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            (cell as! MenuItemTblCell).cellWillDisplay()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 10
    }
    
        
   
    


}
