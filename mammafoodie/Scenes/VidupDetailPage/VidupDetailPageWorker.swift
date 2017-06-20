import UIKit
import AVFoundation

private var playbackLikelyToKeepUpContext = 0

class VidupDetailPageWorker:NSObject {
    
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var delegate:Interactordelegate?
    let loadingIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    
    //Timer
    var seconds = 600 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    
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
        runTimer()
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
        print("Double Tapped.")
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
    
    //MARK: - Timer Functions
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        delegate?.DisplayTime(Time: TimeInterval(seconds))
    }
    
    


    
    
}
