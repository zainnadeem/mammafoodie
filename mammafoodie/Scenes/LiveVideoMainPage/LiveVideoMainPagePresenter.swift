import UIKit

protocol LiveVideoMainPagePresenterInput {
    func presentLiveVideos(_ response: LiveVideoMainPage.Response)
}

protocol LiveVideoMainPagePresenterOutput: class {
     func displayLiveVideos(_ response: LiveVideoMainPage.Response)
    
}

class LiveVideoMainPagePresenter: LiveVideoMainPagePresenterInput {
    weak var output: LiveVideoMainPagePresenterOutput!
    
    // MARK: - Presentation logic
    
    func presentLiveVideos(_ response: LiveVideoMainPage.Response) {
        self.output.displayLiveVideos(response)
    }
    
}
