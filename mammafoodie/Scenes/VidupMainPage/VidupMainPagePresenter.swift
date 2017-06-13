import UIKit

protocol VidupMainPagePresenterInput {
    func presentVidups(_ response: VidupMainPage.Response)
}

protocol VidupMainPagePresenterOutput: class {
    func addVideosToVC(_ response: VidupMainPage.Response)
}

class VidupMainPagePresenter: VidupMainPagePresenterInput {
    weak var output: VidupMainPagePresenterOutput!
    
    // MARK: - Presentation logic
    func presentVidups(_ response: VidupMainPage.Response) {
        self.output.addVideosToVC(response)
    }
}
