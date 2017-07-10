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
    
    var selectedCuisine: MFCuisine!
    
    func setup(with tableView: UITableView) {
        self.tableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 270
        
        let name: String = "MenuItemTblCell"
        tableView.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
        
        let name1: String = "ActivityTblCell"
        tableView.register(UINib(nibName: name1, bundle: nil), forCellReuseIdentifier: name1)
        
        self.loadActivities()
    }
    
    func loadActivities() {
        DummyData.sharedInstance.populateNewsfeed { (dummyData) in
            self.activity = dummyData
            self.tableView.reloadData()
        }
    }
    
    func loadMenu(with cuisine: MFCuisine) {
        DummyData.sharedInstance.populateMenu(for: cuisine) { (dummyMenu) in
            self.selectedCuisine = cuisine
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
        if self.mode == .activity {
            return 65
        } else {
            return 101
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sectionHeaderView
    }
}
