import UIKit

protocol adaptordelegte {
    func Test()
}

protocol VidupDetailPageInteractorInput {
     func setupMediaPlayer(view:UIView,mediaURL:String)
     func resetViewBounds(view:UIView)
}

protocol VidupDetailPageInteractorOutput {
    func HideandUnhideViewInteractor()
}

class VidupDetailPageInteractor: VidupDetailPageInteractorInput,adaptordelegte {
    
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
    
    
    func Test() {
        output.HideandUnhideViewInteractor()
    }
}
