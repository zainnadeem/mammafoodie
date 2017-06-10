import UIKit

class LoadVidupsWorker {
    // MARK: - Business Logic
    
    func callAPI(completion: ([Vidup]) -> Void){
        print("API Called Got The Videos From Firebase")
        
        let video = Vidup(name: "4")
        let video2 = Vidup(name: "5")
        let video3 = Vidup(name: "6")
        
        completion([video, video2, video3])
    }

}
