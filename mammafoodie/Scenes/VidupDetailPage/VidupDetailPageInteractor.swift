import UIKit

protocol Interactordelegate {
    func HideandUnhideView()
    func DisplayTime(Time:TimeInterval)
}

protocol VidupDetailPageInteractorInput {
    func setupMediaPlayer(view:UIView,user_id:String,dish_id: String)
    func resetViewBounds(view:UIView)
    func stopTimer()
}

protocol VidupDetailPageInteractorOutput {
    func HideandUnhideViewInteractor()
    func DisplayTimeInteractor(Time:TimeInterval)
    func UserInfo(UserInfo:MFUser)
    func DishInfo(DishInfo:MFDish,MediaInfo:MFMedia)
}

class VidupDetailPageInteractor: VidupDetailPageInteractorInput,Interactordelegate {
    
    var output: VidupDetailPageInteractorOutput!
    var Vidupworker: VidupDetailPageWorker! = VidupDetailPageWorker()
    var VidupTimerworker: TimerWorker! = TimerWorker()
    
    
    
    // MARK: - Business logic
    
    func setupMediaPlayer(view:UIView,user_id:String,dish_id: String){
        //Setup the media player
        Vidupworker.delegate = self
        Vidupworker.SetupMediaPlayer(view: view)
        Vidupworker.GetUserDetails(Id: user_id) { (Userdetails) in
            self.output.UserInfo(UserInfo: Userdetails)
        }
        
        Vidupworker.GetDishInfo(Id: dish_id) { (Dishdetails,MediaDetails) in
            if Dishdetails != nil {
                self.output.DishInfo(DishInfo: Dishdetails!,MediaInfo: MediaDetails!)
                self.VidupTimerworker.delegate = self
                self.Vidupworker.PlayVideo(MediaURL: (MediaDetails?.id)!)
                if Int((MediaDetails?.dealTime)!) > 0 {
                    self.VidupTimerworker.seconds = 10
                    self.VidupTimerworker.runTimer()
                }
            }
        }
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
