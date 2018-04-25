//
//  ItemHome.swift
//  Project_Ios
//
//  Created by iosdev on 18.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

enum Category: String {
    case clothing
    case homewares
    case accessories
    case others
    case free
    case vehicles
    case devices
    case all
    
    var description: String {
        return self.rawValue
    }
}

struct ItemDetail: Codable {
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

struct Item: Codable {
    var status: String
    var time: String
    var _id: String
    var itemName: String
    var description: String
    var price: Int
    var category: String
    var imgPath: String
    var seller: String
    var lat: Double?
    var lng: Double?
}
