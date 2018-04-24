//
//  PaymentService.swift
//  Project_Ios
//
//  Created by iosadmin on 21.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation
import Alamofire
import Stripe


protocol PaymentServiceProtocol {
    
    func buyPoint(token: String, source: String, amount: Int,  completion: @escaping (ServerResponse<User>) -> Void)

}

class PaymentService: NSObject, PaymentServiceProtocol, STPEphemeralKeyProvider {
    
    let jsonDecoder = JSONDecoder()
    
    func buyPoint(token: String, source: String, amount: Int, completion: @escaping (ServerResponse<User>) -> Void) {
        let url =  URL(string: "https://fin-recycler.herokuapp.com/api/payments")!
        let headers: HTTPHeaders = ["authorization": token]

        let parameters: [String: Any] = [
            "source": source,
            "amount": amount
        ]
        
        Alamofire.request(
            url,
            method: .post,
            parameters: parameters,
            headers: headers)
            .responseJSON { response in
                print("PAYMENT: \(response)")
                switch response.result {
                case .success:
                    do {
                        let serverResponse = try self.jsonDecoder.decode(Response<User>.self, from: response.data!)
                        let status = serverResponse.status
                        switch status {
                        case 200:
                            guard let user = serverResponse.data else {debugPrint("Error buy point"); return}
                            completion(ServerResponse.success(user))
                        default:
                            debugPrint("Error buy point");
                            guard let code = serverResponse.code else {print("Error: server code"); return}
                            let appError = AppError(code: code, status: status)
                            completion(ServerResponse.error(error: appError))
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
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url =  URL(string: "https://fin-recycler.herokuapp.com/api/payments/ephemeral_keys")!
        guard let token = KeyChainUtil.share.getToken() else {return}
        let headers: HTTPHeaders = ["authorization": token]
        Alamofire.request(url, method: .post, parameters: [
            "api_version": apiVersion
            ], headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    print("CREATE CUSTOMER KEY ERROR: \(error.localizedDescription)")
                    completion(nil, error)
                }
        }
    }
}

