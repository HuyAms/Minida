//
//  UserDefaultProtocol.swift
//  Project_Ios
//
//  Created by Huy Trinh on 11.4.2018.
//  Copyright © 2018 Huy Trinh. All rights reserved.
//

import Foundation

protocol UserDefaultsProtocol {}

extension UserDefaultsProtocol{
    
    private var logInKey: String {
        return "logInKey"
    }
    
    private var onBoardingKey: String {
        return "onBoardingKey"
    }
    
    private var myLatKey: String {
        return "myLatKey"
    }
    
    private var myLngKey: String {
        return "myLngKey"
    }
    
    private var userNameKey: String {
        return "userNameKey"
    }
    
    private var userDefault: UserDefaults {
        return UserDefaults.standard
    }
    
    func setUserName(username: String) {
        userDefault.set(username, forKey: userNameKey)
    }
    
    func getUserName() -> String? {
        return userDefault.string(forKey: userNameKey)
    }
    
    func setLogInSate() {
        userDefault.set(true, forKey: logInKey)
    }
    
    func getLogInState() -> Bool {
        return userDefault.bool(forKey: logInKey)
    }
    
    func setLogOut() {
        userDefault.set(false, forKey: logInKey)
        userDefault.removeObject(forKey: myLatKey)
        userDefault.removeObject(forKey: myLngKey)
    }
    
    func setSeeOnboardingState() {
        userDefault.set(true, forKey: onBoardingKey)
    }
    
    func getSeeOnboardingState() -> Bool {
        return userDefault.bool(forKey: onBoardingKey)
    }
    
    func setMyLat(lat: Double) {
        userDefault.set(lat, forKey: myLatKey)
    }
    
    func setMyLng(lng: Double) {
        userDefault.set(lng, forKey: myLngKey)
    }
    
    func getMyLat() -> Double {
        return userDefault.double(forKey: myLatKey)
    }
    
    func getMyLng() -> Double {
        return userDefault.double(forKey: myLngKey)
    }
}
