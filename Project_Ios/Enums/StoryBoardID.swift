//
//  StoryBoardId.swift
//  Project_Ios
//
//  Created by Dat Truong on 04/04/2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

enum AppStoryBoard: String{
    case tabBarVC = "tabBarScreen"
    case authVC = "authScreen"
    case onBoardingVC = "onboardingScreen"
    case profileVC = "profileScreen"
    case mapVC = "mapScreen"
    
    var identifier: String {
        return self.rawValue
    }
}

