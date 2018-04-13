//
//  MapPresenter.swift
//  Project_Ios
//
//  Created by iosdev on 11.4.2018.
//  Copyright © 2018 iosdev. All rights reserved.
//

import Foundation

protocol ProfilePresenterProtocol {
    
    func loadUserInfo()
    func loadMyItems()
    
}

class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewProtocol?
    var profileService: ProfileServiceProtocol = ProfileService()
    
    init(view: ProfileViewProtocol) {
        self.view = view
    }
    
    func loadUserInfo() {
        view?.showLoading()
        let token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1YWNmNTJjMDAyYTM5MTAwMTQzNWE3MGIiLCJpYXQiOjE1MjM1MzY1NzYsImV4cCI6MTUyNDQwMDU3Nn0.939iNbNAhqt_ZtZPQT1CrV6roeSn-0Mwpm3LYuG5QLU"
        profileService.loadProfileData(token: token) { (response) in
            print("RES: \(response)")
            switch response{
            case.success(let user):
                self.view?.hideLoading()
                self.view?.onLoadDataSuccess(userData: user)
            case .error(let error):
                self.view?.hideLoading()
                self.view?.onLoadDataError(error: error)
            }
        }
    }
    
    func loadMyItems() {
        view?.showLoading()
        let token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1YWNmNTJjMDAyYTM5MTAwMTQzNWE3MGIiLCJpYXQiOjE1MjM1MzY1NzYsImV4cCI6MTUyNDQwMDU3Nn0.939iNbNAhqt_ZtZPQT1CrV6roeSn-0Mwpm3LYuG5QLU"
        profileService.loadMyItems(token: token) { (response) in
            print("RES: \(response)")
            switch response{
            case.success(let myItems):
                self.view?.hideLoading()
                self.view?.onGetMyItemSuccess(myItems: myItems)
                
                let numberOfRecycles = myItems.count
                switch numberOfRecycles {
                case 0..<4:
                    self.view?.setRank(rank: Rank.beginner)
                default:
                    self.view?.setRank(rank: Rank.pro)
                }
                
            case .error(let error):
                self.view?.hideLoading()
                self.view?.onGetMyItemError(error: error)
            }
        }
    }
    
    
}

