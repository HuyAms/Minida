//
//  User.swift
//  Project_Ios
//
//  Created by iosdev on 11.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

struct User: Codable {
    var _id: String
    var username: String
    var point: Int?
    var email: String?
    var phoneNumber: Int?
    var avatarPath: String?
    var badge: String
    var numberOfRecycledItems: Int
}

