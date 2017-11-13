import UIKit

protocol GoCookPresenterInput {
    func prepareOptions()
    func selectOption(option : MFDishMediaType)
    func showStep1()
    func showStep2(_ animated: Bool)
}

protocol GoCookPresenterOutput: class {
    
}

let gradientStartColor : UIColor = UIColor.init(red: 1.0, green: 0.55, blue: 0.17, alpha: 1.0)
let gradientEndColor : UIColor = UIColor.init(red: 1.0, green: 0.39, blue: 0.13, alpha: 1.0)

let unselectedBackColor : UIColor = UIColor.init(red: 0.97, green: 0.97, blue: 0.98, alpha: 1.0)
let selectedBackColor : UIColor = .white

let selectedFont : UIFont? = UIFont.MontserratSemiBold(with: 17.0)
let unselectedFont : UIFont? = UIFont.MontserratLight(with: 16.0)


class GoCookPresenter: GoCookPresenterInput {
    weak var output: GoCookPresenterOutput?
    weak var viewController : GoCookViewController?
    
    // MARK: - Presentation logic
    func animate(_ animation :@escaping () -> Void) {
        UIView.animate(withDuration: 0.27, delay: 0, options: .curveEaseInOut, animations: animation) { (finished) in
            
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
                    if let font = selectedFont {
                        lbl.font = font
                    }
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
                    if let font = unselectedFont {
                        lbl.font = font
                    }
                }
            }
        }
        }
    }
    
    func selectOption(option: MFDishMediaType) {
        switch  option {
        case .liveVideo:
            self.viewController?.btnNext.applyGradient(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight)
            self.selectView(self.viewController?.viewLiveVideo)
            self.deselectView(self.viewController?.viewVidups)
            self.deselectView(self.viewController?.viewMenu)
            self.viewController?.btnNext.isEnabled = true
            break
            
        case .vidup:
            self.viewController?.btnNext.applyGradient(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight)
            self.selectView(self.viewController?.viewVidups)
            self.deselectView(self.viewController?.viewLiveVideo)
            self.deselectView(self.viewController?.viewMenu)
            self.viewController?.btnNext.isEnabled = true
            break
            
        case .picture:
            self.viewController?.btnNext.applyGradient(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight)
            self.selectView(self.viewController?.viewMenu)
            self.deselectView(self.viewController?.viewLiveVideo)
            self.deselectView(self.viewController?.viewVidups)
            self.viewController?.btnNext.isEnabled = true
            break
            
        default:
            self.deselectView(self.viewController?.viewLiveVideo)
            self.deselectView(self.viewController?.viewVidups)
            self.deselectView(self.viewController?.viewMenu)
            self.viewController?.btnNext.removeGradient()
            self.viewController?.btnNext.isEnabled = false
            break
            
        }
    }
    
    func prepareOptions() {
        if let allButtons = self.viewController?.allButtons {
            for btn : UIButton in allButtons {
                btn.imageView?.contentMode = .scaleAspectFit
            }
        }
        
        if let allViewOptions = self.viewController?.allViewOptions {
            for viewOption in allViewOptions {
                viewOption.removeGradient()
                viewOption.layer.cornerRadius = 5.0
                viewOption.clipsToBounds = true
            }
        }
        self.viewController?.btnNext.layer.cornerRadius = 26.0
        self.viewController?.btnNext.clipsToBounds = true
    }
    
    func showStep2(_ animated: Bool) {
        if self.viewController?.selectedOption != MFDishMediaType.unknown {
            self.viewController?.btnStep2.isSelected = true
            self.viewController?.btnStep1.isSelected = false
            self.moveStep2(true, animated: false)
        }
    }
    
    func showStep1() {
        self.viewController?.btnStep2.isSelected = false
        self.viewController?.btnStep1.isSelected = true
        self.moveStep2(false, animated: true)
    }
    
    func start(_ meidaOption : MFDishMediaType) {
        self.viewController?.selectedOption = meidaOption
        if let btnNext = self.viewController?.btnNext {
            self.viewController?.onNext(btnNext)
        }
    }
    
    
    //MARK: - Private Methods
    private func moveStep2(_ move : Bool, animated: Bool) {
        var distance : CGFloat = 0
        if move {
            if let width = self.viewController?.viewStep1.frame.size.width {
                distance = width * -1
            }
        }
        UIView.animate(withDuration: animated ? 0.27 : 0, animations: {
            self.viewController?.conLeadingViewStep1.constant = distance
            self.viewController?.view.layoutIfNeeded()
        }, completion: nil)
    }
}
