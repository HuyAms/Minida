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
    
    func getItemsByUserId(id: String, completion: @escaping (ServerResponse<[ItemHome]>) -> Void)
    
    func getMyItems(token: String, completion: @escaping (ServerResponse<[ItemHome]>) -> Void)
    
    func getItemById(id: String, completion: @escaping (ServerResponse<ItemHome>) -> Void)
    
    func postItemForSale(token: String, itemName: String, description: String, price: Int, itemCategory: String, imgPath: String, lat: Double?, lng: Double?, completion: @escaping (ServerResponse<ItemHome>) -> Void)
    
    func editItem(id: String, token: String, itemName: String?, description: String?, price: Int?, itemCategory: String?, imgPath: String?, lat: Double?, lng: Double?, completion: @escaping (ServerResponse<ItemHome>) -> Void)
    
    func deleteItem(id: String, token: String, completion: @escaping (ServerResponse<ItemHome>) -> Void)
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
        var parameters: Parameters
        
        switch category {
        case .free:
            parameters = ["price": "0"]
        default:
            parameters = ["category": category]
        }
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
                            debugPrint("default case: Error loading homeItems"); return
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
    
    func getItemsByUserId(id: String, completion: @escaping (ServerResponse<[ItemHome]>) -> Void) {
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.ITEMS_BYUSERID + id)!,
            method: .get)
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
                            debugPrint("default case: Error loading items by id"); return
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
    
    func getMyItems(token: String, completion: @escaping (ServerResponse<[ItemHome]>) -> Void) {
        let headers: HTTPHeaders = ["authorization": token]
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.ITEMS_ME)!,
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
                            guard let homeItems = serverResponse.data else {debugPrint("Error loading my items"); return}
                            completion(ServerResponse.success(homeItems))
                        default:
                            debugPrint("default case: Error loading my homeItems"); return
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
    
    func getItemById(id: String, completion: @escaping (ServerResponse<ItemHome>) -> Void) {
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.ITEM_PATH + id)!,
            method: .get)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<ItemHome>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let homeItem = serverResponse.data else {debugPrint("Error loading item"); return}
                            completion(ServerResponse.success(homeItem))
                        default:
                            debugPrint("default case: Error loading homeItem"); return
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
    
    func postItemForSale(token: String, itemName: String, description: String, price: Int, itemCategory: String, imgPath: String, lat: Double?, lng: Double?, completion: @escaping (ServerResponse<ItemHome>) -> Void) {
        let parameters: Parameters = ["itemName": itemName, "description": description, "price": price, "itemCategory": itemCategory, "imgPath": imgPath, "lat": lat ?? "", "lng": lng ?? ""]
        let headers: HTTPHeaders = ["authorization": token]
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.ITEM_PATH)!,
            method: .post,
            parameters: parameters,
            headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<ItemHome>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let newItem = serverResponse.data else {debugPrint("Error creating new item"); return}
                            completion(ServerResponse.success(newItem))
                        default:
                            debugPrint("default case: Error creating new item"); return
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
    
    func editItem(id: String, token: String, itemName: String?, description: String?, price: Int?, itemCategory: String?, imgPath: String?, lat: Double?, lng: Double?, completion: @escaping (ServerResponse<ItemHome>) -> Void) {
        let parameters: Parameters = ["itemName": itemName, "description": description, "itemCategory": itemCategory, "imgPath": imgPath, "lat": lat, "lng": lng]
        let headers: HTTPHeaders = ["authorization": token]
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.ITEM_PATH + id)!,
            method: .put,
            parameters: parameters,
            headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<ItemHome>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let editedItem = serverResponse.data else {debugPrint("error editing item"); return}
                            completion(ServerResponse.success(editedItem))
                        default:
                            debugPrint("default case: error editing item"); return
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
    
    func deleteItem(id: String, token: String, completion: @escaping (ServerResponse<ItemHome>) -> Void) {
        let headers: HTTPHeaders = ["authorization": token]
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.ITEM_PATH + id)!,
            method: .delete,
            headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<ItemHome>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let deletedItem = serverResponse.data else {debugPrint("Error delete item"); return}
                            completion(ServerResponse.success(deletedItem))
                        default:
                            debugPrint("default case: Error delete item"); return
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


