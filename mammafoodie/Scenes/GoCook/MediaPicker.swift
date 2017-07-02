//
//  MediaPicker.swift
//  mammafoodie
//
//  Created by Arjav Lad on 19/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import MobileCoreServices

typealias MediaPickerImageCompletion = (UIImage?, Error?) -> Void
typealias MediaPickerVideoCompletion = (URL?, Error?) -> Void

enum MediaType {
    case Video
    case Image
    
    var type : String {
        switch self {
        case .Video:
            return kUTTypeMovie as String
        case .Image:
            return kUTTypeImage as String
        }
    }
}

class MediaPicker: NSObject {
    fileprivate var mediaType : MediaType = .Image
    fileprivate let imagePicker = UIImagePickerController.init()
    
    fileprivate var imageCompletion : MediaPickerImageCompletion?
    fileprivate var videoCompletion : MediaPickerVideoCompletion?
    
    class func pickImage(on vc : UIViewController, completion :@escaping MediaPickerImageCompletion) -> MediaPicker {
        let mediaPick = MediaPicker()
        mediaPick.imageCompletion = completion
        mediaPick.mediaType = .Image
        mediaPick.imagePicker.delegate = mediaPick
        mediaPick.imagePicker.allowsEditing = true
        
        let alertSource = UIAlertController.init(title: "Choose Image From", message: "", preferredStyle: .alert)
        alertSource.addAction(UIAlertAction.init(title: "Camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                mediaPick.showImagePicker(on: vc, sourceType: .camera)
            } else {
                mediaPick.showImagePicker(on: vc, sourceType: .photoLibrary)
            }
        }))
        
        alertSource.addAction(UIAlertAction.init(title: "Photo Library", style: .default, handler: { (action) in
            mediaPick.showImagePicker(on: vc, sourceType: .photoLibrary)
        }))
        
        vc.present(alertSource, animated: true) {
            
        }
        return mediaPick
    }
    
    class func recordVideo(on vc : UIViewController, completion :@escaping MediaPickerVideoCompletion) -> MediaPicker {
        let mediaPick = MediaPicker()
        mediaPick.videoCompletion = completion
        mediaPick.mediaType = .Video
        mediaPick.imagePicker.delegate = mediaPick
        mediaPick.imagePicker.mediaTypes = [mediaPick.mediaType.type]
        mediaPick.imagePicker.allowsEditing = true
        mediaPick.imagePicker.videoMaximumDuration = 60
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            mediaPick.showImagePicker(on: vc, sourceType: .camera)
        } else {
            mediaPick.showImagePicker(on: vc, sourceType: .photoLibrary)
        }
        return mediaPick
    }
    
    class func pickVideo(on vc : UIViewController, completion :@escaping MediaPickerVideoCompletion) -> MediaPicker {
        let mediaPick = MediaPicker()
        mediaPick.videoCompletion = completion
        mediaPick.mediaType = .Video
        mediaPick.imagePicker.delegate = mediaPick
        mediaPick.imagePicker.sourceType = .photoLibrary
        mediaPick.imagePicker.mediaTypes = [mediaPick.mediaType.type]
        mediaPick.imagePicker.allowsEditing = true
        mediaPick.imagePicker.videoMaximumDuration = 60
        mediaPick.showImagePicker(on: vc, sourceType: .photoLibrary)
        return mediaPick
    }
    
    fileprivate func showImagePicker(on vc: UIViewController, sourceType: UIImagePickerControllerSourceType) {
        self.imagePicker.sourceType = sourceType
        self.imagePicker.mediaTypes = [self.mediaType.type]
        vc.present(self.imagePicker, animated: true) {
            
        }
    }
    
    fileprivate func checkCameraPermission(_ completion: @escaping (Error?) -> Void) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.askPhotoLibraryPermission({ (status, error) in
                completion(error)
            })
        } else {
            completion(NSError.init(domain: "Device does not support Camera", code: 404, userInfo: nil))
        }
    }
    
    fileprivate func checkPhotoLibraryPermission(_ completion: @escaping (Error?) -> Void ) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            switch PHPhotoLibrary.authorizationStatus() {
            case .authorized:
                completion(nil)
                
            case .denied, .restricted:
                completion(NSError.init(domain: "Photo Library Access Denied", code: 500, userInfo: nil))
                
            case .notDetermined:
                self.askPhotoLibraryPermission({ (status, error) in
                    completion(error)
                })
            }
        } else {
            completion(NSError.init(domain: "Device does not support Photo Library", code: 404, userInfo: nil))
        }
    }
    
    fileprivate func askPhotoLibraryPermission(_ completion: @escaping (PHAuthorizationStatus, Error?) -> Void) {
        PHPhotoLibrary.requestAuthorization() { status in
            switch status {
            case .authorized:
                completion(status, nil)
                
            case .denied, .restricted:
                completion(status, NSError.init(domain: "Photo Library Access Denied", code: 500, userInfo: nil))
                
            case .notDetermined:
                completion(status, NSError.init(domain: "Photo Library Access Denied", code: 500, userInfo: nil))
                
            }
        }
    }
    
    fileprivate func askCameraPermission(_ completion: @escaping (AVAuthorizationStatus, Error?) -> Void) {
        func showDefaultMicrophonePermission(){
            AVAudioSession.sharedInstance().requestRecordPermission { result in
                if result == true {
                    print("Access Allowed")
                }else{
                    print("Access Denied")
                }
            }
        }
        showDefaultMicrophonePermission()
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch  status {
        case .authorized:
            completion(status, nil)
            
        case .denied, .restricted:
            completion(status, NSError.init(domain: "Camera Access Denied", code: 500, userInfo: nil))
            
        case .notDetermined:
            completion(status, NSError.init(domain: "Camera Access Denied", code: 500, userInfo: nil))
            
        }
    }
    
    class func createThumbnailOfVideoFromFileURL(_ videoURL: URL) -> UIImage? {
        
        let asset = AVAsset(url: videoURL)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(Float64(1), 100)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

extension MediaPicker : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if let completion = self.imageCompletion {
            completion(nil, nil)
        }
        
        if let completion = self.videoCompletion {
            completion(nil, nil)
        }
        
        self.imagePicker.dismiss(animated: true) {
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if self.mediaType == .Video {
            if let videoURL =  info[UIImagePickerControllerMediaURL] as? URL {
                self.videoCompletion?(videoURL, nil)
            } else {
                self.videoCompletion?(nil, NSError.init(domain: "No Video Found", code: 404, userInfo: nil))
            }
        } else {
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                self.imageCompletion?(image, nil)
            } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.imageCompletion?(image, nil)
            } else {
                self.imageCompletion?(nil, NSError.init(domain: "Image not found", code: 404, userInfo: nil))
            }
        }
        self.imagePicker.dismiss(animated: true) {
            
        }
    }
}
