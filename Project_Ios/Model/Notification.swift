//
//  Notification.swift
//  Project_Ios
//
//  Created by iosdev on 24.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

struct Notification: Codable {
    var isRead: Bool
    var time: String
    var _id: String
    var notiType: Int
    var order: String
    var notiBody: User
    var item: Item
}

struct UpdateNotiResponse: Codable {
    var status: String
}
