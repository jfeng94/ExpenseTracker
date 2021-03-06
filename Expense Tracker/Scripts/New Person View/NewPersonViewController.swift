//
//  NewPersonViewController.swift
//  Cleaver
//
//  Created by Jerry Feng on 9/27/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit
import RSKImageCropperSwift

class NewPersonViewController: UIViewController, RSKImageCropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let kPhotoDiameter = CGFloat(130.0)
    let kPhotoFrameViewPadding = CGFloat(2.0)
    
    var photoFrameView = UIView()
    var addPhotoButton = UIButton()
    var name = UITextField()
    var saveButton: UIBarButtonItem?
    var cancelButton: UIBarButtonItem?
    var didSetupConstraints = false
    
    var orientation = UIImageOrientation.up
    var croppedImage: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        // ---------------------------
        // Save Button set up
        // ---------------------------
        saveButton = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(self.save))
        self.navigationItem.rightBarButtonItem = saveButton
        
        // ---------------------------
        // Cancel Button set up
        // ---------------------------
        cancelButton = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
        
        croppedImage = UIImage(named: "Void User")
        
        // ---------------------------
        // Add the frame of the photo.
        // ---------------------------
        photoFrameView.backgroundColor = UIColor(red: 182/255.0, green: 182/255.0, blue: 187/255.0, alpha: 1.0)
        photoFrameView.translatesAutoresizingMaskIntoConstraints = false
        photoFrameView.layer.masksToBounds = true
        photoFrameView.layer.cornerRadius = (kPhotoDiameter + kPhotoFrameViewPadding) / 2
        view.addSubview(photoFrameView)
        
        // ---------------------------
        // Add the button "add photo".
        // ---------------------------
        
        addPhotoButton.backgroundColor = UIColor.white
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.layer.masksToBounds = true
        addPhotoButton.layer.cornerRadius = kPhotoDiameter / 2
        addPhotoButton.imageView?.contentMode = .scaleAspectFit
        addPhotoButton.titleLabel?.lineBreakMode = .byWordWrapping
        addPhotoButton.titleLabel?.textAlignment = .center
        addPhotoButton.setTitle("add\nphoto", for: .normal)
        addPhotoButton.setTitleColor(UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0), for: .normal)
        addPhotoButton.addTarget(self, action: #selector(onAddPhotoButtonTouch), for: .touchUpInside)
        view.addSubview(addPhotoButton)
        
        // ---------------------------
        // Name Field
        // ---------------------------
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textAlignment = .center
        name.borderStyle = .none
        name.placeholder = "Name"
        name.font = name.font?.withSize(27)
        view.addSubview(name)
        
        // ---------------------------
        //
        // ---------------------------
        
        
        // ----------------
        // Add constraints.
        // ----------------
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        if didSetupConstraints {
            return
        }
        
        // ---------------------------
        // The frame of the photo.
        // ---------------------------
        
        var constraint = NSLayoutConstraint(
            item: photoFrameView,
            attribute:.width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: (kPhotoDiameter + kPhotoFrameViewPadding))
        
        photoFrameView.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(
            item: photoFrameView,
            attribute:.height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant:(kPhotoDiameter + kPhotoFrameViewPadding))
        
        photoFrameView.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(
            item: photoFrameView,
            attribute:.centerX,
            relatedBy:.equal,
            toItem: view,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0.0)
        
        view.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(
            item: photoFrameView,
            attribute:.top,
            relatedBy:.equal,
            toItem: view,
            attribute: .top,
            multiplier: 1.0,
            constant: 16.0)
        
        view.addConstraint(constraint)
        
        // ---------------------------
        // The button "add photo".
        // ---------------------------
        
        constraint = NSLayoutConstraint(
            item: addPhotoButton,
            attribute:.width,
            relatedBy:.equal,
            toItem: nil,
            attribute:
            .notAnAttribute,
            multiplier: 1.0,
            constant: kPhotoDiameter)
        
        addPhotoButton.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(
            item: self.addPhotoButton,
            attribute:.height,
            relatedBy:.equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant:kPhotoDiameter)
        
        addPhotoButton.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(
            item: self.addPhotoButton,
            attribute:.centerX,
            relatedBy:.equal,
            toItem: photoFrameView,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0.0)
        
        view.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(
            item: self.addPhotoButton,
            attribute:.centerY,
            relatedBy:.equal,
            toItem: photoFrameView,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0.0)
        
        view.addConstraint(constraint)
        
        //////
        
        constraint = NSLayoutConstraint(
            item: name,
            attribute:.top,
            relatedBy:.equal,
            toItem: addPhotoButton,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 16.0)
        
        view.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(
            item: name,
            attribute:.leading,
            relatedBy:.equal,
            toItem: view,
            attribute: .leading,
            multiplier: 1.0,
            constant: 16.0)
        
        view.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(
            item: name,
            attribute:.trailing,
            relatedBy:.equal,
            toItem: view,
            attribute: .trailing,
            multiplier: 1.0,
            constant: -16.0)
        
        view.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(
            item: name,
            attribute:.centerX,
            relatedBy:.equal,
            toItem: view,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0.0)
        
        view.addConstraint(constraint)
        
        didSetupConstraints = true
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Action handling
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    @objc func onAddPhotoButtonTouch(sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate   = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func cancel(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func save(sender: UIBarButtonItem) {
        let newPersonID = PersonManager.instance.CreateNewPerson()
        PersonManager.instance.SetName(ID: newPersonID, name: name.text!)
        PersonManager.instance.SetPhoto(ID: newPersonID, photo: croppedImage)
        dismiss(animated: true, completion: nil)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: UIImagePickerDelegate methods
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
        orientation = selectedImage.imageOrientation
        
        let photo = selectedImage
        let imageCropVC = RSKImageCropViewController(image: photo, cropMode: .circle)
        imageCropVC.delegate = self
        navigationController?.pushViewController(imageCropVC, animated: true)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - RSKImageCropViewControllerDelegate
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func didCancelCrop() {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func didCropImage(_ croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        addPhotoButton.setImage(croppedImage, for: .normal)
        self.croppedImage = croppedImage
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func didCropImage(_ croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        let rotated : UIImage
        switch (orientation) {
        case .up:
            print("case is up. Did nothing")
            rotated = croppedImage
        case .right:
            rotated = croppedImage.rotate(radians: Float.pi / 2)!
        case.down:
            rotated = croppedImage.rotate(radians: Float.pi)!
        case.left:
            rotated = croppedImage.rotate(radians: 3 * Float.pi / 2)!
        
        default:
            rotated = croppedImage
            print("Case not handled")
        
        }
        addPhotoButton.setImage(rotated, for: .normal)
        self.croppedImage = rotated
        let _ = navigationController?.popViewController(animated: true)
    }
    
    /**
     Tells the delegate that the original image will be cropped.
     */
    public func willCropImage(_ originalImage: UIImage) {
        
    }
}
