//
//  Voucher.swift
//  Project_Ios
//
//  Created by iosdev on 22.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

struct Voucher: Codable {
    var _id: String
    var name: String
    var description: String
    var price: Int
    var imgPath: String
    var discount: String
    var expiration: String
}
