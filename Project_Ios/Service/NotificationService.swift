//
//  NotificationService.swift
//  Project_Ios
//
//  Created by iosdev on 20.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation
import Alamofire

protocol NotificationServiceProtocol {
    
    func getMyNotifications(token: String, completion: @escaping (ServerResponse<[Notification]>) -> Void)
    
    func updateMyNotifications(token: String, id: String, completion: @escaping (ServerResponse<UpdateNotiResponse>) -> Void)
}

class NotificationService: NotificationServiceProtocol {
    
    let jsonDecoder = JSONDecoder()
    
    func getMyNotifications(token: String, completion: @escaping (ServerResponse<[Notification]>) -> Void) {
        let headers: HTTPHeaders = ["authorization": token]
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.NOTIFICATION_PATH)!,
            method: .get,
            headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<[Notification]>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let myNotifications = serverResponse.data else {debugPrint("Error loading my notifications"); return}
                            completion(ServerResponse.success(myNotifications))
                        default:
                            guard let code = serverResponse.code else {print("Error: server code"); return}
                            let appError = AppError(code: code, status: status)
                            completion(ServerResponse.error(error: appError))
                            debugPrint("default case: Error loading my notifications")
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
    
    func updateMyNotifications(token: String, id: String, completion: @escaping (ServerResponse<UpdateNotiResponse>) -> Void) {
        let headers: HTTPHeaders = ["authorization": token]
        Alamofire.request(
            URL(string: URLConst.BASE_URL + URLConst.NOTIFICATION_PATH + id)!,
            method: .put,
            headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<UpdateNotiResponse>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let updatedNotification = serverResponse.data else {debugPrint("Error updating notification"); return}
                            completion(ServerResponse.success(updatedNotification))
                        default:
                            guard let code = serverResponse.code else {print("Error: server code"); return}
                            let appError = AppError(code: code, status: status)
                            completion(ServerResponse.error(error: appError))
                            debugPrint("default case: Error updating notification")
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
