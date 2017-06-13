import UIKit

class LoadLiveVideosWorker {
    // MARK: - Business Logic
    
   
    func callAPI(completion: ([LiveVideo]) -> Void){
        print("Place firebase logic for obtaining live video links")
        
        let video = LiveVideo(name: "1")
        let video2 = LiveVideo(name: "2")
        let video3 = LiveVideo(name: "3")

        completion([video, video2, video3])
    }

}
