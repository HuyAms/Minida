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
    
    func login(username: String, password: String,  completion: @escaping (ServerResponse<Any>) -> Void)
    
    func register(username: String, password: String, email: String, phoneNumber: String, completion: @escaping (ServerResponse<Any>) -> Void)
}

class AuthService: AuthServiceProtocol {
    
    let jsonDecoder = JSONDecoder()
    
    func login(username: String, password: String, completion: @escaping (ServerResponse<Any>) -> Void) {
        let parameters: Parameters = ["username": username, "password": password]
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.AUTH_PATH)!,
            method: .post,
            parameters: parameters)
            .responseJSON { response in
                //print(response)
                switch response.result {
                case .success:
                    print(response)
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<AuthResponse>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let token = serverResponse.data?.token else {fatalError("Register token error")}
                            print(token)
                        default:
                            guard let description = serverResponse.description else {fatalError("Register description error")}
                             print(description)
                            //completion(ServerResponse.error(error: <#T##AppError#>))
                        }
                    

                    } catch {
                        // Error with parse JSON. We donot want user to see this error :)
                    }
                case .failure(let error):
                    print(error)
                    completion(ServerResponse.error(error: AppError.noInternetConnection))
                    print("failure")
                }
        }
        
    }
    
    func register(username: String, password: String, email: String, phoneNumber: String, completion: @escaping (ServerResponse<Any>) -> Void) {
        let parameters: Parameters = ["username": username, "password": password, "email": email, "phoneNumber": phoneNumber]
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.USER_PATH)!,
            method: .post,
            parameters: parameters)
            .responseJSON { response in
                //response is description or data
                //get status and check if it is 200
                //if not then it error -> show error to user
                //if it is 200, show success
                switch response.result {
                case .success:
                    print(response)
//                    do {
//                        let authResponse = try self.jsonDecoder.decode(AuthResponse.self, from: response.data!)
//                        completion(ServerResponse.success(authResponse.token)) //send the token
//                    } catch {
//                        // Error with parse JSON. We donot want user to see this error :)
//                    }
                    completion(ServerResponse.success("Register success")) //can put object or anything, forexample: String
                case .failure(let error):
                    //No internet connection, handle this later
                    completion(ServerResponse.error(error: AppError.noInternetConnection))
                    print(error) //we have strange error
                }
        }
    }
}
