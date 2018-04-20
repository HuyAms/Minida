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
                    print("failure")
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
                            debugPrint("Error loading sold items"); return
                        }
                    } catch(let error) {
                        debugPrint(error)
                        return
                    }
                case .failure(let error):
                    print(error)
                    completion(ServerResponse.error(error: AppError.noInternetConnection))
                    print("failure")
                }
        }
    }
}

