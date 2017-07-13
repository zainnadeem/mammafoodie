

import UIKit

class FollowersListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var followersTblView: UITableView?
    
    var followers:Bool!
    
    var userList = [MFUser]() {
        didSet{
            self.followersTblView?.reloadData()
        }
    }
   
    var userID:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        followersTblView?.delegate = self
        followersTblView?.dataSource = self
        followersTblView?.rowHeight = UITableViewAutomaticDimension
        followersTblView?.estimatedRowHeight = 80
        
        let follower: String = "FollowersTableCell"
        let following = "FollowingTableCell"
        
        followersTblView?.register(UINib(nibName: follower, bundle: nil), forCellReuseIdentifier: follower)
        
        followersTblView?.register(UINib(nibName: following, bundle: nil), forCellReuseIdentifier: following)
        
        followersTblView?.rowHeight = UITableViewAutomaticDimension
        self.automaticallyAdjustsScrollViewInsets = false
        
        let worker = OtherUsersProfileWorker()
        
        if followers {
            self.title = "Followers"
            
            worker.getFollowersForUser(userID: userID, frequency: .realtime ,{ (users) in
                self.userList = users ?? []
            })
            
            
        } else {
            self.title = "Following"
            
            worker.getFollowingForUser(userID: userID, frequency: .realtime ,{ (users) in
                self.userList = users ?? []
            })
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        followersTblView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
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
    
}
