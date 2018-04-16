//
//  ProfilePresenter.swift
//  Project_Ios
//
//  Created by iosadmin on 16.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

//LOGIC
protocol ProfilePresenterProtocol {
    
    func logout()
    
}

class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewProtocol?
    
    init(view: ProfileViewProtocol) {
        self.view = view
    }
    
    func logout() {
        KeyChainUtil.share.setLogOut()
        view?.onLogoutSuccess()
    }
    
    
}
