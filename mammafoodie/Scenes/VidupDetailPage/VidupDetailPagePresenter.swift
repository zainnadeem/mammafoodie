import UIKit

protocol VidupDetailPagePresenterInput {
    func HideandUnhideViewInteractor()
}

protocol VidupDetailPagePresenterOutput: class {
    func HideandUnhideView()
}

class VidupDetailPagePresenter: VidupDetailPagePresenterInput {
    weak var output: VidupDetailPagePresenterOutput!
    
    // MARK: - Presentation logic
    func HideandUnhideViewInteractor() {
        output.HideandUnhideView()
    }
    
}
