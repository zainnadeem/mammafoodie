import UIKit

protocol LiveVideoMainPageInteractorInput {
    func loadLiveVideos()
    
}

protocol LiveVideoMainPageInteractorOutput {
    func presentLiveVideos(_ response: LiveVideoMainPage.Response)
}

class LiveVideoMainPageInteractor: LiveVideoMainPageInteractorInput {
    
    var output: LiveVideoMainPageInteractorOutput!
    let loadLiveVideoWorker = LoadLiveVideosWorker()
    
    // MARK: - Business logic
    
    func loadLiveVideos() {
        loadLiveVideoWorker.callAPI { liveVideos in
            let response = LiveVideoMainPage.Response(arrayOfLiveVideos: liveVideos)
            output.presentLiveVideos(response)
  
        }
    }
    
}
