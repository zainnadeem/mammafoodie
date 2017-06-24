import UIKit

protocol GoCookStep2InteractorInput {
    func setPreparationTime()
    func setupViewController()
    func selectDiet(_ diet : GoCookDiet)
    func setDealDuration()
    func selectMediaUploadType(_ type : GoCookMediaUploadType)
    func showOption(_ option : MFMediaType)
}

protocol GoCookStep2InteractorOutput {
    func setPreparationTime()
    func setupViewController()
    func selectDiet(_ diet : GoCookDiet)
    func setDealDuration()
    func selectMediaUploadType(_ type : GoCookMediaUploadType)
    func showOption(_ option : MFMediaType)
}

class GoCookStep2Interactor: GoCookStep2InteractorInput {
    
    var output: GoCookStep2InteractorOutput!
    var worker: GoCookStep2Worker!
    
    // MARK: - Business logic
    func setPreparationTime() {
        self.output.setPreparationTime()
    }
    
    func setupViewController() {
        self.output.setupViewController()
    }
    
    func selectDiet(_ diet : GoCookDiet) {
        self.output.selectDiet(diet)
    }
    
    func setDealDuration() {
        self.output.setDealDuration()
    }
    
    func selectMediaUploadType(_ type : GoCookMediaUploadType) {
        self.output.selectMediaUploadType(type)
    }
    
    func showOption(_ option : MFMediaType) {
        self.output.showOption(option)
    }
    
}
