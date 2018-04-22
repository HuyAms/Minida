//
//  Constant.swift
//  Project_Ios
//
//  Created by iosdev on 11.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

class URLConst {
    static let BASE_URL = "https://fin-recycler.herokuapp.com"
    static let USER_PATH = "/api/users"
    static let AUTH_PATH = "/auth/signin"
    static let CENTER_PATH = "/api/centers"
    static let ITEM_PATH = "/api/items"
    static let ITEM_FILTER = "/api/items/filter"
    static let ORDER_PATH = "/api/orders"
    static let BOUGHT_PATH = "/me/buyer"
    static let SOLD_PATH = "/me/seller"
    static let PAYMENT_PATH = "/payments"
    static let PAYMENT_KEY_PATH = "/payments/ephemeral_keys"
    static let VOUCHER_PATH = "/api/vouchers"
}

class KEY {
    static let STRIPE = "pk_test_gcQ0UgwKKmpaenf6vJVZEOly"
    static let CURRENT_EXCHANGE = 5
}
