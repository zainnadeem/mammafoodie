import UIKit

protocol LiveVideoMainPagePresenterInput {
    func showLiveVideos(_ response: LiveVideoMainPage.Response)
}

protocol LiveVideoMainPagePresenterOutput: class {
     func displayLiveVideos(_ response: LiveVideoMainPage.Response)
    
}

class LiveVideoMainPagePresenter: LiveVideoMainPagePresenterInput {
    weak var output: LiveVideoMainPagePresenterOutput!
    
    // MARK: - Presentation logic
    
    func showLiveVideos(_ response: LiveVideoMainPage.Response) {
        print("showing live videos function in the presenter")
        self.output.displayLiveVideos(response)
    }
    
}
