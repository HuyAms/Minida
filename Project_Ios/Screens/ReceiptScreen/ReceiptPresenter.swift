//
//  ReceiptPresenter.swift
//  Project_Ios
//
//  Created by iosdev on 24.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

protocol ReceiptPresenterProtocol {
    
    func performGetSeller(userId: String)
    
    func performGetItem(itemId: String)
    
}

class ReceiptPresenter: ReceiptPresenterProtocol {
    
    var itemService: ItemServiceProtocol = ItemService()
    var userService: UserServiceProtocol = UserService()
    weak var view: ReceiptVCProtocol?
    
    init(view: ReceiptVCProtocol) {
        self.view = view
    }
    
    func performGetSeller(userId: String) {
        guard let token = KeyChainUtil.share.getToken() else {print("Error get token"); return}
        userService.getUserById(id: userId, token: token) { [weak self] response in
            switch response {
            case .success(let seller):
                self?.view?.onFetchSellerSuccess(seller: seller)
                self?.view?.hideLoading()
            case .error(let error):
                self?.view?.onShowError(error: error)
                self?.view?.hideLoading()
            }
        }
    }
    
    func performGetItem(itemId: String) {
        itemService.getItemById(id: itemId) { [weak self] response in
            switch response {
            case .success(let item):
                self?.view?.onFetchItemSuccess(item: item)
                self?.view?.hideLoading()
            case .error(let error):
                self?.view?.onShowError(error: error)
                self?.view?.hideLoading()
            }
        }
    }
    
}


