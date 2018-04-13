//
//  Rank.swift
//  Project_Ios
//
//  Created by iosadmin on 13.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

enum Rank: String {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case pro = "Pro"
    
    var description: String {
        return self.rawValue
    }
}
