//
//  ItemDetailPresenter.swift
//  Project_Ios
//
//  Created by Huy Trinh on 29.4.2018.
//  Copyright © 2018 Huy Trinh. All rights reserved.
//

import Foundation

protocol ItemDetailPresenterProtocol {
    
    func getItem(itemId: String)
    
    func performBuyItem(itemId: String)
    
}

class ItemDetailPresenter: ItemDetailPresenterProtocol {
    
    fileprivate weak var view: ItemDetailVCProtocol?
    fileprivate var itemService: ItemServiceProtocol = ItemService()
    fileprivate var orderService: OrderServiceProtocol = OrderService()
    
    init(view: ItemDetailVCProtocol) {
        self.view = view
    }
    
    func performBuyItem(itemId: String) {
        view?.showLoading()
        guard let token = KeyChainUtil.share.getToken() else {print("Error get token"); return}
        orderService.createOrder(token: token, itemId: itemId, completion: { [weak self] response in
            switch response {
            case .success(let order):
                self?.view?.onBuyItemSuccess(order: order)
                self?.view?.hideLoading()
            case .error(let error):
                self?.view?.onShowError(error: error)
                self?.view?.hideLoading()
            }
        })
    }
    
    func getItem(itemId: String) {
        view?.showLoading()
        itemService.getItemById(id: itemId) { [weak self](response) in
            self?.view?.hideLoading()
            switch response {
            case .success(let item):
                self?.view?.onGetItemSuccess(item: item)
            case .error(let error):
                self?.view?.onShowError(error: error)
            }
        }
    }
    
    
}
