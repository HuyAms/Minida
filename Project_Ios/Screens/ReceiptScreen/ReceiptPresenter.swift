//
//  ReceiptPresenter.swift
//  Project_Ios
//
//  Created by iosdev on 24.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

protocol ReceiptPresenterProtocol {
    
    func performGetOrder(orderId: String)
    
}

class ReceiptPresenter: ReceiptPresenterProtocol {
    
    var orderService: OrderServiceProtocol = OrderService()
    
    weak var view: ReceiptVCProtocol?
    
    init(view: ReceiptVCProtocol) {
        self.view = view
    }
    
    func performGetOrder(orderId: String) {
        view?.showLoading()
        orderService.getOrderById(orderId: orderId) {[weak self] (response) in
            self?.view?.hideLoading()
            switch response {
            case .success(let order):
                self?.view?.onGetOrderSuccess(order: order)
            case .error(let error):
                self?.view?.onShowError(error: error)
            }
        }
    }
    
    
}


