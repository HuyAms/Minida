//
//  ProfileService.swift
//  Project_Ios
//
//  Created by iosadmin on 12.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation
import Alamofire

protocol ProfileServiceProtocol {
    
    func loadProfileData(token: String, completion: @escaping (ServerResponse<User>) -> Void)
    func loadMyItems(token: String, completion: @escaping (ServerResponse<[Item]>) -> Void)
    
}

class ProfileService: ProfileServiceProtocol {
    
    let jsonDecoder = JSONDecoder()
    
    func loadProfileData(token: String, completion: @escaping (ServerResponse<User>) -> Void) {
        let headers: HTTPHeaders = [
            "authorization": token
        ]
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.USER_ME_PATH)!,method: .get, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<User>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let userData = serverResponse.data else {debugPrint("Error loading profile"); return}
                            completion(ServerResponse.success(userData))
                        default:
                            debugPrint("Error loading profile"); return
                        }
                        
                    } catch(let error) {
                        print("Error decode")
                        // Error with parse JSON.
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
    
    func loadMyItems(token: String, completion: @escaping (ServerResponse<[Item]>) -> Void) {
        let headers: HTTPHeaders = [
            "authorization": token
        ]
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.ITEMS_ME_PATH)!,method: .get, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    print(response)
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<[Item]>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let myItems = serverResponse.data else {debugPrint("Error loading my items"); return}
                            completion(ServerResponse.success(myItems))
                        default:
                            debugPrint("Error loading my items"); return
                        }
                        
                    } catch(let error) {
                        print("Error decode")
                        // Error with parse JSON.
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
