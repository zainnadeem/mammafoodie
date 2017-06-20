import UIKit

protocol VidupDetailPagePresenterInput {
    func HideandUnhideViewInteractor()
    func DisplayTimeInteractor(Time:TimeInterval)
}

protocol VidupDetailPagePresenterOutput: class {
    func HideandUnhideView()
    func DisplayTime(Time:String)
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
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }

}
