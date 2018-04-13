//
//  Response.swift
//  Project_Ios
//
//  Created by iosdev on 11.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

struct Response<T: Codable>: Codable {
    var status: Int
    var data: T?
    var description: String?
    var code: Int?
}


