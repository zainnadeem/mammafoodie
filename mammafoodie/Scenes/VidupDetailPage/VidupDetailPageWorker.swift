import UIKit
import AVFoundation
import Alamofire

private var playbackLikelyToKeepUpContext = 0

class VidupDetailPageWorker:NSObject {
    
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var delegate: Interactordelegate?
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
    
    func PlayVideo(MediaURL:URL) {
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
        _ = DatabaseGateway.sharedInstance.getUserWith(userID: Id) { (UserInfo) in
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
        _ = DatabaseGateway.sharedInstance.getDishWith(dishID: Id) { (DishInfo) in
            completion(DishInfo)
        }
    }
    
    func GetDishLikeDetails(Id:String,completion:@escaping(_ likeCount:Int)->()){
        DatabaseGateway.sharedInstance.getDishLike(dishID: Id) { (LikeCount) in
            completion(LikeCount!)
        }
    }
    
    func likeDish(Id:String,DishId:String) {
        let RequestURL = "https://us-central1-mammafoodie-baf82.cloudfunctions.net/likeDish?dishId=\(DishId)&userId=\(Id)"
        Alamofire.request(RequestURL)
            .responseString { response in
                print(response.result.error ?? "")
        }
    }
    
    func UnlikeDish(Id:String,DishId:String) {
        let RequestURL = "https://us-central1-mammafoodie-baf82.cloudfunctions.net/unlikeDish?dishId=\(DishId)&userId=\(Id)"
        Alamofire.request(RequestURL)
            .responseString { response in
                print(response.result.error ?? "")
        }
    }

    func getexpireTime(endTimestamp:Date)->Double{
        return endTimestamp.timeIntervalSinceReferenceDate
    }

    func startPlayback() {
        self.avPlayer.play()
    }

    func stopPayback() {
        self.avPlayer.pause()
    }

    func updateViewersCount(for dishID:String, opened:Bool) {
        
        var params = "dishId=\(dishID)"
        
        if opened {
            params += "&opened=1"
        } else {
            params += "&closed=1"
        }
        
        let urlString = "https://us-central1-mammafoodie-baf82.cloudfunctions.net/updateViewersCount?\(params)"
        
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { print("Error encoding the url string"); return }
        
        let url = URL(string: encodedString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        //        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //        request.httpBody = params.data(using: String.Encoding.utf8)
        
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { (data, response, error) in
            
            //            completion()
            
            guard let response = response as? HTTPURLResponse else { print("there was an error"); return }
            if response.statusCode != 200 {
                print("There was an error with your request")
            }
            if let responseDict = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                if let responseDict = responseDict {
                    print(responseDict)
                }
                else { print("error") }
            }
            }.resume()
        
        
    }
}
