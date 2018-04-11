//
//  AppError.swift
//  Project_Ios
//
//  Created by iosdev on 11.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

//list all the error here
enum AppError: Error {
    
    //Global
    case noInternetConnection
    
    //Auth Screen
    case emptyField

}

extension AppError {
    var description: String {
        switch self {
        case .emptyField:
            return "Field should not be empty"
        case .noInternetConnection:
            return "No internet connection"
        default:
            return "Unknown Error"
        }
    }
}
