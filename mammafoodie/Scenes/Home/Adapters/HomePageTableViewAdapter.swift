import UIKit

enum HomePageTableViewMode {
    case activity
    case menu
}

class HomePageTableviewAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var mode: HomePageTableViewMode = .activity
    var sectionHeaderView: UIView?
    var menu: [MFMedia] = []
    
    func setup(with tableView: UITableView) {
        self.tableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 270
        
        let name: String = "MenuItemTblCell"
        tableView.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
        
        DummyData.sharedInstance.populateMenu { (dummyMenu) in
            self.menu = dummyMenu
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MenuItemTblCell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTblCell", for: indexPath) as! MenuItemTblCell
        cell.setup(with: self.menu[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sectionHeaderView
    }
}
