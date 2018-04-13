//
//  Item.swift
//  Project_Ios
//
//  Created by iosadmin on 13.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

struct Item: Codable {
    var status: String
    var time: String
    var _id: String
    var itemName: String
    var description: String
    var price: Int
    var category: String
    var imgPath: String
    var lat: Double?
    var lng: Double?
    var seller: String
}
