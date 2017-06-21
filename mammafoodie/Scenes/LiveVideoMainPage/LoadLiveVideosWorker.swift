import UIKit

class LoadLiveVideosWorker {
    // MARK: - Business Logic
    let dData = DummyData.sharedInstance
   
    func callAPI(completion: ([MFMedia]) -> Void){
        print("Place firebase logic for obtaining live video links")
        dData.populateLiveVideos { media in
            completion(media)
        }
    }

}
