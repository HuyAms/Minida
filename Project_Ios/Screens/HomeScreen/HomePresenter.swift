//
//  HomePresenter.swift
//  Project_Ios
//
//  Created by iosdev on 18.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

protocol HomePresenterProtocol {
    
    func performGetAvailableItems()
    
    func performgGetItemsByCategory(category: Category)
    
    func filterContentForSearchText(_ searchText: String, items: [ItemHome])
    
    func performBuyItem(itemId: String)
    
}

class HomePresenter: HomePresenterProtocol {
    
    weak var view: HomeVCProtocol?
    var itemService: ItemServiceProtocol = ItemService()
    var orderService: OrderServiceProtocol = OrderService()
    
    init(view: HomeVCProtocol) {
        self.view = view
    }
    
    //MARK: protocols
    func performGetAvailableItems() {
        view?.showLoading()
        itemService.getAvailableItems(completion: { [weak self] response in
            switch response {
            case .success(let homeItems):
                //print("This is a presenter response: \(homeItems)")
                self?.view?.onGetAvailableItemsSuccess(homeItems: homeItems)
                self?.view?.hideLoading()
            case .error(let error):
                self?.view?.onShowError(error: error)
                self?.view?.hideLoading()
            }
        })
    }
    
    func performgGetItemsByCategory(category: Category) {
        view?.showLoading()
        itemService.getItemsByCategory(category: category, completion: { [weak self] response in
            switch response {
            case .success(let homeItems):
                //print("This is a presenter response: \(homeItems)")
                self?.view?.onGetAvailableItemsSuccess(homeItems: homeItems)
                self?.view?.hideLoading()
            case .error(let error):
                self?.view?.onShowError(error: error)
                self?.view?.hideLoading()
            }
        })
    }
    
    func filterContentForSearchText(_ searchText: String, items: [ItemHome]) {
        let filteredItems = items.filter({( item : ItemHome) -> Bool in
            return item.itemName.lowercased().contains(searchText.lowercased())
        })
        
        
        if filteredItems.count > 0 && !searchText.isEmpty {
            view?.onShowFilteredItems(homeItems: filteredItems)
        } else if searchText.isEmpty {
            view?.onShowFilteredItems(homeItems: items)
        } else {
            view?.onShowFilteringNoResult()
        }
        
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
}

