import UIKit
import DZNEmptyDataSet

enum HomePageTableViewMode {
    case activity
    case menu
}

class HomePageTableviewAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var mode: HomePageTableViewMode = .activity {
        didSet {
            
        }
    }
    var sectionHeaderView: UIView?
    var activity: [MFNewsFeed] = []
    var menu: [MFDish] = []
    
    var onOrderNow : ((MFDish) -> Void)?
    var onBookmark : ((MFDish) -> Void)?
    var onOptions : ((MFDish) -> Void)?
    var onAvtivityOptions : ((MFNewsFeed) -> Void)?
    
    private var openURL: ((String, String) -> Void)?
    private var currentUser: MFUser!
    
    func setup(with tableView: UITableView, user: MFUser, _ completion: ((String, String) -> Void)?) {
        self.currentUser = user
        self.tableView = tableView
        self.tableView.allowsSelection = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 270
        self.openURL = completion
        let name: String = "MenuItemTblCell"
        self.tableView.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        let name1: String = "ActivityTblCell"
        self.tableView.register(UINib(nibName: name1, bundle: nil), forCellReuseIdentifier: name1)
        self.tableView.backgroundView?.isHidden = true
        self.tableView.allowsSelection = true
        self.loadActivities()
        
    }
    
    func loadActivities() {
        print("Current user: \(self.currentUser.id)")
        DatabaseGateway.sharedInstance.getActivityFeed(for: self.currentUser.id) { (feeds) in
                self.activity = feeds
                self.activity.sort(by: { $0.createdAt > $1.createdAt })
                self.tableView.reloadData()
        }
        //        DatabaseGateway.sharedInstance.getNewsFeed(by: self.currentUser.id) { (feeds) in
        //            DispatchQueue.main.async {
        //                self.activity = feeds
        //                self.activity.sort(by: { $0.createdAt > $1.createdAt })
        //                self.tableView.reloadData()
        //            }
        //        }
        //        return;
        //        DatabaseGateway.sharedInstance.getNewsFeed(for: self.currentUser.id) { (feeds) in
        //            DispatchQueue.main.async {
        //                self.activity = feeds
        //                self.tableView.reloadData()
        //                print("Activity loaded")
        //            }
        //        }
    }
    
    func loadMenu() {
        DatabaseGateway.sharedInstance.getSavedDishesForUser(userID: self.currentUser.id) { (dishes) in
            DispatchQueue.main.async {
                self.menu = dishes
                self.tableView.reloadData()
            }
        }
    }
    
    func showOptions(for indexPath: IndexPath) {
        if indexPath.row < self.menu.count {
            self.onOptions?(self.menu[indexPath.row])
        }
    }
    
    func showActivitiesOptions(for indexPath: IndexPath) {
        if indexPath.row < self.menu.count {
            self.onOptions?(self.menu[indexPath.row])
        }
    }
    
    func likeDish(_ id: String) {
        DatabaseGateway.sharedInstance.checkLikedDishes(userId: "String", dishId: "") { (like) in
            
        }
    }
    
    func showBookmarkOptions(for indexPath: IndexPath) {
        if indexPath.row < self.menu.count {
            self.onBookmark?(self.menu[indexPath.row])
        }
    }
    
    func orderNow(at indexPath: IndexPath) {
        if indexPath.row < self.menu.count {
            self.onOrderNow?(self.menu[indexPath.row])
        }
    }
    
    func removeSavedDish(_ dish: MFDish) {
        if let index = self.menu.index(of: dish) {
            let indexPath = IndexPath.init(row: index, section: 0)
            self.tableView.beginUpdates()
            self.menu.remove(at: index)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.mode == .activity {
            let cell: ActivityTblCell = tableView.dequeueReusableCell(withIdentifier: "ActivityTblCell", for: indexPath) as! ActivityTblCell
            if self.activity.count > indexPath.row {
                let feed = self.activity[indexPath.item]
                cell.setup(with: feed, withUser: self.currentUser)
                cell.openURL = self.openURL
            }
            return cell
        } else {
            let cell: MenuItemTblCell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTblCell", for: indexPath) as! MenuItemTblCell
            if self.menu.count > indexPath.row {
                cell.indexPath = indexPath
                cell.setup(with: self.menu[indexPath.item])
                cell.onBookmark = { (index) in
                    self.showBookmarkOptions(for: index)
                }
                cell.onOrderNow = { (index) in
                    self.orderNow(at: index)
                }
                cell.onOptions = { (index) in
                    self.showOptions(for: index)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.mode == .menu {
            let dish = self.menu[indexPath.item]
            self.openURL?(FirebaseReference.dishes.rawValue, dish.id)
        } else {
            let newsFeed = self.activity[indexPath.item]
            self.openURL?(newsFeed.activity.path.rawValue, newsFeed.redirectID)
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

extension HomePageTableviewAdapter: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if self.mode == .activity {
            return NSAttributedString.init(string: "No activity", attributes: [NSFontAttributeName: UIFont.MontserratLight(with: 15)!])
        }
        return NSAttributedString.init(string: "No saved dishes", attributes: [NSFontAttributeName: UIFont.MontserratLight(with: 15)!])
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return (self.sectionHeaderView?.frame.size.height ?? 0) + self.tableView.sectionHeaderHeight + 20
    }
    
}
