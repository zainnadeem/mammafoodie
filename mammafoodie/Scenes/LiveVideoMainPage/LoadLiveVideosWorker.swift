import UIKit

class LoadLiveVideosWorker {
    // MARK: - Business Logic
    
   
    func callAPI(completion: ([MFMedia]) -> Void){
        print("Place firebase logic for obtaining live video links")
        
        let video = MFMedia()
        let video2 = MFMedia()
        let video3 = MFMedia()

        completion([video, video2, video3])
    }

}
