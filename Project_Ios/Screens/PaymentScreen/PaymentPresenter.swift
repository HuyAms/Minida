//
//  PaymentPresenter.swift
//  Project_Ios
//
//  Created by iosadmin on 21.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

protocol PaymentPresenterProtocol {
    func buyPoint(amount: Int, source: String, completion: @escaping (AppError?) -> Void)
}

class PaymentPresenter: PaymentPresenterProtocol {
    
    weak var view: PaymentVCProtocol?
    
    var paymentService: PaymentServiceProtocol = PaymentService()
    
    init(view: PaymentVCProtocol) {
        self.view = view
    }
    
    func buyPoint(amount: Int, source: String, completion: @escaping (AppError?) -> Void) {
        guard let token = KeyChainUtil.share.getToken() else {return}
        view?.showLoading()
        paymentService.buyPoint(token: token, source: source, amount: amount) { [weak self] (serverResponse) in
            self?.view?.hideLoading()
            switch serverResponse {
            case .success(let user):
                print(user)
                completion(nil)
            case .error(let error):
                completion(error)
            }
        }
    }
    
}
