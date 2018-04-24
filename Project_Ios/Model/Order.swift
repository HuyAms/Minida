//
//  Order.swift
//  Project_Ios
//
//  Created by iosdev on 24.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

struct Order: Codable {
    var _id: String
    var item: String
    var seller: String
    var buyer: String
    var time: String
}
