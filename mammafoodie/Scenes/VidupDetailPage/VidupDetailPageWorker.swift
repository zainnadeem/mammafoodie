import UIKit
import AVFoundation

class VidupDetailPageWorker:NSObject {
    
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var delegate:Interactordelegate?
    
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
        
    }
    
    func resetMediaPlayerViewBounds(view:UIView){
        avPlayerLayer.frame = view.bounds
    }
    
    func PlayVideo(MediaURL:String){
        let url = NSURL(string: MediaURL)
        let playerItem = AVPlayerItem(url: url! as URL)
        avPlayer.replaceCurrentItem(with: playerItem)
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
        print("Double Tapped.")
    }

    
    
}
