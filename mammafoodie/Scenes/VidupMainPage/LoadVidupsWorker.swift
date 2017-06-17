import UIKit

class LoadVidupsWorker {

    func callAPI(completion: ([MFMedia]) -> Void){
        print("Place firebase logic for obtaining vidups")
        
        let video = MFMedia()
        let video2 = MFMedia()
        let video3 = MFMedia()
        
        completion([video, video2, video3])
    }

}
