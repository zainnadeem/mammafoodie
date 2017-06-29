import UIKit

class LiveStreamTableViewAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var streams: [MFMedia] = []
    var tableView: UITableView!
    var didSelectStream: ((MFMedia)->Void)?
    
    func setupAdapter(with tableView: UITableView) {
        self.tableView = tableView
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func loadStreams(completion: @escaping (()->Void)) {
        let worker = LiveStreamListWorker()
        worker.getList { (streams) in
            DispatchQueue.main.async {
                self.streams = streams
                self.tableView.reloadData()
                completion()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.streams[indexPath.item].contentId
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.streams.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectStream?(self.streams[indexPath.item])
    }
}
