//
//  HomeService.swift
//  Project_Ios
//
//  Created by iosdev on 18.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation
import Alamofire

protocol ItemServiceProtocol {
    
    func getAvailableItems(completion: @escaping (ServerResponse<[ItemHome]>) -> Void)
    
    func getItemsByCategory(category: Category, completion: @escaping (ServerResponse<[ItemHome]>) -> Void)
    
    func getItemsByUserId(token: String, completion: @escaping (ServerResponse<[ItemHome]>) -> Void)
}


class ItemService: ItemServiceProtocol {
    
    let jsonDecoder = JSONDecoder()
    
    func getAvailableItems(completion: @escaping (ServerResponse<[ItemHome]>) -> Void) {
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.ITEM_PATH)!,
            method: .get)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<[ItemHome]>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let homeItems = serverResponse.data else {debugPrint("Error loading items"); return}
                            completion(ServerResponse.success(homeItems))
                        default:
                            debugPrint("Error loading homeItems"); return
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
    
    func getItemsByCategory(category: Category, completion: @escaping (ServerResponse<[ItemHome]>) -> Void) {
        let parameters: Parameters = ["category": category]
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.ITEM_FILTER)!,
            method: .get,
            parameters: parameters)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<[ItemHome]>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let homeItems = serverResponse.data else {debugPrint("Error loading items"); return}
                            homeItems.forEach({ (item) in
                                print(item.category)
                            })
                            completion(ServerResponse.success(homeItems))
                        default:
                            debugPrint("Error loading homeItems"); return
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
    
    func getItemsByUserId(token: String, completion: @escaping (ServerResponse<[ItemHome]>) -> Void) {
        let headers: HTTPHeaders = ["authorization": token]
        Alamofire.request(
            URL(string: "https://fin-recycler.herokuapp.com/api/items/users/:uId")!,
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
                            guard let itemsByUserId = serverResponse.data else {debugPrint("Error loading items by user id"); return}
                            completion(ServerResponse.success(itemsByUserId))
                        default:
                            debugPrint("Error loading items by id"); return
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


