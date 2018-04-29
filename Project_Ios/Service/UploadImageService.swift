//
//  UploadImageService.swift
//  Project_Ios
//
//  Created by iosdev on 29.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation
import Alamofire

protocol UpLoadImgServiceProtocol {
    
    func uploadImg(token: String, imgData: Data,  completion: @escaping (ServerResponse<UploadPhotoResponse>) -> Void)
    
}

class UploadImgService: UpLoadImgServiceProtocol {
    
    let jsonDecoder = JSONDecoder()
    
    func uploadImg(token: String, imgData: Data, completion: @escaping (ServerResponse<UploadPhotoResponse>) -> Void) {
        let headers: HTTPHeaders = ["Authorization":token]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imgData, withName: "photo", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: URLConst.BASE_URL + URLConst.IMAGE_PATH, headers: headers, encodingCompletion: { (encodingResult) in
            switch encodingResult {
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.responseJSON(completionHandler: { (response) in
                    print("IMG UPLOAD RESPONSE: \(response)")
                    switch response.result {
                    case .success:
                        do {
                            let serverResponse = try self.jsonDecoder.decode(Response<UploadPhotoResponse>.self, from: response.data!)
                            let status = serverResponse.status
                            switch status {
                            case 200:
                                guard let uploadPhotoResponse = serverResponse.data else {debugPrint("Error upload photo"); return}
                                completion(ServerResponse.success(uploadPhotoResponse))
                            default:
                                guard let code = serverResponse.code else {print("Error upload photo"); return}
                                let appError = AppError(code: code, status: status)
                                completion(ServerResponse.error(error: appError))
                                debugPrint("Error upload photo")
                            }
                        } catch(let error) {
                            debugPrint(error)
                            return
                        }
                    case .failure(let error):
                        print(error)
                        completion(ServerResponse.error(error: AppError.noInternetConnection))
                    }
                })
            case .failure(let error):
                print(error)
                completion(ServerResponse.error(error: AppError.noInternetConnection))
            }
        })
    }
}
