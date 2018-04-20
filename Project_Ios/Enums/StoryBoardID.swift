//
//  StoryBoardId.swift
//  Project_Ios
//
//  Created by Dat Truong on 04/04/2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

enum AppStoryBoard: String{
    case mainVC = "mainScreen"
    case authVC = "authScreen"
    case onBoardingVC = "onboardingScreen"
    case profileVC = "profileScreen"
    case mapVC = "mapScreen"
    case homeVC = "homeScreen"
    case categoryVC = "categoryScreen"
    
    var identifier: String {
        return self.rawValue
    }
}

