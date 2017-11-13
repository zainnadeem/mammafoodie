import UIKit

protocol LiveVideoMainPageInteractorInput {
    func loadLiveVideos()
    
}

protocol LiveVideoMainPageInteractorOutput {
    func presentLiveVideos(_ response: LiveVideoMainPage.Response)
}

class LiveVideoMainPageInteractor: LiveVideoMainPageInteractorInput {
    
    var output: LiveVideoMainPageInteractorOutput!
//    let loadLiveVideoWorker = LoadLiveVideosWorker()
    
    let liveVideoListWorker = LiveVideoListWorker()
    
    
    // MARK: - Business logic
    
    func loadLiveVideos() {
//        loadLiveVideoWorker.callAPI { liveVideos in
//            let response = LiveVideoMainPage.Response(arrayOfLiveVideos: liveVideos)
//            output.presentLiveVideos(response)
//  
//        }
        
        liveVideoListWorker.getList { (liveVideos) in
            DispatchQueue.main.async {
                let response = LiveVideoMainPage.Response(arrayOfLiveVideos: liveVideos)
                self.output.presentLiveVideos(response)
            }
        }
    }
    
}
