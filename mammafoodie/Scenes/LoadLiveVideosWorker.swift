import UIKit

class LoadLiveVideosWorker {
    // MARK: - Business Logic
    
    func callAPI(completion: ([LiveVideo]) -> Void){
        print("API Called")
        let video = LiveVideo(name: "AwesomeVid")
        completion([video])
    }

}
