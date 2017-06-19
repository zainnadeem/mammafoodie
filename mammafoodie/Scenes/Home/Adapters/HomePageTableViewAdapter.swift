import UIKit

enum HomePageTableViewMode {
    case activity
    case menu
}

class HomePageTableviewAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var mode: HomePageTableViewMode = .activity
    var sectionHeaderView: UIView?
    
    func setup(with tableView: UITableView) {
        self.tableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 261
        
        let name: String = "MenuItemTblCell"
        tableView.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MenuItemTblCell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTblCell", for: indexPath) as! MenuItemTblCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sectionHeaderView
    }
}
