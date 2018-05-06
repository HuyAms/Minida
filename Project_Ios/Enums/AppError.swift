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
    case emptyImage
    case invalidPhoneNumber
    case invalidEmail
    case invalidPrice
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
            return "Field should not be empty".localized
        case .emptyImage:
            return "Image should not be empty".localized
        case .noInternetConnection:
            return "No internet connection".localized
        case .invalidPhoneNumber:
            return "Phone number must have 10 numbers".localized
        case .invalidPrice:
            return "Invalid price".localized
        case .invalidEmail:
            return "Invalid email".localized
        case .notEnoughPoints:
            return "You do not have enough points to buy this item".localized
        case .usernameIsUsed:
            return "This username has already been used".localized
        case .phoneNumberIsUsed:
            return "This phone number has already been used".localized
        case .usernameDoesNotExist:
            return "Username does not exist".localized
        case .incorrectPassword:
            return "Password is incorrect".localized
        case .cannotFindItem:
            return "Item has not beet deleted".localized
        case .buyOwnItem:
            return "You cannot buy your own item".localized
        case .cannotFindVoucher:
            return "This voucher is not available".localized
        case .unknown:
            return "Unknown error".localized
        default:
            return "Unknown Error".localized
        }
    }
}
