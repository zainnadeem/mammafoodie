import UIKit
import AVFoundation

private var playbackLikelyToKeepUpContext = 0

class VidupDetailPageWorker:NSObject {
    
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var delegate:Interactordelegate?
    let loadingIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    
    
    // MARK: - Business Logic
    
    
    func SetupMediaPlayer(view:UIView){
        
        view.backgroundColor = UIColor.black
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        let playandpauseTap = UITapGestureRecognizer(target: self, action: #selector(PlayandPauseVideo(ViewTapped:)))
        playandpauseTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(playandpauseTap)
        
        let fullscreenTap = UITapGestureRecognizer(target: self, action: #selector(FullScreenVideo(ViewTapped:)))
        fullscreenTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(fullscreenTap)
        
        playandpauseTap.require(toFail: fullscreenTap)
        
        loadingIndicatorView.hidesWhenStopped = true
        view.addSubview(loadingIndicatorView)
        avPlayer.addObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp",
                             options: .new, context: &playbackLikelyToKeepUpContext)
        
    }
    
    func resetMediaPlayerViewBounds(view:UIView){
        avPlayerLayer.frame = view.bounds
        loadingIndicatorView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    }
    
    func PlayVideo(MediaURL:String){
        let url = NSURL(string: MediaURL)
        let playerItem = AVPlayerItem(url: url! as URL)
        avPlayer.replaceCurrentItem(with: playerItem)
        loadingIndicatorView.startAnimating()
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
            completion(UserInfo!)
        }
    }
    
    func GetDishInfo(Id:String,completion:@escaping(_ DishInfo:MFDish?,_ mediaInfo:MFMedia?)->()){
        DatabaseGateway.sharedInstance.getDishWith(dishID: Id) { (DishInfo) in
            
            DatabaseGateway.sharedInstance.getMediaWith(mediaID: (DishInfo?.mediaID)!, { (mediaDetails) in
              completion(DishInfo, mediaDetails)
            })
            
        }
    }
    
}
