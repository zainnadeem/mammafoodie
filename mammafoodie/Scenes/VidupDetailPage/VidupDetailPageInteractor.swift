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
    var worker: VidupDetailPageWorker! = VidupDetailPageWorker()
    
    
    
    // MARK: - Business logic
    
    func setupMediaPlayer(view:UIView,mediaURL:String){
        worker.delegate = self
        worker.SetupMediaPlayer(view: view)
        worker.PlayVideo(MediaURL: mediaURL)
    }
    
    func resetViewBounds(view:UIView){
        worker.resetMediaPlayerViewBounds(view: view)
    }
    
    
    func HideandUnhideView() {
        output.HideandUnhideViewInteractor()
    }
    
    func DisplayTime(Time:TimeInterval){
        output.DisplayTimeInteractor(Time: Time)
    }
    
    
    func stopTimer() {
        worker.timer.invalidate()
    }
}
