//
//  EditProfilePresenter.swift
//  Project_Ios
//
//  Created by iosadmin on 25.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

protocol EditProfilePresenterProtocol {
    
    func loadUserInfo()
    
    func performGetUserById()
    
    func updateUser(username: String, password: String, phoneNumber: String, avatarPath: String?, email: String)
}

class EditProfilePresenter: EditProfilePresenterProtocol {


    weak var view: EditProfileViewProtocol?
    var userService: UserServiceProtocol = UserService()
    var profileService: ProfileServiceProtocol = ProfileService()
    
    init(view: EditProfileViewProtocol) {
        self.view = view
    }
    
    func loadUserInfo() {
        view?.showLoading()
        guard let token = KeyChainUtil.share.getToken() else {return}
        profileService.loadProfileData(token: token) { (response) in
            switch response{
            case.success(let user):
                self.view?.hideLoading()
                self.view?.onLoadDataSuccess(userData: user)
            case .error(let error):
                self.view?.hideLoading()
                self.view?.onShowError(error: error)
            }
        }
    }
    
    func updateUser(username: String, password: String, phoneNumber: String, avatarPath: String?, email: String) {
        
        if username.isEmpty || password.isEmpty || email.isEmpty || phoneNumber.isEmpty {
            self.view?.hideLoading()
            self.view?.onShowError(error: AppError.emptyField)
            return
        }
        
        guard let phoneNumber = Int(phoneNumber) else {
            self.view?.hideLoading()
            self.view?.onShowError(error: AppError.invalidPhoneNumber)
            return
            
        }

        guard let token = KeyChainUtil.share.getToken() else {return}
        profileService.updateProfileData(token: token, username: username, email: email, phoneNumber: phoneNumber, avatarPath: avatarPath, password: password) { (response) in
            switch response{
            case.success(let user):
                self.view?.hideLoading()
                self.view?.onUpdateUserSuccess(userData: user)
            case.error(let error):
                self.view?.hideLoading()
                self.view?.onShowError(error: error)
            }
        }
    }
    
    func performGetUserById() {
        
    }
    

}
