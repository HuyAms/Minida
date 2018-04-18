//
//  HomeService.swift
//  Project_Ios
//
//  Created by iosdev on 18.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation
import Alamofire

protocol HomeServiceProtocol {
    
    func getAvailableItems(completion: @escaping (ServerResponse<[ItemHome]>) -> Void)
    
}


class HomeService: HomeServiceProtocol {
    
    let jsonDecoder = JSONDecoder()
    func getAvailableItems(completion: @escaping (ServerResponse<[ItemHome]>) -> Void) {
        Alamofire.request(
            URL(string: "https://fin-recycler.herokuapp.com/api/items")!,
            method: .get)
            .responseJSON { response in
                print("get items response: \(response)")
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
}
