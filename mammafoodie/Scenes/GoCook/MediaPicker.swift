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
typealias MediaPickerVideoCompletion = (String?, Error?) -> Void

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
    
    class func pickImage(on vc : UIViewController, completion :@escaping MediaPickerImageCompletion) {
        let mediaPick = MediaPicker()
        mediaPick.imageCompletion = completion
        mediaPick.mediaType = .Image
        mediaPick.checkCameraPermission { (error) in
            if error != nil {
                mediaPick.imageCompletion?(nil, error)
            } else {
                mediaPick.showImagePicker(on: vc, sourceType: .camera)
            }
        }
    }
    
    class func pickVideo(on vc : UIViewController, completion :@escaping MediaPickerVideoCompletion) {
        let mediaPick = MediaPicker()
        mediaPick.videoCompletion = completion
        mediaPick.mediaType = .Video
        mediaPick.imagePicker.delegate = mediaPick
        mediaPick.imagePicker.sourceType = .photoLibrary
        mediaPick.imagePicker.mediaTypes = [mediaPick.mediaType.type]
        vc.navigationController?.present(mediaPick.imagePicker, animated: true) {
            
        }
        return
        mediaPick.checkPhotoLibraryPermission { (error) in
            if error != nil {
                mediaPick.videoCompletion?(nil, error)
            } else {
                DispatchQueue.main.async {
                    mediaPick.showImagePicker(on: vc, sourceType: .photoLibrary)
                }
            }
        }
        mediaPick.checkCameraPermission { (error) in
            if error != nil {
                mediaPick.videoCompletion?(nil, error)
            } else {
                DispatchQueue.main.async {
                    mediaPick.showImagePicker(on: vc, sourceType: .camera)
                }
            }
        }
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
    
}

extension MediaPicker : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true) {
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.imagePicker.dismiss(animated: true) {
            
        }
    }
}
