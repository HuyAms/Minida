//
//  OrderService.swift
//  Project_Ios
//
//  Created by iosdev on 20.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation
import Alamofire

protocol OrderServiceProtocol {
    
    func getItemsBoughtByMe(token: String, completion: @escaping (ServerResponse<[ItemHome]>) -> Void)
    
    func getItemsSoldByMe(token: String, completion: @escaping (ServerResponse<[ItemHome]>) -> Void)
    
    func getMyVouchers(token: String, completion: @escaping (ServerResponse<[Voucher]>) -> Void)
    
    func buyVoucher(token: String, voucherId: String, completion: @escaping (ServerResponse<VoucherOrder>) -> Void)
}

class OrderService: OrderServiceProtocol {
    let jsonDecoder = JSONDecoder()
    
    func getItemsBoughtByMe(token: String, completion: @escaping (ServerResponse<[ItemHome]>) -> Void) {
        let headers: HTTPHeaders = ["authorization": token]
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.ORDER_PATH + URLConst.BOUGHT_PATH)!,
            method: .get,
            headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<[ItemHome]>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let boughtItems = serverResponse.data else {debugPrint("Error loading bought items"); return}
                            completion(ServerResponse.success(boughtItems))
                        default:
                            debugPrint("Error loading bought Items"); return
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
    
    func getItemsSoldByMe(token: String, completion: @escaping (ServerResponse<[ItemHome]>) -> Void) {
        let headers: HTTPHeaders = ["authorization": token]
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.ORDER_PATH + URLConst.SOLD_PATH)!,
            method: .get,
            headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<[ItemHome]>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let soldItems = serverResponse.data else {debugPrint("Error loading sold items"); return}
                            completion(ServerResponse.success(soldItems))
                        default:
                            guard let code = serverResponse.code else {print("Error: server code"); return}
                            let appError = AppError(code: code, status: status)
                            completion(ServerResponse.error(error: appError))
                            debugPrint("Error loading sold items");
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
    
    func getMyVouchers(token: String, completion: @escaping (ServerResponse<[Voucher]>) -> Void) {
        let headers: HTTPHeaders = ["authorization": token]
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.ORDER_PATH + URLConst.MY_VOUCHER_PATH)!,
            method: .get,
            headers: headers)
            .responseJSON { response in

                switch response.result {
                case .success:
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<[MyVoucherOrder]>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let myVoucherOrders = serverResponse.data else {debugPrint("Error loading my vouchers"); return}
                            
                            var myVouchers = [Voucher]()
                            myVoucherOrders.forEach({ (myVoucherOrder) in
                                myVouchers.append(myVoucherOrder.voucher)
                            })
                            
                    
                            completion(ServerResponse.success(myVouchers))
                        default:
                            guard let code = serverResponse.code else {print("Error: server code"); return}
                            let appError = AppError(code: code, status: status)
                            completion(ServerResponse.error(error: appError))
                            debugPrint("Error loading my vouchers");
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
    
    func buyVoucher(token: String, voucherId: String, completion: @escaping (ServerResponse<VoucherOrder>) -> Void) {
        let headers: HTTPHeaders = ["authorization": token]
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.BUY_VOUCHER_PATH + "/\(voucherId)")!,
            method: .post,
            headers: headers)
            .responseJSON { response in
                print(response)
                switch response.result {
                case .success:
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<VoucherOrder>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let voucherOrder = serverResponse.data else {debugPrint("Error buy vouchers"); return}
                            completion(ServerResponse.success(voucherOrder))
                        default:
                            guard let code = serverResponse.code else {print("Error: server code"); return}
                            let appError = AppError(code: code, status: status)
                            completion(ServerResponse.error(error: appError))
                            debugPrint("Error buy vouchers");
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

