

import UIKit
typealias ChatSelectionCompletionBlock = ((MFUser) -> Void)

class FollowersListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var followersTblView: UITableView!
    
    var followers: Bool = true
    var userList = [MFUser]() {
        didSet {
            self.followersTblView.reloadData()
        }
    }
    var userID:String!
    private var chatMode: Bool = false
    private var chatSelectionComplete: ChatSelectionCompletionBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.followersTblView.delegate = self
        self.followersTblView.dataSource = self
        self.followersTblView.rowHeight = UITableViewAutomaticDimension
        self.followersTblView.estimatedRowHeight = 80
        
        let follower: String = "FollowersTableCell"
        let following = "FollowingTableCell"
        
        self.followersTblView.register(UINib(nibName: follower, bundle: nil), forCellReuseIdentifier: follower)
        self.followersTblView.register(UINib(nibName: following, bundle: nil), forCellReuseIdentifier: following)
        
        //        followersTblView.rowHeight = UITableViewAutomaticDimension
        self.automaticallyAdjustsScrollViewInsets = false
        let worker = OtherUsersProfileWorker()
        if followers {
            self.title = "Followers"
            worker.getFollowersForUser(userID: userID, frequency: .realtime ,{ (users) in
                self.userList = users
            })
        } else {
            self.title = "Following"
            worker.getFollowingForUser(userID: userID, frequency: .realtime ,{ (users) in
                self.userList = users
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.followersTblView.reloadData()
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
            followerVC.chatSelectionComplete = completion
            let backButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "BackBtn"), style: .plain, target: followerVC, action: #selector(backButtonTapped(_:)))
            followerVC.navigationItem.leftBarButtonItem = backButton
            return nav
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = userList[indexPath.row]
        if followers {
            let cell: FollowersTableCell = tableView.dequeueReusableCell(withIdentifier: "FollowersTableCell", for: indexPath) as! FollowersTableCell
            cell.setUp(user: user)
            return cell
            
        } else {
            let cell: FollowingTableCell = tableView.dequeueReusableCell(withIdentifier: "FollowingTableCell", for: indexPath) as! FollowingTableCell
            cell.setUp(user: user)
            return cell
        }
        
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
        if self.chatMode {
            let user = self.userList[indexPath.row]
            self.chatSelectionComplete?(user)
            self.navigationController?.dismiss(animated: true, completion: nil)
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}
