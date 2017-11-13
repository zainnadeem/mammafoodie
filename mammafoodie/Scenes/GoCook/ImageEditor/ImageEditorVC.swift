//
//  ImageEditorVC.swift
//  Filters
//
//  Created by Arjav Lad on 16/05/17.
//  Copyright © 2017 FV iMAGINATION. All rights reserved.
//

import UIKit

protocol ImageEditorDelegate {
    func imageEdited(_ image: Image)
}

typealias ImageEditorCompletion = (UIImage?) -> Void

class ImageEditorVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollImage: UIScrollView!
    @IBOutlet weak var bottomToolbar : UIToolbar!
    @IBOutlet weak var txtAddText: UITextField!
    
    @IBOutlet weak var btnTextEdit: UIBarButtonItem!
    
    var tapGesture : UITapGestureRecognizer!
    var tapZoomGesture : UITapGestureRecognizer!
    
    var panGestureText : UIPanGestureRecognizer!
    
    var originalImage : Image!
    var editedImage : Image!
    var completion : ImageEditorCompletion?
    var firstX : CGFloat = 0
    var firstY : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.scrollImage.clipsToBounds = false
        self.scrollImage.delegate = self
        self.scrollImage.setZoomScale(1.0, animated: true)
        self.scrollImage.maximumZoomScale = 3.0
        self.scrollImage.minimumZoomScale = 1.0
        
        self.imageView.isUserInteractionEnabled = true
        self.tapZoomGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapZoomGesture(_:)))
        self.tapZoomGesture.numberOfTapsRequired = 2
        self.tapZoomGesture.numberOfTouchesRequired = 1
        self.imageView.addGestureRecognizer(self.tapZoomGesture)
        self.tapZoomGesture.isEnabled = true
        
        self.editedImage = self.originalImage
        self.imageView.image = self.originalImage.image
        
        self.panGestureText = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureHandler(_:)))
        self.panGestureText.maximumNumberOfTouches = 1
        self.panGestureText.minimumNumberOfTouches = 1
        self.panGestureText.isEnabled = true
        self.txtAddText.addGestureRecognizer(self.panGestureText)
        //        self.txtAddText.backgroundColor = .white
    }
    
    func tapZoomGesture(_ tap: Any) {
        if self.scrollImage.zoomScale > 1.0 {
            self.scrollImage.setZoomScale(1.0, animated: true)
        } else {
            self.scrollImage.setZoomScale(self.scrollImage.maximumZoomScale, animated: true)
        }
    }
    
    func panGestureHandler(_ sender : UIPanGestureRecognizer) {
        if let txtFieldView = sender.view {
            let translatedPoint : CGPoint = sender.translation(in: self.scrollImage)
            if sender.state == .began {
                self.firstX = txtFieldView.center.x
                self.firstY = txtFieldView.center.y
            }
            let trandPoint : CGPoint = CGPoint.init(x: self.firstX + translatedPoint.x, y: self.firstY + translatedPoint.y)
            sender.view?.center = trandPoint
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
                
            case "showFilterVC":
                if let filterVC = segue.destination as? FilterVC {
                    filterVC.imageEditorDelegate = self
                    filterVC.originalImage = self.editedImage
                }
                
            case "showCropVC":
                if let cropVC = segue.destination as? CropVC {
                    cropVC.imageEditorDelegate = self
                    cropVC.originalImage = self.editedImage
                }
                
            default:
                break
            }
        }
    }
    
    @IBAction func onAddtext(_ sender: UIBarButtonItem) {
        self.scrollImage.setZoomScale(1, animated: true)
        self.txtAddText.isHidden = false
        self.scrollImage.isUserInteractionEnabled = false
        
    }
    
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        self.txtAddText.isHidden = true
        
        let image = self.editedImage.image
        self.editedImage = Image.init(image)
        self.imageView.image = self.editedImage.image
        
        if let image = self.editedImage?.image {
            self.completion?(image)
        } else {
            self.completion?(nil)
        }
        self.navigationController?.dismiss(animated: true, completion: {
            
        })
    
    }
    
    func setImage(_ image : UIImage) {
        self.imageView.image = image
        
        let width = image.size.width
        let height = image.size.height
        
        var widthImageView : CGFloat = 0
        var heightImageView : CGFloat = 0
        var position :CGPoint = .zero
        
        if width >= height {
            widthImageView = self.scrollImage.frame.size.width
            heightImageView = widthImageView * height / width
            position = CGPoint.init(x: 0, y: (self.scrollImage.frame.size.height / 2) - (heightImageView / 2))
        } else {
            heightImageView = self.scrollImage.frame.size.height
            widthImageView = heightImageView * width / height
            position = CGPoint.init(x: (self.scrollImage.frame.size.width / 2) - (widthImageView / 2), y: 0)
        }
        var frame = CGRect.init()
        frame.origin = position
        frame.size = CGSize.init(width: widthImageView, height: heightImageView)
        self.imageView.frame = frame
        self.scrollImage.contentSize = self.imageView.frame.size
        self.scrollImage.setZoomScale(1, animated: true)
    }
    
    func createARGBBitmapContext(inImage: CGImage) -> CGContext {
        var bitmapByteCount = 0
        var bitmapBytesPerRow = 0
        
        let pixelsWide = inImage.width
        let pixelsHigh = inImage.height
        
        bitmapBytesPerRow = Int(pixelsWide) * 4
        bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapData = malloc(bitmapByteCount)
        let bitmapInfo = CGBitmapInfo.init(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        let context = CGContext(data: bitmapData, width: pixelsWide, height: pixelsHigh, bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        return context!
    }
    
    func addText(img :UIImage, text :String) -> UIImage {
        
        let w = img.size.width
        let h = img.size.height
        
        let context = createARGBBitmapContext(inImage: img.cgImage!)
        context.draw(img.cgImage!, in: CGRect(x: 0, y: 0, width: w, height: h))
        
        context.setFillColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1)
        
        let path = CGMutablePath() //1
        path.addRect(CGRect(x: w - 90, y: 1, width: 100, height: 20))
        
        let attString = NSAttributedString(string: text) //2
        
        let framesetter = CTFramesetterCreateWithAttributedString(attString) //3
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attString.length), path, nil)
        
        CTFrameDraw(frame, context) //4
        
        let imageMasked:CGImage = context.makeImage()!
        
        return UIImage.init(cgImage: imageMasked)
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        self.completion?(nil)
        self.navigationController?.dismiss(animated: true, completion: {
            
        })
    }
    
    @IBAction func onReset(_ sender: UIBarButtonItem) {
        self.editedImage = self.originalImage
        self.imageView.image = self.originalImage.image
    }
    
    class func presentEditor(with image: UIImage, on vc: UIViewController, completion: @escaping ImageEditorCompletion) {
        let storyB = UIStoryboard.init(name: "ImageEditor", bundle: nil)
        if let nav = storyB.instantiateViewController(withIdentifier: "navImageEditor") as? UINavigationController {
            if let imageEditor = nav.viewControllers.first as? ImageEditorVC {
                imageEditor.originalImage = Image.init(image)
                imageEditor.completion = completion
                vc.present(nav, animated: true, completion: {
                    
                })
            }
        }
    }
    
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = self.txtAddText.textColor!
        let textFont = self.txtAddText.font!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [ NSFontAttributeName: textFont, NSForegroundColorAttributeName: textColor ] as [String : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.scrollImage.isUserInteractionEnabled = true
        textField.resignFirstResponder()
        return true
    }
    
}

extension ImageEditorVC : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}

extension ImageEditorVC : ImageEditorDelegate {
    func imageEdited(_ image: Image) {
        self.editedImage = image
        self.imageView.image = self.editedImage.image
    }
}

extension UIImage {
    
    func addText(_ drawText: NSString, atPoint: CGPoint, textColor: UIColor?, textFont: UIFont?) -> UIImage {
        
        // Setup the font specific variables
        var _textColor: UIColor
        if textColor == nil {
            _textColor = UIColor.white
        } else {
            _textColor = textColor!
        }
        
        var _textFont: UIFont
        if textFont == nil {
            _textFont = UIFont.systemFont(ofSize: 40)
        } else {
            _textFont = textFont!
        }
        
        // Setup the image context using the passed image
        UIGraphicsBeginImageContext(size)
        
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: _textFont,
            NSForegroundColorAttributeName: _textColor,
            ] as [String : Any]
        
        // Put the image into a rectangle as large as the original image
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // Create a point within the space that is as bit as the image
        let rect = CGRect(x: atPoint.x, y: atPoint.y, width: size.width, height: size.height)
        
        // Draw the text into an image
        drawText.draw(in: rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //Pass the image back up to the caller
        return newImage!
        
    }
    
}
