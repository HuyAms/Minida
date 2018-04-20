//
//  ProfilePresenter.swift
//  Project_Ios
//
//  Created by iosadmin on 16.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

protocol ProfilePresenterProtocol {
    
    func logout()
    
    func performGetUserById(token: String)
}

class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewProtocol?
    var userService: UserServiceProtocol = UserService()
    
    init(view: ProfileViewProtocol) {
        self.view = view
    }
    
    func logout() {
        KeyChainUtil.share.setLogOut()
        view?.onLogoutSuccess()
    }
    
    func performGetUserById(token: String) {
        
    }
}
