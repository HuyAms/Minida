//
//  VoucherService.swift
//  Project_Ios
//
//  Created by iosdev on 22.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation
import Alamofire

protocol VoucherServiceProtocol {
    
    func loadVouchers(completion: @escaping (ServerResponse<[Voucher]>) -> Void)
    
}

class VoucherService: VoucherServiceProtocol {
    
    let jsonDecoder = JSONDecoder()
    
    
    func loadVouchers(completion: @escaping (ServerResponse<[Voucher]>) -> Void) {
     
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.VOUCHER_PATH)!,
            method: .get)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<[Voucher]>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let vouchers = serverResponse.data else {debugPrint("Error loading vouchers"); return}
                            completion(ServerResponse.success(vouchers))
                        default:
                            debugPrint("Error loading vouchers"); return
                        }
                    } catch(let error) {
                        debugPrint(error)
                        return
                    }
                case .failure(let error):
                    print(error)
                    completion(ServerResponse.error(error: AppError.noInternetConnection))
                }
        }
    }
}


