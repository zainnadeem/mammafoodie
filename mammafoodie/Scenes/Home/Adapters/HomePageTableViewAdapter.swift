import UIKit

enum HomePageTableViewMode {
    case activity
    case menu
}

class HomePageTableviewAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var mode: HomePageTableViewMode = .activity
    var sectionHeaderView: UIView?
    var activity: [MFNewsFeed] = []
    var menu: [MFDish] = []
    
    private var openURL: ((String, String) -> Void)?
    private var currentUser: MFUser!
    
    func setup(with tableView: UITableView, user: MFUser, _ completion: ((String, String) -> Void)?) {
        self.currentUser = user
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 270
        self.openURL = completion
        let name: String = "MenuItemTblCell"
        self.tableView.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
        
        let name1: String = "ActivityTblCell"
        self.tableView.register(UINib(nibName: name1, bundle: nil), forCellReuseIdentifier: name1)
        self.tableView.backgroundView?.isHidden = true
        self.tableView.allowsSelection = true
        self.loadActivities()
    }
    
    func loadActivities() {
        DatabaseGateway.sharedInstance.getNewsFeed(for: self.currentUser.id) { (feeds) in
            DispatchQueue.main.async {
                self.activity = feeds
                self.tableView.reloadData()
            }
        }
    }
    
    func loadMenu() {
        DatabaseGateway.sharedInstance.getSavedDishesForUser(userID: self.currentUser.id) { (dishes) in
            DispatchQueue.main.async {
                self.menu = dishes
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.mode == .activity {
            let cell: ActivityTblCell = tableView.dequeueReusableCell(withIdentifier: "ActivityTblCell", for: indexPath) as! ActivityTblCell
            if self.activity.count > indexPath.row {
                cell.setup(with: self.activity[indexPath.item])
                cell.openURL = self.openURL
            }
            return cell
        } else {
            let cell: MenuItemTblCell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTblCell", for: indexPath) as! MenuItemTblCell
            if self.menu.count > indexPath.row {
                cell.setup(with: self.menu[indexPath.item])
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.mode == .menu {
            let dish = self.menu[indexPath.item]
            self.openURL?(FirebaseReference.dishes.rawValue, dish.id)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is MenuItemTblCell {
            (cell as! MenuItemTblCell).cellWillDisplay()
        } else if cell is ActivityTblCell {
            (cell as! ActivityTblCell).updateShadow()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.mode == .activity {
            return self.activity.count
        } else {
            return self.menu.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sectionHeaderView
    }
}
