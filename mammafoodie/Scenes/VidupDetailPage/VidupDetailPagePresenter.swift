import UIKit

protocol VidupDetailPagePresenterInput {
    func HideandUnhideViewInteractor()
    func DisplayTimeInteractor(Time:TimeInterval)
    func UserInfo(UserInfo:MFUser)
     func DishInfo(DishInfo:MFDish,MediaInfo:MFMedia)
    func UpdateLikeCountInteractor(likeCount:Int)
    func UpdateLikeStatusInteractor(Status:Bool)
}

protocol VidupDetailPagePresenterOutput: class {
    func HideandUnhideView()
    func DisplayTime(Time:String)
    func DisplayUserInfo(UserInfo:MFUser)
    func DisplayDishInfo(DishInfo:MFDish,MediaInfo:MFMedia)
    func UpdateLikeCount(likeCount:Int)
    func UpdateLikeStatus(Status:Bool)

}

class VidupDetailPagePresenter: VidupDetailPagePresenterInput {
   

    weak var output: VidupDetailPagePresenterOutput!
    
    // MARK: - Presentation logic
    func HideandUnhideViewInteractor() {
        output.HideandUnhideView()
    }
    
    
    func DisplayTimeInteractor(Time:TimeInterval){
        output.DisplayTime(Time: self.timeString(time: Time))
    }
    
    func UpdateLikeCountInteractor(likeCount: Int) {
        output.UpdateLikeCount(likeCount: likeCount)
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func UserInfo(UserInfo:MFUser){
        output.DisplayUserInfo(UserInfo: UserInfo)
    }
    
    func DishInfo(DishInfo:MFDish,MediaInfo:MFMedia){
        output.DisplayDishInfo(DishInfo: DishInfo,MediaInfo: MediaInfo)
    }

    func UpdateLikeStatusInteractor(Status: Bool) {
        output.UpdateLikeStatus(Status: Status)
    }
}
