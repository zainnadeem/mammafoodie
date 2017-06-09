import UIKit

protocol LiveVideoMainPageInteractorInput {
    func loadLiveVideos()
    
}

protocol LiveVideoMainPageInteractorOutput {
    func showLiveVideos(_ response: LiveVideoMainPage.Response)
}

class LiveVideoMainPageInteractor: LiveVideoMainPageInteractorInput {
    
    var output: LiveVideoMainPageInteractorOutput!
    
    // MARK: - Business logic
    
    func loadLiveVideos() {
        print("sending work to the worker from the interactor")
        let loadLiveVideoWorker = LoadLiveVideosWorker()
        loadLiveVideoWorker.callAPI { liveVideos in
            let response = LiveVideoMainPage.Response(arrayOfLiveVideos: liveVideos)
            print("got the vids from the worker back in the interactor, now passing to presenter")
            output.showLiveVideos(response)
  
        }
    }
    
}
