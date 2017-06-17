import UIKit

class LiveVideoChoiceViewController: UIViewController {
    
    lazy var liveStreamTableViewAdapter: LiveStreamTableViewAdapter = LiveStreamTableViewAdapter()
    
    @IBOutlet weak var tblLiveStreams: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLiveStreamTableViewAdapter()
    }
    
    func setupLiveStreamTableViewAdapter() {
        self.liveStreamTableViewAdapter.setupAdapter(with: self.tblLiveStreams)
        self.liveStreamTableViewAdapter.loadStreams {
            print("Streams loaded")
        }
        self.liveStreamTableViewAdapter.didSelectStream = { (selectedLiveStream) in
            self.performSegue(withIdentifier: "segueSubscribe", sender: selectedLiveStream)
        }
    }
    
    @IBAction func btnRefreshStreamsTapped(_ sender: UIButton) {
        self.setupLiveStreamTableViewAdapter()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguePublish" {
            var liveVideo = MFMedia()
            liveVideo.id = FirebaseReference.media.generateAutoID()
            liveVideo.accessMode = .owner
            (segue.destination as! LiveVideoViewController).liveVideo = liveVideo
        } else if segue.identifier == "segueSubscribe" {
            (segue.destination as! LiveVideoViewController).liveVideo = sender as! MFMedia
        }
    }
    
}
