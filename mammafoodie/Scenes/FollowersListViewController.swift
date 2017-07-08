

import UIKit

class FollowersListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var followersTblView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        followersTblView.delegate = self
        followersTblView.dataSource = self
        followersTblView.rowHeight = UITableViewAutomaticDimension
        followersTblView.estimatedRowHeight = 80
        
        let name: String = "FollowersTableCell"
        followersTblView.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FollowersTableCell = followersTblView.dequeueReusableCell(withIdentifier: "FollowersTableCell", for: indexPath) as! FollowersTableCell
        //            cell.setup(with: self.menu[indexPath.item])
        cell.userProfile.image = UIImage(named: "AlexaGrimes")!
        cell.nameLbl.text = "Chiken Fries"
        cell.Lable2.text =  "Tim"
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
