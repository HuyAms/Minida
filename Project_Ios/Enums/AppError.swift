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
    case emptyField
    
    //Server Error
    case emptyItem
    case invalidPhoneNumber
    case invalidEmail
    case notEnoughPoints
    case usernameIsUsed
    case phoneNumberIsUsed
    case usernameDoesNotExist
    case incorrectPassword
    case cannotFindItem
    case cannotFindVoucher
    case buyOwnItem
    case unknown

}

extension AppError {
    
    init(code: Int, status: Int) {
        switch status {
        case 400:
            switch code {
            case 8:
                self =  .invalidEmail
            case 9:
                self = .invalidPhoneNumber
            case 12:
                self = .buyOwnItem
            case 13:
                self = .notEnoughPoints
            case 14:
                self = .usernameIsUsed
            case 16:
                self = .phoneNumberIsUsed
            case 17:
                self = .usernameDoesNotExist
            default:
                self = .unknown
            }
        case 401:
            switch code {
                case 18:
                self = .incorrectPassword
            default:
                self = .unknown
            }
        case 404:
            switch code {
            case 1:
                self = .cannotFindItem
            case 2:
                self = .cannotFindVoucher
            default:
                self = .unknown
            }
        case 500:
            self = .unknown
        default:
            self = .unknown
        }
    }
    
    var description: String {
        switch self {
        case .emptyField:
            return "Field should not be empty"
        case .noInternetConnection:
            return "No internet connection"
        case .invalidPhoneNumber:
            return "Invalid phone number"
        case .invalidEmail:
            return "Invalid email"
        case .notEnoughPoints:
            return "You do not have enough points to buy this item"
        case .usernameIsUsed:
            return "This username has already been used"
        case .phoneNumberIsUsed:
            return "This phone number has already been used"
        case .usernameDoesNotExist:
            return "Username does not exist"
        case .incorrectPassword:
            return "Password is incorrect"
        case .cannotFindItem:
            return "Item has not beet deleted"
        case .buyOwnItem:
            return "You cannot buy your own item"
        case .cannotFindVoucher:
            return "This voucher is not available"
        case .unknown:
            return "Unknown error"
        default:
            return "Unknown Error"
        }
    }
}
