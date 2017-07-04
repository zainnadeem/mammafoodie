import Foundation
import UIKit

protocol GoCookStep2PresenterInput {
    func setPreparationTime()
    func setupViewController()
    func selectDiet(_ diet : MFDishType)
    func setDealDuration()
    func selectMediaUploadType(_ type : GoCookMediaUploadType)
    func showOption(_ option : MFDishMediaType)
    func clearData()
}

protocol GoCookStep2PresenterOutput: class {
    
}

class GoCookStep2Presenter: GoCookStep2PresenterInput {
    weak var output: GoCookStep2PresenterOutput!
    weak var viewController : GoCookStep2ViewController?
    
    // MARK: - Presentation logic
    
    func clearData() {
        self.viewController?.txtTitle.text = ""
        self.viewController?.txtDealDuration.text = ""
        self.viewController?.pickerDealDuration.countDownDuration = 0
        self.viewController?.pickerPreparationTime.countDownDuration = 0
        self.viewController?.txtPricePerServing.text = ""
        self.viewController?.txtPreparationTime.text = ""
        self.viewController?.textViewDescription.text = ""
        self.viewController?.selectedDiet = .None
        self.viewController?.cuisinesAdapter.selectedCuisine = nil
        self.viewController?.cuisineCollectionView.reloadData()
        self.selectDiet(.None)
        self.selectMediaUploadType(.None)
        self.viewController?.lblServingsCount.text = "0"
        
        self.viewController?.selectedMediaUploadType = .None
        
    }
    
    func setupViewController() {
        if let allTextFields = self.viewController?.allTextFields {
            for txt in allTextFields {
                txt.layer.cornerRadius = 5.0
                txt.clipsToBounds = true
                txt.add(padding: 10, viewMode: .leftSide)
            }
        }
        
        self.viewController?.viewPictureUploadCamera.layer.cornerRadius = 5.0
        self.viewController?.viewPictureUploadCamera.clipsToBounds = true
        
        self.viewController?.viewVideoUploadContainer.layer.cornerRadius = 5.0
        self.viewController?.viewVideoUploadContainer.clipsToBounds = true
        
        self.viewController?.viewVideoShootContainer.layer.cornerRadius = 5.0
        self.viewController?.viewVideoShootContainer.clipsToBounds = true
        
        self.viewController?.textViewDescription.layer.cornerRadius = 5.0
        self.viewController?.textViewDescription.clipsToBounds = true
        
        self.viewController?.txtDealDuration.inputView = self.viewController?.pickerDealDuration
        
        self.viewController?.btnMinus.imageView?.contentMode = . scaleAspectFit
        self.viewController?.btnPlus.imageView?.contentMode = . scaleAspectFit
        
        self.viewController?.pickerPreparationTime.countDownDuration = 0.0
        self.viewController?.pickerDealDuration.countDownDuration = 0.0
        
        self.viewController?.btnPostDish.layer.cornerRadius = 22.0
        self.viewController?.btnPostDish.clipsToBounds = true
        
        self.viewController?.txtPreparationTime.inputView = self.viewController?.pickerPreparationTime
        
        self.setupPreviewButtons()
        self.setupPreviewCloseButtons()
    }
    
    func select(_ btnDiet : UIButton?) {
        if let btn = btnDiet {
            self.animate {
                btn.isSelected = true
            }
        }
    }
    
    func deselect(_ btnDiet : UIButton?) {
        if let btn = btnDiet {
            self.animate {
                btn.isSelected = false
            }
        }
    }
    
    func selectDiet(_ diet : MFDishType) {
        switch diet {
        case .Veg:
            self.select(self.viewController?.btnDietVeg)
            self.deselect(self.viewController?.btnDietVegan)
            self.deselect(self.viewController?.btnDietNonVeg)
            
        case .NonVeg:
            self.select(self.viewController?.btnDietNonVeg)
            self.deselect(self.viewController?.btnDietVegan)
            self.deselect(self.viewController?.btnDietVeg)
            
        case .Vegan:
            self.select(self.viewController?.btnDietVegan)
            self.deselect(self.viewController?.btnDietVeg)
            self.deselect(self.viewController?.btnDietNonVeg)
            
        default:
            break
        }
    }
    
    func animate(_ animation :@escaping () -> Void) {
        UIView.animate(withDuration: 0.27, delay: 0, options: .curveEaseInOut, animations: animation) { (finished) in
            
        }
    }
    
    func setPreparationTime() {
        if let time = self.viewController?.pickerPreparationTime.countDownDuration {
            let (h, m) = self.secondsToHoursMinutes(Int(time))
            self.viewController?.txtPreparationTime.text = "\(h):\(m)"
        }
    }
    
    func setDealDuration() {
        if let time = self.viewController?.pickerDealDuration.countDownDuration {
            let (h, m) = self.secondsToHoursMinutes(Int(time))
            self.viewController?.txtDealDuration.text = "\(h):\(m)"
        }
    }
    
