//
//  VoucherPresenter.swift
//  Project_Ios
//
//  Created by iosdev on 22.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

protocol VoucherPresenterProtocol {
    
    func loadVouchers()
    
    func loadMyVouchers()
    
    func buyVouchers(voucherId: String)
}

class VoucherPresenter: VoucherPresenterProtocol {
 
    
    weak var view: VoucherVCProtocol?
    var voucherService: VoucherServiceProtocol = VoucherService()
    var orderService: OrderServiceProtocol = OrderService()
    
    init(view: VoucherVCProtocol) {
        self.view = view
    }
    
    func loadVouchers() {
        view?.showLoading()
        voucherService.loadVouchers { [weak self](response) in
            self?.view?.hideLoading()
            switch response {
            case .success(let vouchers):
                if vouchers.count > 0 {
                    self?.view?.onLoadVoucherSuccess(vouchers: vouchers)
                } else {
                    self?.view?.displayNoVoucher()
                }
            case .error(error: let error):
                 self?.view?.onLoadVoucherError(error: error)
            }
        }
    }
    
    func buyVouchers(voucherId: String) {
        view?.showLoading()
        guard let token = KeyChainUtil.share.getToken() else {print("Error get token"); return}
        orderService.buyVoucher(token: token, voucherId: voucherId) { [weak self](response) in
            self?.view?.hideLoading()
            switch response {
            case .success( _):
                self?.view?.onBuyVoucherSuccess()
            case .error(error: let error):
                self?.view?.onBuyVoucherError(error: error)
            }
        }
    }
    
    func loadMyVouchers() {
        view?.showLoading()
        guard let token = KeyChainUtil.share.getToken() else {print("Error get token"); return}
        orderService.getMyVouchers(token: token) { [weak self](response) in
            self?.view?.hideLoading()
            switch response {
            case .success(let vouchers):
                if vouchers.count > 0 {
                    self?.view?.onLoadVoucherSuccess(vouchers: vouchers)
                } else {
                    self?.view?.displayNoVoucher()
                }
            case .error(error: let error):
                self?.view?.onLoadVoucherError(error: error)
            }
        }
    }
    
    
}
