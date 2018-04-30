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
    
    func updateUser(username: String, phoneNumber: String, avatarPath: String?, email: String)
    
    func upLoadPicture(imgData: Data?)

}

class EditProfilePresenter: EditProfilePresenterProtocol {


    weak var view: EditProfileViewProtocol?
    var userService: UserServiceProtocol = UserService()
    var profileService: ProfileServiceProtocol = ProfileService()
    let uploadImgService: UpLoadImgServiceProtocol = UploadImgService()

    
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
    
    func updateUser(username: String, phoneNumber: String, avatarPath: String?, email: String) {
        
        if username.isEmpty  || email.isEmpty || phoneNumber.isEmpty {
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
        profileService.updateProfileData(token: token, username: username, email: email, phoneNumber: phoneNumber, avatarPath: avatarPath) { (response) in
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
    
    func upLoadPicture(imgData: Data?) {
        guard let token = KeyChainUtil.share.getToken() else {
            print("Empty token")
            return
        }
        
        guard let imgData = imgData  else {
            view?.onShowError(error: .emptyImage)
            return
        }
        
        view?.showLoading()
        uploadImgService.uploadImg(token: token, imgData: imgData) { [weak self](response) in
            self?.view?.hideLoading()
            switch response {
            case .success(let upLoadResponse):
                let imgPath = "\(URLConst.BASE_URL)/photos/\(upLoadResponse.filename)"
                self?.view?.onUploadImageSuccess(newAvatarPath: imgPath)
            case .error(let error):
                self?.view?.onShowError(error: error)
            }
        }
    }
    
    

}
