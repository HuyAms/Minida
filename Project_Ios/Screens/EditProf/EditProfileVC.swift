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
    
    func onUploadImageSuccess(newAvatarPath: String)
    
}

class EditProfileVC: UIViewController, EditProfileViewProtocol{
    
    //MARK: Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    var avatarPath: String?
    
    //MARK: Properties
    var presenter: EditProfilePresenterProtocol?
    var changedAvatar: UIImage?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter = EditProfilePresenter(view: self)
        presenter?.loadUserInfo()
      
        let avatarTapGesture = UITapGestureRecognizer(target: self
            , action: #selector(EditProfileVC.imageTap(_:)))
        avatarImage.addGestureRecognizer(avatarTapGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditProfileVC.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: UIImagePickerView functions
    @objc func imageTap(_ sender: UITapGestureRecognizer) {
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
            phoneTextField.text = "0" + String(phoneNumber)
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
    
    func onUploadImageSuccess(newAvatarPath: String) {
        let username = nameTextField.text ?? ""
        let phoneNumber = phoneTextField.text ?? ""
        let email = emailTextField.text ?? ""
        presenter?.updateUser(username: username, phoneNumber: phoneNumber, avatarPath: newAvatarPath, email: email)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupUI() {
        titleLbl.text = "Edit Profile".localized
        nameLbl.text = "Name".localized
        emailLbl.text = "Email".localized
        phoneLbl.text = "Phone Number".localized
        nameTextField.placeholder = "Edit Name".localized
        emailTextField.placeholder = "Edit Email".localized
        phoneTextField.placeholder = "Edit Phone".localized
    }
    
    //MARK: Actions
    
    @IBAction func saveBtnWasPressed(_ sender: Any) {
        
        
        if let changedAvatar = self.changedAvatar {
            // When user changes their avatar, upload new avatar and get new avatarPath and upload it, after save new user info.
            let imageData = UIImageJPEGRepresentation(changedAvatar, 1.0)!
            
            presenter?.upLoadPicture(imgData: imageData)
            
        } else {
            // User has not changed their avatar, we do not need to upload new picture. Save user info with old avatar path.
            let avatarPath = self.avatarPath
            let username = nameTextField.text ?? ""
            let phoneNumber = phoneTextField.text ?? ""
            let email = emailTextField.text ?? ""
            presenter?.updateUser(username: username, phoneNumber: phoneNumber, avatarPath: avatarPath, email: email)
        }
    }
    
    
    @IBAction func cancelBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        picker.dismiss(animated: true)

        changedAvatar = info[UIImagePickerControllerOriginalImage] as? UIImage
        avatarImage.image = changedAvatar
    }
}

