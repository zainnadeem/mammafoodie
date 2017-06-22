import UIKit

protocol GoCookPresenterInput {
    func prepareOptions()
    func selectOption(option : GoCookOption)
    func showStep1()
    func showStep2()
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
    weak var output: GoCookPresenterOutput!
    
    weak var viewController : GoCookViewController!
    
    // MARK: - Presentation logic
    func animate(_ animation :@escaping () -> Void) {
        UIView.animate(withDuration: 0.27, delay: 0, options: .curveEaseInOut, animations: animation) { (finished) in
            
        }
    }
    
    func selectView(_ viewSelected : UIView) {
        self.animate {
            viewSelected.backgroundColor = selectedBackColor
            viewSelected.addGradienBorder(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight, borderWidth: 3.0, animated: true)
        }
        for subView in viewSelected.subviews {
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
    
    func deselectView(_ viewSelected : UIView) {
        self.animate {
            viewSelected.removeGradient()
            viewSelected.backgroundColor = unselectedBackColor
        }
        for subView in viewSelected.subviews {
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
    
    func selectOption(option: GoCookOption) {
        switch  option {
        case .LiveVideo:
            self.viewController.btnNext.applyGradient(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight)
            self.selectView(self.viewController.viewLiveVideo)
            self.deselectView(self.viewController.viewVidups)
            self.deselectView(self.viewController.viewMenu)
            break
            
        case .Vidups:
            self.viewController.btnNext.applyGradient(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight)
            self.selectView(self.viewController.viewVidups)
            self.deselectView(self.viewController.viewLiveVideo)
            self.deselectView(self.viewController.viewMenu)
            break
            
        case .Picture:
            self.viewController.btnNext.applyGradient(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight)
            self.selectView(self.viewController.viewMenu)
            self.deselectView(self.viewController.viewLiveVideo)
            self.deselectView(self.viewController.viewVidups)
            break
            
        default:
            self.deselectView(self.viewController.viewLiveVideo)
            self.deselectView(self.viewController.viewVidups)
            self.deselectView(self.viewController.viewMenu)
            self.viewController.btnNext.removeGradient()
            break
            
        }
    }
    
    func prepareOptions() {
        for btn in self.viewController.allButtons {
            btn.imageView?.contentMode = .scaleAspectFit
        }
        
        for viewOption in self.viewController.allViewOptions {
            viewOption.removeGradient()
            viewOption.layer.cornerRadius = 5.0
            viewOption.clipsToBounds = true
        }
        self.viewController.btnNext.layer.cornerRadius = 26.0
        self.viewController.btnNext.clipsToBounds = true
    }
    
    func showStep2() {
        self.viewController.btnStep2.isSelected = true
        self.viewController.btnStep1.isSelected = false
        self.moveStep2(true)
    }
    
    func showStep1() {
        self.viewController.btnStep2.isSelected = false
        self.viewController.btnStep1.isSelected = true
        self.moveStep2(false)
    }
    
    func start(_ meidaOption : GoCookOption) {
        self.viewController.selectedOption = meidaOption
        self.viewController.onNext(self.viewController.btnNext)
    }
    
    //MARK: - Private Methods
    private func moveStep2(_ move : Bool) {
        var distance : CGFloat = 0
        if move {
            distance = self.viewController.viewStep1.frame.size.width * -1
        }
        self.animate {
            self.viewController.conLeadingViewStep1.constant = distance
            self.viewController.view.layoutIfNeeded()
        }
    }
}
