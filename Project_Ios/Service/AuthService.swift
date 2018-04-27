//
//  AuthService.swift
//  Project_Ios
//
//  Created by iosdev on 11.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation
import Alamofire

protocol AuthServiceProtocol {
    
    func login(username: String, password: String,  completion: @escaping (ServerResponse<String>) -> Void)
    
    func register(username: String, password: String, email: String, phoneNumber: String, completion: @escaping (ServerResponse<String>) -> Void)
}

class AuthService: AuthServiceProtocol {
    
    let jsonDecoder = JSONDecoder()
    
    func login(username: String, password: String, completion: @escaping (ServerResponse<String>) -> Void) {
        let parameters: Parameters = ["username": username, "password": password]
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.AUTH_PATH)!,
            method: .post,
            parameters: parameters)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<AuthResponse>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let token = serverResponse.data?.token else {fatalError("Register token error")}
                            completion(ServerResponse.success(token))
                        default:
                            guard let code = serverResponse.code else {print("Error: server code"); return}
                            let appError = AppError(code: code, status: status)
                            completion(ServerResponse.error(error: appError))
                        }
                    } catch let error {
                        print(error)
                        // Error with parse JSON. We donot want user to see this error :)
                    }
                case .failure(let error):
                    print(error)
                    completion(ServerResponse.error(error: AppError.noInternetConnection))
                    print("failure")
                }
        }
        
    }
    
    func register(username: String, password: String, email: String, phoneNumber: String, completion: @escaping (ServerResponse<String>) -> Void) {
        let parameters: Parameters = ["username": username, "password": password, "email": email, "phoneNumber": phoneNumber]
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.USER_PATH)!,
            method: .post,
            parameters: parameters)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let authResponse = try self.jsonDecoder.decode(Response<AuthResponse>.self, from: response.data!)
                        let status = authResponse.status
                        switch status {
                        case 200:
                            guard let token = authResponse.data?.token else {fatalError("Register token error")}
                            completion(ServerResponse.success(token))
                        default:
                            guard let code = authResponse.code else {print("Error: server code"); return}
                            let appError = AppError(code: code, status: status)
                            completion(ServerResponse.error(error: appError))
                        }
                    } catch {
                        // Error with parse JSON. We donot want user to see this error :)
                    }
                case .failure(let error):
                    //No internet connection, handle this later
                    completion(ServerResponse.error(error: AppError.noInternetConnection))
                    print(error) 
                }
        }
    }
}
