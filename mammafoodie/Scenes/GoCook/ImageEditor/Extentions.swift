//
//  Extentions.swift
//  MediaPicker
//
//  Created by Arjav Lad on 30/05/17.
//  Copyright © 2017 Aakar Solutions. All rights reserved.
//

import Foundation
import UIKit
import Photos

extension UIImage {
    
    func applyFilter(ciFilterName: String) -> UIImage? {
        let coreImage = CIImage(image:self)
        let ciContext = CIContext(options: nil)
        return coreImage?.applyFilter(ciFilterName: ciFilterName, ciContext: ciContext)
    }
    
    class func generateThumb(_ image: UIImage) -> UIImage? {
        let scale: CGFloat = 3.0
        var sizeMax = max(image.size.width, image.size.height) / scale as CGFloat
        let num  = CFNumberCreate(kCFAllocatorDefault, .cgFloatType, &sizeMax)
        if let imageSource = CGImageSourceCreateWithData(UIImagePNGRepresentation(image)! as CFData, nil) {
            let options: [NSString: NSObject] = [
                kCGImageSourceThumbnailMaxPixelSize: num!,
                kCGImageSourceShouldCache: true as NSObject,
                kCGImageSourceCreateThumbnailFromImageAlways: true as NSObject
            ]
            let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary).flatMap {
                UIImage.init(cgImage: $0)
            }
            return scaledImage
        }
        return nil
    }
}

extension CIImage {
    func applyFilter(ciFilterName: String, ciContext : CIContext) -> UIImage {
        let ciFilter = CIFilter(name: ciFilterName)
        ciFilter!.setDefaults()
        ciFilter!.setValue(self, forKey: kCIInputImageKey)
        let filteredImageData = ciFilter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        let imageEdit = UIImage.init(cgImage: filteredImageRef!)
        return imageEdit
    }
}

extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}
