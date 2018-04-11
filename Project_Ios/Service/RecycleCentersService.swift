//
//  RecycleCentersService.swift
//  Project_Ios
//
//  Created by Huy Trinh on 11.4.2018.
//  Copyright © 2018 Huy Trinh. All rights reserved.
//

import Alamofire

protocol RecycleCenterServiceProtocol {
    
    func loadReycleCenters(completion: @escaping (ServerResponse<[RecycleCenter]>) -> Void)
    
}


class RecycleCenterService: RecycleCenterServiceProtocol {
    
    let jsonDecoder = JSONDecoder()
    
    func loadReycleCenters(completion: @escaping (ServerResponse<[RecycleCenter]>) -> Void) {
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.CENTER_PATH)!,
            method: .get)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<[RecycleCenter]>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let centerList = serverResponse.data else {debugPrint("Error loading recycle centers"); return}
                            completion(ServerResponse.success(centerList))
                        default:
                            debugPrint("Error loading recycle centers"); return
                        }
                        
                        
                    } catch(let error) {
                        // Error with parse JSON. We donot want user to see this error :)
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
