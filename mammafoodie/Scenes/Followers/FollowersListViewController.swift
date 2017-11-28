import UIKit
import DZNEmptyDataSet

typealias ChatSelectionCompletionBlock = ((MFUser) -> Void)
typealias FollowActionHandler = ((IndexPath, Bool) -> Void)

class FollowersListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var followersTblView: UITableView!
    
    var currentUserFollowings: [MFUser] = []
    var followers: Bool = true
    var userList = [MFUser]()
    var userID: String!
    private var chatMode: Bool = false
    private var chatSelectionComplete: ChatSelectionCompletionBlock?
    private var observerForFollowers: DatabaseConnectionObserver?
    private var observerForFollowing: DatabaseConnectionObserver?
    private var observerForCurrentUserFollowing: DatabaseConnectionObserver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.followersTblView.delegate = self
        self.followersTblView.dataSource = self
        self.followersTblView.rowHeight = UITableViewAutomaticDimension
        self.followersTblView.estimatedRowHeight = 80
        self.followersTblView.emptyDataSetDelegate = self
        self.followersTblView.emptyDataSetSource = self
        
        let follower: String = "FollowersTableCell"
        let following = "FollowingTableCell"
        
        self.followersTblView.register(UINib(nibName: follower, bundle: nil), forCellReuseIdentifier: follower)
        self.followersTblView.register(UINib(nibName: following, bundle: nil), forCellReuseIdentifier: following)
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func loadData() {
        let requestGroup = DispatchGroup.init()
        
        let worker = OtherUsersProfileWorker()
        if self.followers {
            self.title = "Followers"
            requestGroup.enter()
            self.observerForFollowers = worker.getFollowersForUser(userID: userID, frequency: .realtime ,{ (users) in
                self.userList = users
                requestGroup.leave()
            })
        } else {
            self.title = "Following"
            requestGroup.enter()
            self.observerForFollowing = worker.getFollowingForUser(userID: userID, frequency: .realtime ,{ (users) in
                self.userList = users
                requestGroup.leave()
            })
        }
        
        if let currentUser = DatabaseGateway.sharedInstance.getLoggedInUser() {
            requestGroup.enter()
            self.observerForCurrentUserFollowing = worker.getFollowingForUser(userID: currentUser.id, { (users) in
                self.currentUserFollowings = users
                requestGroup.leave()
            })
        }
        requestGroup.notify(queue: .main, execute: {
            self.reloadData()
        })
    }
    
    func reloadData() {
        self.userList.sort { (user1, user2) -> Bool in
            return user1.name < user2.name
        }
        self.followersTblView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.observerForFollowers?.stop()
        self.observerForFollowing?.stop()
        self.observerForCurrentUserFollowing?.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    class func showChatUserSelection(_ completion: @escaping ChatSelectionCompletionBlock) -> UINavigationController? {
        let story = UIStoryboard.init(name: "Siri", bundle: nil)
        if let followerVC = story.instantiateViewController(withIdentifier: "FollowersListViewController") as? FollowersListViewController {
            let nav = UINavigationController.init(rootViewController: followerVC)
            nav.navigationBar.tintColor = .darkGray
            followerVC.chatSelectionComplete = completion
            let backButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "BackBtn"), style: .plain, target: followerVC, action: #selector(backButtonTapped(_:)))
            followerVC.navigationItem.leftBarButtonItem = backButton
            return nav
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = self.userList[indexPath.row]
        var isCurrentUserFollowingTheUser: Bool = false
        let tempUsers: [MFUser] = self.currentUserFollowings.filter { (followingUser) -> Bool in
            if followingUser.id == user.id {
                return true
            }
            return false
        }
        if tempUsers.count > 0 {
            isCurrentUserFollowingTheUser = true
            print("Current user follows: \(user.name)")
        }
        
        let cell: FollowersTableCell = tableView.dequeueReusableCell(withIdentifier: "FollowersTableCell", for: indexPath) as! FollowersTableCell
        cell.shouldShowFollowButton = !isCurrentUserFollowingTheUser
        cell.setUp(user: user)
        return cell
        
//        if followers {
//
//        } else {
//            let cell: FollowingTableCell = tableView.dequeueReusableCell(withIdentifier: "FollowingTableCell", for: indexPath) as! FollowingTableCell
//            cell.shouldShowFollowButton = !isCurrentUserFollowingTheUser
//            cell.setUp(user: user)
//            return cell
//        }
//
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.userList[indexPath.row]
        if self.chatMode {
            self.chatSelectionComplete?(user)
            self.navigationController?.dismiss(animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "segueShowUserProfile", sender: user.id)
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowUserProfile" {
            if let destination: UINavigationController = segue.destination as? UINavigationController {
                if let profileVC: OtherUsersProfileViewController = destination.viewControllers.first as? OtherUsersProfileViewController {
                    profileVC.userID = sender as? String
                }
            }
        }
    }
}

extension FollowersListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if self.followers {
            return NSAttributedString.init(string: "No followers", attributes: [NSFontAttributeName: UIFont.MontserratLight(with: 15)!])
        }
        return NSAttributedString.init(string: "You are not following anyone", attributes: [NSFontAttributeName: UIFont.MontserratLight(with: 15)!])
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 0
    }
    
}

