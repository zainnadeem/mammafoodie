import UIKit

protocol VidupMainPageInteractorInput {
    func loadVidups()
}

protocol VidupMainPageInteractorOutput {
    func presentVidups(_ response: VidupMainPage.Response)
}

class VidupMainPageInteractor: VidupMainPageInteractorInput {
    
    var output: VidupMainPageInteractorOutput!
//    var worker = LoadVidupsWorker()
    
    var liveVideoListWorker = LiveVideoListWorker()
    
    // MARK: - Business logic
    func loadVidups() {
//        worker.callAPI { vidups in
//            let response = VidupMainPage.Response(arrayOfVidups: vidups)
//            self.output.presentVidups(response)
//        }
        
        liveVideoListWorker.getList { (vidups) in
            let response = VidupMainPage.Response(arrayOfVidups: vidups)
            self.output.presentVidups(response)
        }
        
    }
}
