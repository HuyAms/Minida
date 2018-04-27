//
//  Constant.swift
//  Project_Ios
//
//  Created by iosdev on 11.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit

class URLConst {
    static let BASE_URL = "https://fin-recycler.herokuapp.com"
    static let USER_PATH = "/api/users/"
    static let AUTH_PATH = "/auth/signin"
    static let CENTER_PATH = "/api/centers"
    
    static let ITEM_PATH = "/api/items/"
    static let ITEM_FILTER = "/api/items/filter/"
    static let ITEM_USERS = "/api/items/users/"
    
    static let ORDER_PATH = "/api/orders/"
    static let ORDER_PATH_ITEMS = "/api/orders/items/"
    static let BUY_VOUCHER_PATH = "/api/orders/vouchers/"
    static let BOUGHT_PATH = "me/buyer/"
    static let SOLD_PATH = "me/seller/"
    static let MY_VOUCHER_PATH = "me/vouchers/"
    
    static let PAYMENT_PATH = "/payments"
    static let PAYMENT_KEY_PATH = "/payments/ephemeral_keys"
    
    static let NOTIFICATION_PATH = "/api/notifications/"
    static let VOUCHER_PATH = "/api/vouchers"
    
    static let USER_ME_PATH = "/api/users/me"
    static let ITEMS_ME_PATH = "/api/items/me"
}

class KEY {
    static let STRIPE = "pk_test_gcQ0UgwKKmpaenf6vJVZEOly"
    static let CURRENT_EXCHANGE = 5
}

extension UIColor {
    static let appDarkColor = UIColor(red: 70.0 / 255.0, green: 65.0 / 255.0, blue: 125.0 / 255.0, alpha: 1.0)         //#46417d
    static let appDefaultColor = UIColor(red: 77.0 / 255.0, green: 71.0 / 255.0, blue: 136.0 / 255.0, alpha: 1.0)         // #4d4788
    static let appLightColor = UIColor(red: 124.0 / 255.0, green: 114.0 / 255.0, blue: 184.0 / 255.0, alpha: 1.0)         // #7c72b8
    static let appLighterColor = UIColor(red: 192.0 / 255.0, green: 190.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0)         // #C0BEDD
    static let appPinkWhiteColor = UIColor(red: 235.0 / 255.0, green: 234.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)         // #EBEAF4
    static let errorColor = UIColor(red: 255.0 / 255.0, green: 102.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)  //FF6666
}

extension UIImage {
    static func getTouchIdImage() -> UIImage {
        return UIImage(named: "Touch-icon-lg")!
    }
    
    static func getFaceIdImage() -> UIImage {
        return UIImage(named: "FaceIcon")!
    }
    
    static func getMapAnnotationImage() -> UIImage {
        return UIImage(named: "map-location-icon")!
    }
    
    static func getMapBtnImage() -> UIImage {
        return UIImage(named: "Maps-icon")!
    }
    
    static func getOthersIconWhite() -> UIImage {
        return UIImage(named: "other-category-icon")!
    }
    
    static func getOthersIconBlack() -> UIImage {
        return UIImage(named: "other-category-black-icon")!
    }
    
    static func getClothingIconWhite() -> UIImage {
        return UIImage(named: "clothes-category-icon")!
    }
    
    static func getClothingIconBlack() -> UIImage {
        return UIImage(named: "clothes-category-black-icon")!
    }
    
    static func getVehiclesIconWhite() -> UIImage {
        return UIImage(named: "vehicles-category-icon")!
    }
    
    static func getVehiclesIconBlack() -> UIImage {
        return UIImage(named: "vehicles-category-black-icon")!
    }
    
    static func getFreeIconWhite() -> UIImage {
        return UIImage(named: "free-category-icon")!
    }
    
    static func getFreeIconBlack() -> UIImage {
        return UIImage(named: "free-category-black-icon")!
    }
    
    static func getHomewaresIconWhite() -> UIImage {
        return UIImage(named: "homewares-category-icon")!
    }
    
    static func getHomewaresIconBlack() -> UIImage {
        return UIImage(named: "homewares-category-black-icon")!
    }
    
    static func getAccessoriesIconWhite() -> UIImage {
        return UIImage(named: "accessories-category-icon")!
    }
    
    static func getAccessoriesIconBlack() -> UIImage {
        return UIImage(named: "accessories-category-black-icon")!
    }
    
    static func getDevicesIconBlack() -> UIImage {
        return UIImage(named: "device-category-black-icon")!
    }
    
    static func getDevicesIconWhite() -> UIImage {
        return UIImage(named: "device-category-icon")!
    }
    
    static func getAllIconBlack() -> UIImage {
        return UIImage(named: "all-category-black-icon")!
    }
    
    static func getAllIconWhite() -> UIImage {
        return UIImage(named: "all-category-icon")!
    }
    
    static func getErrorIcon() -> UIImage {
        return UIImage(named: "cancel-icon")!
    }
    
    static func getSuccessIcon() -> UIImage {
        return UIImage(named: "success-icon")!
    }
    
    static func getBadgeIcon(badge: Badge) -> UIImage {
        switch badge {
        case .mercury:
            return UIImage(named: "mercury-badge-icon")!
        case .mars:
            return UIImage(named: "mars-badge-icon")!
        case .venus:
            return UIImage(named: "venus-badge-icon")!
        case .earth:
            return UIImage(named: "earth-badge-icon")!
        case .neptune:
            return UIImage(named: "neptune-badge-icon")!
        case .uranus:
            return UIImage(named: "uranus-badge-icon")!
        case .saturn:
            return UIImage(named: "saturn-badge-icon")!
        case .jupiter:
            return UIImage(named: "jupiter-badge-icon")!
        }
    }
}

