//
//  KeyChainUtil.swift
//  Project_Ios
//
//  Created by iosdev on 12.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation
import KeychainAccess

class KeyChainUtil: UserDefaultsProtocol {
    static let share = KeyChainUtil() //Try to create a singleton here
    private let service = "com.team7.minida"
    private let tokenKey = "tokenKey"
    
    var keychain: Keychain {
        return Keychain(service: service)
    }
    
    func setToken(token: String) {
        do {
            try keychain.set(token, key: tokenKey)
        }
        catch let error {
            print(error)
        }
    }
    
    func getToken() -> String? {
        do {
            let token = try keychain.get(tokenKey)
            return token
        }
        catch let error {
            print(error)
            return nil
        }
    }
    
    func removeToken() {
        do {
            try keychain.remove(tokenKey)
        } catch let error {
            print("error: \(error)")
        }
    }
}