    func secondsToHoursMinutes(_ seconds : Int) -> (Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60)
    }
    
    func selectMediaUploadType(_ type : GoCookMediaUploadType) {
        switch type {
        case .PictureUpload:
            self.selectView(self.viewController?.viewPictureUploadCamera)
            self.deselectView(self.viewController?.viewVideoShootContainer)
            self.deselectView(self.viewController?.viewVideoUploadContainer)
            
        case .VideoShoot:
            self.selectView(self.viewController?.viewVideoShootContainer)
            self.deselectView(self.viewController?.viewPictureUploadCamera)
            self.deselectView(self.viewController?.viewVideoUploadContainer)
            
        case .VideoUpload:
            self.selectView(self.viewController?.viewVideoUploadContainer)
            self.deselectView(self.viewController?.viewVideoShootContainer)
            self.deselectView(self.viewController?.viewPictureUploadCamera)
            
        default:
            self.deselectView(self.viewController?.viewVideoUploadContainer)
            self.deselectView(self.viewController?.viewVideoShootContainer)
            self.deselectView(self.viewController?.viewPictureUploadCamera)
            break
        }
    }
    
    func selectView(_ viewSelected : UIView?) {
        if let view = viewSelected {
            self.animate {
                view.backgroundColor = selectedBackColor
                view.addGradienBorder(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight, borderWidth: 3.0, animated: true)
            }
            for subView in view.subviews {
                if let btn = subView as? UIButton {
                    self.animate {
                        btn.isSelected = true
                    }
                }
                
                if let lbl = subView as? UILabel {
                    self.animate {
                        lbl.isHighlighted = true
                    }
                }
            }
        }
    }
    
    func deselectView(_ viewSelected : UIView?) {
        if let view = viewSelected {
            self.animate {
                view.removeGradient()
                view.backgroundColor = unselectedBackColor
            }
            for subView in view.subviews {
                if let btn = subView as? UIButton {
                    self.animate {
                        btn.isSelected = false
                        btn.removeGradient()
                    }
                }
                
                if let lbl = subView as? UILabel {
                    self.animate {
                        lbl.isHighlighted = false
                    }
                }
            }
        }
    }
    
    func showOption(_ option : MFDishMediaType) {
        switch option {
        case .vidup:
            self.showVidupMode()
            
        case .picture:
            self.showPictureMode()
            
        default:
            self.showLiveVideoMode()
        }
        self.viewController?.view.layoutIfNeeded()
    }
    
    private func showVidupMode() {
        self.viewController?.viewPictureContainer.isHidden = true
        self.viewController?.viewVideoContainer.isHidden = false
        
        var deactivatedCons : [NSLayoutConstraint] = [NSLayoutConstraint]()
        if let layout = self.viewController?.conVerticalCuisineClnView_lblPrepareTime {
            deactivatedCons.append(layout)
        }
        
        if let layout = self.viewController?.conVerticalViewPictureContainer_lblPrepareTime {
            deactivatedCons.append(layout)
        }
        
        NSLayoutConstraint.deactivate(deactivatedCons)
        
        
        var activatedCons : [NSLayoutConstraint] = [NSLayoutConstraint]()
        
        if let layout = self.viewController?.conVerticalViewVideoContainer_lblPreparationTime {
            activatedCons.append(layout)
        }
        NSLayoutConstraint.activate(activatedCons)
        self.viewController?.view.setNeedsLayout()
        
    }
    
    private func showLiveVideoMode() {
        self.viewController?.viewPictureContainer.isHidden = true
        self.viewController?.viewVideoContainer.isHidden = true
        
        var deactivatedCons : [NSLayoutConstraint] = [NSLayoutConstraint]()
        
        if let layout = self.viewController?.conVerticalViewVideoContainer_lblPreparationTime {
            deactivatedCons.append(layout)
        }
        
        if let layout = self.viewController?.conVerticalViewPictureContainer_lblPrepareTime {
            deactivatedCons.append(layout)
        }
        
        NSLayoutConstraint.deactivate(deactivatedCons)
        
        
        var activatedCons : [NSLayoutConstraint] = [NSLayoutConstraint]()
        if let layout = self.viewController?.conVerticalCuisineClnView_lblPrepareTime {
            activatedCons.append(layout)
        }
        NSLayoutConstraint.activate(activatedCons)
        self.viewController?.view.setNeedsLayout()
    }
    
    private func showPictureMode() {
        self.viewController?.viewPictureContainer.isHidden = false
        self.viewController?.viewVideoContainer.isHidden = true
        
        var deactivatedCons : [NSLayoutConstraint] = [NSLayoutConstraint]()
        if let layout = self.viewController?.conVerticalViewVideoContainer_lblPreparationTime {
            deactivatedCons.append(layout)
        }
        
        if let layout = self.viewController?.conVerticalCuisineClnView_lblPrepareTime {
            deactivatedCons.append(layout)
        }
        
        NSLayoutConstraint.deactivate(deactivatedCons)
        
        
        var activatedCons : [NSLayoutConstraint] = [NSLayoutConstraint]()
        if let layout = self.viewController?.conVerticalViewPictureContainer_lblPrepareTime {
            activatedCons.append(layout)
        }
        NSLayoutConstraint.activate(activatedCons)
        self.viewController?.view.setNeedsLayout()
    }
    
    private func setupPreviewCloseButtons() {
        if let closeButtons = self.viewController?.previewCloseButtons {
            for btnClose in  closeButtons {
                btnClose.layer.cornerRadius = btnClose.frame.size.height / 2
                btnClose.imageView?.contentMode = .scaleAspectFit
                btnClose.addGradienBorder(colors: [gradientStartColor, gradientEndColor], direction : .topToBottom, borderWidth : 1.0, animated : true)
                btnClose.isHidden = true
            }
        }
    }
    
    private func setupPreviewButtons() {
        if let previewButtons = self.viewController?.previewButtons {
            for btnPreview in  previewButtons {
                btnPreview.imageView?.contentMode = .scaleAspectFit
                btnPreview.backgroundColor = .white
                btnPreview.setImage(nil, for: .normal)
                btnPreview.layer.shadowColor = UIColor.black.cgColor
                btnPreview.layer.shadowOpacity = 0.3
                btnPreview.layer.shadowOffset = CGSize.init(width: 0, height: 0.3)
                btnPreview.layer.shadowRadius = 2.0
                btnPreview.isHidden = true
            }
        }
    }
    
}
