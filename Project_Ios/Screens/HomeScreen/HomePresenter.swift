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
    
}

class HomePresenter: HomePresenterProtocol {

    weak var view: HomeVCProtocol?
    var itemService: ItemServiceProtocol = ItemService()
    
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
        } else {
            view?.onShowFilteringNoResult()
        }
       
    }
 
}
