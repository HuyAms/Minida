//
//  AuthPresenter.swift
//  Project_Ios
//
//  Created by iosdev on 11.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

//LOGIC
protocol AuthPresenterProtocol {
    
    func performLogin(userName: String, password: String)
    
    func performRegister(userName: String, password: String, email: String, phoneNumber: String)
    
    func checkBiometricAuthAvailable()
    
    func performIdVerificaiton()
    
    func checkToken()
    
    func changeAccount()
    
}

class AuthPresenter: AuthPresenterProtocol {
    
    weak var view: AuthViewProtocol? 
    var authService: AuthServiceProtocol = AuthService()
    var touchIdService: TouchIdServiceProtocol = TouchIdService()
    

    init(view: AuthViewProtocol) {
        self.view = view
    }
    
    func checkBiometricAuthAvailable() {
        let biometricAuthAvailable = touchIdService.canEvaluatePolicy()
        if biometricAuthAvailable && KeyChainUtil.share.hasToken() {
            view?.showIdBtn()
            switch touchIdService.biometricType() {
            case .faceID:
                view?.setIdBtnAsFaceId()
            default:
                view?.setIdBtnAsTouchId()
            }
        } else {
            view?.hideIdBtn()
        }
    }
    
    func performIdVerificaiton() {
        touchIdService.authenticateUser { [weak self] (message) in
            if let message = message {
                self?.view?.onVerifyIdError(error: message)
            } else {
                self?.view?.onVerifyIdSuccess()
                KeyChainUtil.share.setLogInSate()
            }
        }
    }
    
    func performLogin(userName: String, password: String) {
        view?.showLoading()
        
        if userName.isEmpty || password.isEmpty {
            view?.onShowError(error: .emptyField)
            view?.hideLoading()
        } else {
            //perform login here
            authService.login(username: userName, password: password, completion: { [weak self] response in
                switch response {
                case .success(let token):
                    //Save the token in keychain
                    KeyChainUtil.share.setToken(token: token)
                    KeyChainUtil.share.setLogInSate()
                    KeyChainUtil.share.setUserName(username: userName)
                    self?.view?.onSuccess()
                    self?.view?.hideLoading()
                case .error(let error):
                    self?.view?.onShowError(error: error)
                    self?.view?.hideLoading() //put self here is not the right way
                }
            })
            
        }
    }
    
    
    func performRegister(userName: String, password: String, email: String, phoneNumber: String) {
        view?.showLoading()
        
        if userName.isEmpty || password.isEmpty || email.isEmpty || phoneNumber.isEmpty {
            view?.onShowError(error: .emptyField)
            view?.hideLoading()
        } else {
            authService.register(username: userName, password: password, email: email, phoneNumber: phoneNumber, completion: { [weak self] response in
                switch response {
                case .success(let token):
                    //Save the token in defaultUsers
                    KeyChainUtil.share.setToken(token: token)
                    KeyChainUtil.share.setLogInSate()
                    KeyChainUtil.share.setUserName(username: userName)
                    self?.view?.onSuccess()
                    self?.view?.hideLoading()
                case .error(let error):
                    self?.view?.onShowError(error: error)
                    self?.view?.hideLoading() 
                }
            })
        }
    }
    
    func checkToken() {
        if KeyChainUtil.share.hasToken() {
            guard let userName = KeyChainUtil.share.getUserName() else { return }
            self.view?.setUserName(userName: userName)
            view?.showChangeAccountBtn()
        } else {
            view?.hideChangeAccountBtn()
        }
    }
    
    func changeAccount() {
        KeyChainUtil.share.removeToken()
        self.view?.onChangeAccountSuccess()
        view?.hideChangeAccountBtn()
    }
    
}
