//
//  ProfileService.swift
//  Project_Ios
//
//  Created by iosdev on 19.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation
import Alamofire

protocol UserServiceProtocol {
    
    func getUserById(id: String, completion: @escaping (ServerResponse<User>) -> Void)
    
    func getUserMe(token: String, completion: @escaping (ServerResponse<User>) -> Void)
    
    func updateUserMe(token: String, username: String, password: String, email: String, phoneNumber: String, completion: @escaping (ServerResponse<User>) -> Void)
    
    func getLeaderBoardUsers(completion: @escaping (ServerResponse<[User]>) -> Void)
}

class UserService: UserServiceProtocol {
  
    let jsonDecoder = JSONDecoder()
    
    func getUserById(id: String, completion: @escaping (ServerResponse<User>) -> Void) {
        Alamofire.request(
            URL(string: "https://fin-recycler.herokuapp.com/api/users/" + id)!,
            method: .get)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<User>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let user = serverResponse.data else {debugPrint("Error loading user by id"); return}
                            completion(ServerResponse.success(user))
                        default:
                            guard let code = serverResponse.code else {print("Error: server code"); return}
                            let appError = AppError(code: code, status: status)
                            completion(ServerResponse.error(error: appError))
                            debugPrint("Error getting user by id")
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
    
    func getUserMe(token: String, completion: @escaping (ServerResponse<User>) -> Void) {
        let headers: HTTPHeaders = ["authorization": token]
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.USER_ME_PATH)!,
            method: .get,
            headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<User>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let user = serverResponse.data else {debugPrint("Error loading user me"); return}
                            completion(ServerResponse.success(user))
                        default:
                            guard let code = serverResponse.code else {print("Error: server code"); return}
                            let appError = AppError(code: code, status: status)
                            completion(ServerResponse.error(error: appError))
                            debugPrint("Error getting user me")
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
    
    func updateUserMe(token: String, username: String, password: String, email: String, phoneNumber: String, completion: @escaping (ServerResponse<User>) -> Void) {
        let parameters: Parameters = ["username": username, "password": password, "email": email, "phoneNumber": phoneNumber]
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.USER_ME_PATH)!,
            method: .put,
            parameters: parameters)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<User>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let user = serverResponse.data else {debugPrint("Error loading user me"); return}
                            completion(ServerResponse.success(user))
                        default:
                            guard let code = serverResponse.code else {print("Error: server code"); return}
                            let appError = AppError(code: code, status: status)
                            completion(ServerResponse.error(error: appError))
                            debugPrint("Error getting user me")
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
    
    func getLeaderBoardUsers(completion: @escaping (ServerResponse<[User]>) -> Void) {
        let limit = 10
        let parameters: Parameters = ["limit": limit]
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.USER_TOP_PATH)!,
            method: .get,
            parameters: parameters)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<[User]>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let users = serverResponse.data else {debugPrint("Error loading leader board users"); return}
                            completion(ServerResponse.success(users))
                        default:
                            guard let code = serverResponse.code else {print("Error: server code"); return}
                            let appError = AppError(code: code, status: status)
                            completion(ServerResponse.error(error: appError))
                            debugPrint("Error getting leader board users")
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






