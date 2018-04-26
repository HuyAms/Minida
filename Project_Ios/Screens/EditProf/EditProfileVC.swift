//
//  EditProfileVC.swift
//  Project_Ios
//
//  Created by iosadmin on 25.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit
import Foundation

protocol EditProfileViewProtocol: class {
    
    func onLoadDataSuccess(userData: User)
    
    func onShowError(error: AppError)
    
    func onUpdateUserSuccess(userData: User)
    
    func showLoading()
    
    func hideLoading()
    
}

class EditProfileVC: UIViewController, EditProfileViewProtocol{
    
    //MARK: Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var changeProfilePictureButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var avatarImage: UIImageView!
    
    var avatarPath: String?
    
    
    //MARK: Properties
    var presenter: EditProfilePresenterProtocol?
    var image: UIImage?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = EditProfilePresenter(view: self)
        presenter?.loadUserInfo()
        // Do any additional setup after loading the view.
        
        //Add tap gesture to avatarImage -> when tapped -> user choose img
        let avatarTapGesture = UITapGestureRecognizer(target: self
            , action: #selector(EditProfileVC.imageTap(_:)))
        avatarImage.addGestureRecognizer(avatarTapGesture)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: UIImagePickerView functions
    @objc func imageTap(_ sender: UITapGestureRecognizer) {
        print("Image was tapped")
        // Show options for the source picker only if the camera is available.
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .camera)
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        photoSourcePicker.addAction(takePhoto)
        photoSourcePicker.addAction(choosePhoto)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(photoSourcePicker, animated: true)
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }

    
    
    //MARK: Protocols
    func onLoadDataSuccess(userData: User) {
        avatarPath = userData.avatarPath
        updateUI(userData: userData)
    }
    
    func onUpdateUserSuccess(userData: User) {
        avatarPath = userData.avatarPath
        updateUI(userData: userData)
        dismiss(animated: true, completion: nil)
    }
    
    func updateUI(userData: User) {
        nameTextField.text = userData.username
        emailTextField.text = userData.email
        
        if let phoneNumber = userData.phoneNumber {
            phoneTextField.text = String(phoneNumber)
        }
        
        if let avatarIcon = userData.avatarPath {
            avatarImage.load(imgUrl: avatarIcon)
        }
    }
    
    func onShowError(error: AppError) {
        showError(message: error.description)
    }
    
    func showLoading() {
        showLoadingIndicator()
    }
    
    func hideLoading() {
        hideLoadingIndicator()
    }
    
    //MARK: Actions
    
    @IBAction func saveBtnWasPressed(_ sender: Any) {
        let username = nameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let phoneNumber = phoneTextField.text ?? ""
        let avatarPath = self.avatarPath
        let email = emailTextField.text ?? ""
        presenter?.updateUser(username: username, password: password, phoneNumber: phoneNumber, avatarPath: avatarPath, email: email)
    }
    
    @IBAction func cancelBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Handling Image Picker Selection

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        picker.dismiss(animated: true)
        
        // We always expect 'imagePickerController(:didFinishPickingMediaWithInfo:)' to supply the original image.
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        avatarImage.image = image
        
        //updateClassifications(for: image!)
    }
}

