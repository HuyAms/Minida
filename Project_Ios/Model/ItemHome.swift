//
//  ItemHome.swift
//  Project_Ios
//
//  Created by iosdev on 18.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

struct ItemHome: Codable {
    var status: String
    var time: String
    var _id: String
    var itemName: String
    var description: String
    var price: Int
    var category: String
    var imgPath: String
    var seller: User
    var lat: Double?
    var lng: Double?
}
