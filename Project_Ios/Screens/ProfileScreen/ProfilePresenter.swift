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
    
    func loadUserInfo(userId: String)
    
    func loadMyItems()
    
    func loadUserItems(userId: String)
    
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
    var itemService: ItemServiceProtocol = ItemService()
    
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
        self.view?.setUpLoadMyProfile()
        guard let token = KeyChainUtil.share.getToken() else {return}
        profileService.loadProfileData(token: token) {[weak self] (response) in
            self?.view?.hideLoading()
            switch response {
            case.success(let user):
                self?.view?.onLoadDataSuccess(userData: user)
            case .error(let error):
                self?.view?.onLoadDataError(error: error)
            }
        }
    }
    func loadUserItems(userId: String) {
         view?.showLoading()
        itemService.getItemsByUserId(id: userId) {  [weak self] (response) in
            self?.view?.hideLoading()
            switch response{
            case.success(let items):
                if items.count > 0 {
                    self?.view?.hideNoItemLabel()
                    self?.view?.showCollectionView()
                    self?.view?.onGetMyItemSuccess(items: items)
                } else {
                    self?.view?.hideCollectionView()
                    self?.view?.showNoItemLabel(message: "This user has no items on sale")
                }
            case .error(let error):
                self?.view?.onGetMyItemError(error: error)
            }
        }
    }
    
    
    func loadMyItems() {
        view?.showLoading()
        guard let token = KeyChainUtil.share.getToken() else {return}
        profileService.loadMyItems(token: token) { [weak self] (response) in
            self?.view?.hideLoading()
            switch response{
            case.success(let myItems):
                if myItems.count > 0 {
                    self?.view?.hideNoItemLabel()
                    self?.view?.showCollectionView()
                    self?.view?.onGetMyItemSuccess(items: myItems)
                } else {
                     self?.view?.hideCollectionView()
                     self?.view?.showNoItemLabel(message: "You have no items on sale")
                }
            case .error(let error):
                self?.view?.onGetMyItemError(error: error)
            }
        }
    }
    
    func performLoadBought() {
        view?.showLoading()
        guard let token = KeyChainUtil.share.getToken() else {return}
        orderService.getItemsBoughtByMe(token: token) { [weak self] response in
            self?.view?.hideLoading()
            switch response {
            case .success(let orderDetails):
                if orderDetails.count > 0 {
                    self?.view?.hideNoItemLabel()
                    self?.view?.showCollectionView()
                    self?.view?.onGetBoughtItemsSuccess(orderDetails: orderDetails)
                } else {
                    self?.view?.hideCollectionView()
                    self?.view?.showNoItemLabel(message: "You have not bought any item yet")
                }
            case .error(let error):
                self?.view?.onGetMyItemError(error: error)
            }
            
        }
    }
    
    func performLoadSold() {
        view?.showLoading()
        guard let token = KeyChainUtil.share.getToken() else {return}
        orderService.getItemsSoldByMe(token: token) { [weak self] response in
            self?.view?.hideLoading()
            switch response {
            case .success(let orderDetails):
                if orderDetails.count > 0 {
                    self?.view?.hideNoItemLabel()
                    self?.view?.showCollectionView()
                    self?.view?.onGetSoldItemsSuccess(orderDetails: orderDetails)
                } else {
                    self?.view?.hideCollectionView()
                    self?.view?.showNoItemLabel(message: "You have not sold any item yet")
                }
            case .error(let error):
                self?.view?.onGetMyItemError(error: error)
            }
        }
    }
    
    func loadUserInfo(userId: String) {
        self.view?.showLoading()
        self.view?.setUpLoadUserProfile()
        userService.getUserById(id: userId) { [weak self] (response) in
            self?.view?.hideLoading()
            switch response {
            case.success(let user):
                self?.view?.onLoadDataSuccess(userData: user)
            case .error(let error):
                self?.view?.onLoadDataError(error: error)
            }
        }
    }
    
}
