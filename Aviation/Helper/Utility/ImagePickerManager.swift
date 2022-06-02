//
//  ImagePickerManager.swift
//  Aviation
//
//  Created by Mac on 11/12/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import Foundation
import UIKit
import Photos
import CropViewController
import WXImageCompress

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
    
    override init(){
        super.init()
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.cameraAuthorization()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        alert.view.tintColor = UIColor.appColor
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
    }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;
        
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        
        viewController.present(alert, animated: true, completion: nil)
    }
    func cameraAuthorization(){
        
        self.alert.dismiss(animated: true, completion: nil)
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch (authStatus){
        
        case .restricted, .denied:
            self.showPermisionAlert(type:"Camera")
            
        case .authorized:
            self.cameraOpen()
        case .notDetermined:
            print("notDetermined")
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //access allowed
                    self.cameraOpen()
                } else {
                    //access denied
                    self.cameraAuthorization()
                }
            })
            
        @unknown default:
            print("notDetermined")
        }
        
    }
    
    func cameraOpen(){
        DispatchQueue.main.async {
            self.alert.dismiss(animated: true, completion: nil)
            if(UIImagePickerController .isSourceTypeAvailable(.camera)){
                self.picker.sourceType = .camera
                self.picker.allowsEditing = false
                //to stop parent viewcontroller dismiss
                self.viewController!.definesPresentationContext = true
                self.picker.modalPresentationStyle = .overFullScreen
                self.viewController!.present(self.picker, animated: true, completion: nil)
            } else {
                showAlertWithTitleFromVC(vc: self.viewController!, andMessage: "You don't have camera")
            }
        }
    }
    
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        
        PHPhotoLibrary.requestAuthorization { [weak self] result in
            guard let self = self else { return }
            if result == .authorized {
                DispatchQueue.main.async {
                    self.picker.sourceType = .photoLibrary
                    self.picker.allowsEditing = false
                    //to stop parent viewcontroller dismiss
                    self.viewController!.present(self.picker, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.showPermisionAlert(type:"photo gallery")
                }
            }
        }
    }
    
    func showPermisionAlert(type:String) {
        
        alert = UIAlertController(title: Constant.APP_NAME, message: "Please allow your " + type, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        
        alert.addAction(settingsAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.viewController?.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage:UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let cropController:CropViewController = CropViewController(image: chosenImage)
            cropController.delegate = self
            cropController.aspectRatioPreset = .presetSquare
            cropController.aspectRatioLockEnabled = true
            cropController.aspectRatioPickerButtonHidden = true
            
            if #available(iOS 13.0, *) {
                cropController.modalPresentationStyle = .fullScreen
            }
            
            self.viewController?.present(cropController, animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }
    
}

extension ImagePickerManager : CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int)
    {
        
        cropViewController.dismiss(animated: true, completion:
                                    {
                                        self.pickImageCallback?(image.wxCompress())
                                    })
    }
}
