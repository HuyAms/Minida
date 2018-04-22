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
    
    func buyVouchers(voucherId: String)
}

class VoucherPresenter: VoucherPresenterProtocol {
    
    weak var view: VoucherVCProtocol?
    var voucherService: VoucherServiceProtocol = VoucherService()
    
    init(view: VoucherVCProtocol) {
        self.view = view
    }
    
    func loadVouchers() {
        view?.showLoading()
        voucherService.loadVouchers { [weak self](response) in
            self?.view?.hideLoading()
            switch response {
            case .success(let vouchers):
                self?.view?.onLoadVoucherSuccess(vouchers: vouchers)
            case .error(error: let error):
                 self?.view?.onLoadVoucherError(error: error)
            }
        }
    }
    
    func buyVouchers(voucherId: String) {
        
    }
    
}
