//
//  PaymentPresenter.swift
//  Project_Ios
//
//  Created by iosadmin on 21.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

protocol PaymentPresenterProtocol {
    func buyPoint(amount: Int, source: String, completion: @escaping (User?, AppError?) -> Void)
    
    func getMe()
}

class PaymentPresenter: PaymentPresenterProtocol {
 
    weak var view: PaymentVCProtocol?
    
    var paymentService: PaymentServiceProtocol = PaymentService()
    var userService: UserServiceProtocol = UserService()
    
    init(view: PaymentVCProtocol) {
        self.view = view
    }
    
    func buyPoint(amount: Int, source: String, completion: @escaping (User?, AppError?) -> Void) {
        guard let token = KeyChainUtil.share.getToken() else {return}
        view?.showLoading()
        paymentService.buyPoint(token: token, source: source, amount: amount) { [weak self] (serverResponse) in
            self?.view?.hideLoading()
            switch serverResponse {
            case .success(let user):
                completion(user, nil)
            case .error(let error):
                completion(nil, error)
            }
        }
    }
    
    func getMe() {
        guard let token = KeyChainUtil.share.getToken() else {return}
        self.view?.showLoading()
        userService.getUserMe(token: token) { [weak self] (response) in
            self?.view?.hideLoading()
            switch response {
            case .success(let user):
                self?.view?.onGetMeSuccess(user: user)
            case .error(let error):
                self?.view?.onGetMeError(error: error)
            }
        }
    }
    
}
