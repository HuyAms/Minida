//
//  LeaderBoardPresenter.swift
//  Project_Ios
//
//  Created by iosdev on 28.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

protocol LeaderBoardPresenterProtocol {
    
    func getLeaderBoardUsers()
    
}

class LeaderBoardPresenter: LeaderBoardPresenterProtocol {

    var view: LeaderBoardVCProtocol?
    var userService: UserServiceProtocol = UserService()
    
    init(view: LeaderBoardVCProtocol) {
        self.view = view
    }
    
    func getLeaderBoardUsers() {
        view?.showLoading()
        userService.getLeaderBoardUsers { [weak self](response) in
            self?.view?.hideLoading()
            switch response {
            case .success(let users):
                self?.view?.onGetLeaderBoardUsersSuccess(users: users)
            case .error(let error):
                self?.view?.onShowError(error: error)
            }
        }
    }
    
}
