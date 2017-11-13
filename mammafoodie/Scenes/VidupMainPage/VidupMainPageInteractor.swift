import UIKit

protocol VidupMainPageInteractorInput {
    func loadVidups()
}

protocol VidupMainPageInteractorOutput {
    func presentVidups(_ response: VidupMainPage.Response)
}

class VidupMainPageInteractor: VidupMainPageInteractorInput {
    
    var output: VidupMainPageInteractorOutput!
    var worker: DealsListWorker = DealsListWorker()
    
    // MARK: - Business logic
    func loadVidups() {
        self.worker.getList { (dishes) in
            DispatchQueue.main.async {
                let response = VidupMainPage.Response(arrayOfVidups: dishes)
                self.output.presentVidups(response)
            }
        }
    }
}
