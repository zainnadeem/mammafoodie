import UIKit

class LoadVidupsWorker {

    func callAPI(completion: ([Vidup]) -> Void){
        print("Place firebase logic for obtaining vidups")
        
        let video = Vidup(name: "4")
        let video2 = Vidup(name: "5")
        let video3 = Vidup(name: "6")
        
        completion([video, video2, video3])
    }

}
