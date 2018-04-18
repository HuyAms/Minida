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
    
}

class HomePresenter: HomePresenterProtocol {
    
    weak var view: HomeVCProtocol?
    var homeService: HomeServiceProtocol = HomeService()
    
    init(view: HomeVCProtocol) {
        self.view = view
    }
    
    //MARK: protocols
    func performGetAvailableItems() {
        view?.showLoading()
        homeService.getAvailableItems(completion: { [weak self] response in
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
}
