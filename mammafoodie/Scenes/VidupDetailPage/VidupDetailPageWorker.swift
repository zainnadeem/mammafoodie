import UIKit
import AVFoundation
import Alamofire

private var playbackLikelyToKeepUpContext = 0

class VidupDetailPageWorker:NSObject {
    
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var delegate:Interactordelegate?
    let loadingIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    // MARK: - Business Logic
    
    func SetupMediaPlayer(view:UIView){
        
        view.backgroundColor = UIColor.black
        self.avPlayerLayer = AVPlayerLayer(player: avPlayer)
        view.layer.insertSublayer(self.avPlayerLayer, at: 0)
        
        var frame: CGRect = self.avPlayerLayer.frame
        frame.size = view.frame.size
        self.avPlayerLayer.frame = frame
        
        //        let playandpauseTap = UITapGestureRecognizer(target: self, action: #selector(PlayandPauseVideo(ViewTapped:)))
        //        view.addGestureRecognizer(playandpauseTap)
        
        let fullscreenTap = UITapGestureRecognizer(target: self, action: #selector(FullScreenVideo(ViewTapped:)))
        view.addGestureRecognizer(fullscreenTap)
        
        //        playandpauseTap.require(toFail: fullscreenTap)
        
        self.loadingIndicatorView.hidesWhenStopped = true
        view.addSubview(self.loadingIndicatorView)
        self.avPlayer.addObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp",
                                  options: .new, context: &playbackLikelyToKeepUpContext)
    }
    
    func playerItemDidPlayToEndTime(_ notification: Notification) {
        avPlayer.seek(to: kCMTimeZero)
        avPlayer.play()
    }
    
    func resetMediaPlayerViewBounds(view:UIView){
        avPlayerLayer.frame = view.bounds
        loadingIndicatorView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    }
    
    func PlayVideo(MediaURL:URL){
        let playerItem = AVPlayerItem(url: MediaURL)
        avPlayer.replaceCurrentItem(with: playerItem)
        loadingIndicatorView.startAnimating()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEndTime(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.avPlayer.currentItem)
        
        avPlayer.play()
    }
    
    func PlayandPauseVideo(ViewTapped:UITapGestureRecognizer){
        let playerIsPlaying = avPlayer.rate > 0
        if playerIsPlaying {
            avPlayer.pause()
        } else {
            avPlayer.play()
        }
    }
    
    func FullScreenVideo(ViewTapped:UITapGestureRecognizer){
        delegate?.HideandUnhideView()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &playbackLikelyToKeepUpContext {
            if avPlayer.currentItem!.isPlaybackLikelyToKeepUp {
                loadingIndicatorView.stopAnimating()
            } else {
                loadingIndicatorView.startAnimating()
            }
        }
    }
    
    func GetUserDetails(Id:String,completion:@escaping(_ UserInfo:MFUser)->()){
        DatabaseGateway.sharedInstance.getUserWith(userID: Id) { (UserInfo) in
            if UserInfo != nil{
                completion(UserInfo!)
            }
        }
    }
    
    func GetlikeStatus(Id:String,DishId:String,completion:@escaping(_ likeStatus:Bool)->()){
        DatabaseGateway.sharedInstance.getLikeStatus(dishID: DishId, user_Id: Id, { (Status) in
            completion(Status!)
        })
    }
    
    func GetDishInfo(Id:String,completion:@escaping(_ DishInfo:MFDish?)->()){
        
        DatabaseGateway.sharedInstance.getDishWith(dishID: Id) { (DishInfo) in
            completion(DishInfo)
        }
    }
    
    func GetDishLikeDetails(Id:String,completion:@escaping(_ likeCount:Int)->()){
        DatabaseGateway.sharedInstance.getDishLike(dishID: Id) { (LikeCount) in
            completion(LikeCount!)
        }
    }
    
    func likeDish(Id:String,DishId:String){
        let RequestURL = "https://us-central1-mammafoodie-baf82.cloudfunctions.net/likeDish?dishId=\(DishId)&userId=\(Id)"
        
        Alamofire.request(RequestURL)
            .responseString { response in
                print(response.result.error ?? "")
        }
    }
    
    func UnlikeDish(Id:String,DishId:String){
        let RequestURL = "https://us-central1-mammafoodie-baf82.cloudfunctions.net/unlikeDish?dishId=\(DishId)&userId=\(Id)"
        
        Alamofire.request(RequestURL)
            .responseString { response in
                print(response.result.error ?? "")
        }
    }
    
    
    func getexpireTime(endTimestamp:Date)->Double{
        return endTimestamp.timeIntervalSinceReferenceDate
    }
    
    
}
