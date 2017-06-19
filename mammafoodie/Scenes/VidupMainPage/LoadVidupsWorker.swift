import UIKit

class LoadVidupsWorker {

    let dData = DummyData.sharedInstance
    
    func callAPI(completion: ([MFMedia]) -> Void){
        print("Place firebase logic for obtaining live video links")
        dData.populateVidupPage { media in
            completion(media)
        }
    }

}
