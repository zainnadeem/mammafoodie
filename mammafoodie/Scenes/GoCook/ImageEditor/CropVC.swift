//
//  CropVC.swift
//  Filters
//
//  Created by Arjav Lad on 18/05/17.
//  Copyright © 2017 Aakar Solutions. All rights reserved.
//

import UIKit

typealias CropCompletion = (Image) -> Void

class CropVC: UIViewController {
    
    var originalImage : Image!
    var editedImage : Image!
    var angle: Double = 0.0
    var imageEditorDelegate : ImageEditorDelegate?
    
    var completion : CropCompletion?
    
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var viewCrop: AKImageCropperView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewCrop.delegate = self
        self.viewCrop.image = self.originalImage.image
        self.editedImage = self.originalImage
        self.viewCrop.showOverlayView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onCrop(_ sender: UIBarButtonItem) {
        if self.viewCrop.isEdited {
            self.editedImage = Image.init(self.viewCrop.croppedImage!)
            self.imageEditorDelegate?.imageEdited(self.editedImage)
            self.completion?(self.editedImage)
        } else {
            self.imageEditorDelegate?.imageEdited(self.originalImage)
            self.completion?(self.originalImage)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onRotate(_ sender: UIBarButtonItem) {
        self.angle += (Double.pi / 2)
        self.viewCrop.rotate(self.angle, withDuration: 0.3, completion: { _ in
            if self.angle == 2 * Double.pi {
                self.angle = 0.0
            }
        })
    }
    
    @IBAction func onReset(_ sender: UIBarButtonItem) {
        self.viewCrop.reset(animationDuration: 0.3)
        self.angle = 0.0
    }

}

extension CropVC : UIToolbarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .bottom
    }
}

extension CropVC : AKImageCropperViewDelegate {
    func imageCropperViewDidChangeCropRect(view: AKImageCropperView, cropRect rect: CGRect) {
        
    }
}
