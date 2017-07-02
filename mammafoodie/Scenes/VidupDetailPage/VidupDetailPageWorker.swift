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
    
    func PlayVideo(MediaURL:URL){
        let playerItem = AVPlayerItem(url: MediaURL)
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
    
    
    
    
//    func GetDishInfo(Id:String,completion:@escaping(_ DishInfo:MFDish?,_ mediaInfo:MFMedia?)->()){
//        DatabaseGateway.sharedInstance.getDishWith(dishID: Id) { (DishInfo) in
//            
//            if DishInfo != nil {
//                DatabaseGateway.sharedInstance.getMediaWith(mediaID: (DishInfo?.mediaID)!, { (mediaDetails) in
//                    completion(DishInfo, mediaDetails)
//                })
//            }
//            
//        }
//    }
    
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
    

    func getexpireTime(endedAt:Date)->Int{
        
        var TimeLeft:Int = 0
        
        let CurrentTime = Date().timeIntervalSinceReferenceDate
        
        TimeLeft = endedAt - CurrentTime
        
        return TimeLeft
    }
    
    
}
