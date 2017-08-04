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
    private var currentUser: MFUser!
    
    func setup(with tableView: UITableView, user: MFUser) {
        self.currentUser = user
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 270
        
        let name: String = "MenuItemTblCell"
        self.tableView.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
        
        let name1: String = "ActivityTblCell"
        self.tableView.register(UINib(nibName: name1, bundle: nil), forCellReuseIdentifier: name1)
        
        self.loadActivities()
    }
    
    func loadActivities() {
        DatabaseGateway.sharedInstance.getNewsFeed(for: self.currentUser.id) { (feeds) in
            DispatchQueue.main.async {
                self.activity = feeds
                self.tableView.backgroundView?.isHidden = (feeds.count > 0)
                self.tableView.reloadData()
            }
        }
    }
    
    func loadMenu() {
        DummyData.sharedInstance.populateMenu { (dummyMenu) in
            self.menu = dummyMenu
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.mode == .activity {
            let cell: ActivityTblCell = tableView.dequeueReusableCell(withIdentifier: "ActivityTblCell", for: indexPath) as! ActivityTblCell
            cell.setup(with: self.activity[indexPath.item])
            return cell
        } else {
            let cell: MenuItemTblCell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTblCell", for: indexPath) as! MenuItemTblCell
            cell.setup(with: self.menu[indexPath.item])
            return cell
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
