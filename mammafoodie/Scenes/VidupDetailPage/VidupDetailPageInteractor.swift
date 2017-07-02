import UIKit

protocol Interactordelegate {
    func HideandUnhideView()
    func DisplayTime(Time:TimeInterval)
}

protocol VidupDetailPageInteractorInput {
    func setupMediaPlayer(view:UIView,user_id:String,dish_id: String)
    func resetViewBounds(view:UIView)
    func stopTimer()
    func dishLiked(user_id:String,dish_id: String)
    func dishUnliked(user_id:String,dish_id: String)
}

protocol VidupDetailPageInteractorOutput {
    func HideandUnhideViewInteractor()
    func DisplayTimeInteractor(Time:TimeInterval)
    func UserInfo(UserInfo:MFUser)
    func DishInfo(DishInfo:MFDish)
    func UpdateLikeCountInteractor(likeCount:Int)
    func UpdateLikeStatusInteractor(Status:Bool)
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
        
        Vidupworker.GetDishLikeDetails(Id: dish_id) { (LikeCount) in
            self.output.UpdateLikeCountInteractor(likeCount: LikeCount)
        }
        
        Vidupworker.GetDishInfo(Id: dish_id) { (dishDetails) in
            if dishDetails != nil{
                self.output.DishInfo(DishInfo: dishDetails!)
                self.VidupTimerworker.delegate = self
                self.Vidupworker.PlayVideo(MediaURL: dishDetails?.mediaURL)
                self.Vidupworker.getexpireTime(endedAt: dishDetails.endTimestamp)
            }
        }
        
        
        /*
        self.Vidupworker.GetDishInfo(Id: dish_id) { (Dishdetails,MediaDetails) in
            if Dishdetails != nil {
                self.output.DishInfo(DishInfo: Dishdetails!,MediaInfo: MediaDetails!)
                self.VidupTimerworker.delegate = self
                self.Vidupworker.PlayVideo(MediaURL: (MediaDetails?.generateVidUpVideoURL())!)
                if Int((MediaDetails?.dealTime)!) > 0 {
                    
                    var timeLeft:Int = self.Vidupworker.getexpireTime(endedAt: (MediaDetails?.endedAt)!)
                    
                    if timeLeft < 0 {
                        timeLeft = 0
                    }
                    
                    self.VidupTimerworker.seconds = timeLeft
                    self.VidupTimerworker.runTimer()
                }
            }
        }
        */
        
        Vidupworker.GetlikeStatus(Id: user_id, DishId: dish_id) { (status) in
            self.output.UpdateLikeStatusInteractor(Status: status)
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
    
    
    func dishLiked(user_id:String,dish_id: String){
        Vidupworker.likeDish(Id: user_id, DishId: dish_id)
    }
    
    
    func dishUnliked(user_id:String,dish_id: String){
        Vidupworker.UnlikeDish(Id: user_id, DishId: dish_id)
    }
}
