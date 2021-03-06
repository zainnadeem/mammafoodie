import UIKit

protocol GoCookStep2InteractorInput {
    func setPreparationTime()
    func setupViewController()
    func selectDiet(_ diet : MFDishType)
    func setDealDuration()
    func selectMediaUploadType(_ type : GoCookMediaUploadType)
    func showOption(_ option : MFDishMediaType)
    func clearData()
}

protocol GoCookStep2InteractorOutput {
    func setPreparationTime()
    func setupViewController()
    func selectDiet(_ diet : MFDishType)
    func setDealDuration()
    func selectMediaUploadType(_ type : GoCookMediaUploadType)
    func showOption(_ option : MFDishMediaType)
    func clearData()
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
    
    func selectDiet(_ diet : MFDishType) {
        self.output.selectDiet(diet)
    }
    
    func setDealDuration() {
        self.output.setDealDuration()
    }
    
    func selectMediaUploadType(_ type : GoCookMediaUploadType) {
        self.output.selectMediaUploadType(type)
    }
    
    func showOption(_ option : MFDishMediaType) {
        self.output.showOption(option)
    }
    func clearData() {
        self.output.clearData()
    }
    
}
