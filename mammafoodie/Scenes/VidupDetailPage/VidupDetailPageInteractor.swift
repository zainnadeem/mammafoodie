import UIKit

protocol Interactordelegate {
    func HideandUnhideView()
    func DisplayTime(Time:TimeInterval)
}

protocol VidupDetailPageInteractorInput {
    func setupMediaPlayer(view:UIView,mediaURL:String)
    func resetViewBounds(view:UIView)
    func stopTimer()
}

protocol VidupDetailPageInteractorOutput {
    func HideandUnhideViewInteractor()
    func DisplayTimeInteractor(Time:TimeInterval)
}

class VidupDetailPageInteractor: VidupDetailPageInteractorInput,Interactordelegate {
    
    var output: VidupDetailPageInteractorOutput!
    var Vidupworker: VidupDetailPageWorker! = VidupDetailPageWorker()
    var VidupTimerworker: TimerWorker! = TimerWorker()
    
    
    
    // MARK: - Business logic
    
    func setupMediaPlayer(view:UIView,mediaURL:String){
        Vidupworker.delegate = self
        Vidupworker.SetupMediaPlayer(view: view)
        Vidupworker.PlayVideo(MediaURL: mediaURL)
        VidupTimerworker.delegate = self
        VidupTimerworker.seconds = 10
        VidupTimerworker.runTimer()
    }
    
    func resetViewBounds(view:UIView){
        Vidupworker.resetMediaPlayerViewBounds(view: view)
    }
    
    
    func HideandUnhideView() {
        output.HideandUnhideViewInteractor()
    }
    
    func DisplayTime(Time:TimeInterval){
        output.DisplayTimeInteractor(Time: Time)
    }
    
    
    func stopTimer() {
        VidupTimerworker.stopTimer()
    }
}
