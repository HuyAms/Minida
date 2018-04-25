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

class EditProfileVC: UIViewController, EditProfileViewProtocol {
    
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
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = EditProfilePresenter(view: self)
        presenter?.loadUserInfo()
        // Do any additional setup after loading the view.
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
