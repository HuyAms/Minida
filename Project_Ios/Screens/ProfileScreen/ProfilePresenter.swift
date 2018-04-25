//
//  ProfilePresenter.swift
//  Project_Ios
//
//  Created by iosadmin on 16.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

protocol ProfilePresenterProtocol {
    
    func loadUserInfo()
    
    func loadMyItems()
    
    func logout()
    
    func performLoadBought()
    
    func performLoadSold()
    
    func performGetUserById(token: String)
}

class ProfilePresenter: ProfilePresenterProtocol {
   
    
    weak var view: ProfileViewProtocol?
    var userService: UserServiceProtocol = UserService()
    var profileService: ProfileServiceProtocol = ProfileService()
    var orderService: OrderServiceProtocol = OrderService()
    
    init(view: ProfileViewProtocol) {
        self.view = view
    }
    
    func logout() {
        KeyChainUtil.share.setLogOut()
        view?.onLogoutSuccess()
    }
    
    func performGetUserById(token: String) {
        
    }
    
    func loadUserInfo() {
        view?.showLoading()
        guard let token = KeyChainUtil.share.getToken() else {return}
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
        guard let token = KeyChainUtil.share.getToken() else {return}
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
                case 5..<11:
                    self.view?.setRank(rank: Rank.intermediate)
                default:
                    self.view?.setRank(rank: Rank.pro)
                }
                
            case .error(let error):
                self.view?.hideLoading()
                self.view?.onGetMyItemError(error: error)
            }
        }
    }
    
    func performLoadBought() {
        view?.showLoading()
        guard let token = KeyChainUtil.share.getToken() else {return}
        orderService.getItemsBoughtByMe(token: token) { [weak self] response in
            switch response {
            case .success(let orderDetail):
                self?.view?.hideLoading()
                self?.view?.onGetBoughtItemsSuccess(orderDetails: orderDetail)
            case .error(let error):
                self?.view?.hideLoading()
                self?.view?.onGetMyItemError(error: error)
            }
            
        }
    }
    
    func performLoadSold() {
        view?.showLoading()
        guard let token = KeyChainUtil.share.getToken() else {return}
        orderService.getItemsSoldByMe(token: token) { [weak self] response in
            switch response {
            case .success(let orderDetail):
                self?.view?.hideLoading()
                self?.view?.onGetSoldItemsSuccess(orderDetails: orderDetail)
            case .error(let error):
                self?.view?.hideLoading()
                self?.view?.onGetMyItemError(error: error)
            }
            
        }
    }
    
}
